//
//  DefaultTargetLearner.swift
//  SKRRROCK
//
//  Created by Jun on 8/8/25.
//

import Foundation

enum DefaultTargetLearner: String, CaseIterable {
    case gwangro, sena, eddey, cherry
    
    var name: String {
        switch self {
        case .gwangro: return "광로"
        case .sena: return "세나"
        case .eddey: return "에디"
        case .cherry: return "체리"
        }
    }
    
    var emoji: String {
        switch self {
        case .gwangro: return "Gwangro"
        case .sena: return "Sena"
        case .eddey: return "Eddey"
        case .cherry: return "Cherry"
        }
    }
    
    var audioFileName: String {
        return "\(rawValue)_laugh.m4a"
    }
}
