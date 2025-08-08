import SwiftUI

struct GraphView: View {
    var data: [Float]
    var label: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.subheadline)
                .padding(.bottom, 2)
            GeometryReader { geo in
                Path { path in
                    guard data.count > 1 else { return }
                    let widthStep = geo.size.width / CGFloat(data.count - 1)
                    let maxVal = (data.max() ?? 1)
                    let minVal = (data.min() ?? 0)
                    let range = maxVal - minVal == 0 ? 1 : maxVal - minVal
                    for i in data.indices {
                        let x = CGFloat(i) * widthStep
                        let y = geo.size.height * (1 - CGFloat((data[i] - minVal) / range))
                        if i == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(Color.blue, lineWidth: 2)
            }
            .frame(height: 100)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(5)

            // 데이터 리스트 추가
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack(alignment: .leading, spacing: 2) {
                    ForEach(Array(data.enumerated()), id: \.offset) { index, value in
                        Text("Index \(index): \(String(format: "%.3f", value))")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(maxHeight: 120)
        }
        .padding(.horizontal)
    }
}
