//
//  Emotion.swift
//  Chaos Clinic
//
//  Created by Manas Malla on 15/07/25.
//

enum Emotion{
    case Happy
    case Sad
    case Anxious
    case Calm
    case Angry
    case Guilty
    case Excited
    case Stressed
    case Worried
    case Lonely
    case Frustrated
    case Unknown
}

extension Emotion{
    var rawValue: String {
        switch self {
        case .Happy:
            return "Happy"
        case .Sad:
            return "Sad"
        case .Anxious:
            return "Anxious"
        case .Calm:
            return "Calm"
        case .Angry:
            return "Angry"
        case .Guilty:
            return "Guilty"
        case .Excited:
            return "Excited"
        case .Stressed:
            return "Stressed"
        case .Worried:
            return "Worried"
        case .Lonely:
            return "Lonely"
        case .Frustrated:
            return "Frustrated"
        case .Unknown:
            return "Unknown"
        }
    }
    
    func getPleasantness()->Double{
        switch(self){
        case .Happy:
            return 0.3
        case .Sad:
            return -0.3
        case .Anxious:
            return -0.5
        case .Calm:
            return 0.5
        case .Angry:
            return -0.5
        case .Guilty:
            return -0.2
        case .Excited:
            return 0.7
        case .Stressed:
            return -0.6
        case .Worried:
            return -0.6
        case .Lonely:
            return -0.7
        case .Frustrated:
            return -1.0
        case .Unknown:
            return 0.0
        }
    }
}

extension String{
    var emotion: Emotion{
        switch self{
        case "Happy":
            return .Happy
        case "Sad":
            return .Sad
        case "Anxious":
            return .Anxious
        case "Calm":
            return .Calm
        case "Angry":
            return .Angry
        case "Guilty":
            return .Guilty
        case "Excited":
            return .Excited
        case "Stressed":
            return .Stressed
        case "Worried":
            return .Worried
        case "Lonely":
            return .Lonely
        case "Frustrated":
            return .Frustrated
        default:
            return .Unknown
        }
    }
}

#if canImport(HealthKit)
import HealthKit
extension Emotion {
    var hkLabel: HKStateOfMind.Label? {
        switch self {
        case .Happy:
            return .happy
        case .Sad:
            return .sad
        case .Anxious:
            if #available(iOS 17.0, *) { return .anxious } else { return nil }
        case .Calm:
            if #available(iOS 17.0, *) { return .calm } else { return nil }
        case .Angry:
            if #available(iOS 17.0, *) { return .angry } else { return nil }
        case .Guilty:
            if #available(iOS 17.0, *) { return .guilty } else { return nil }
        case .Excited:
            if #available(iOS 17.0, *) { return .excited } else { return nil }
        case .Stressed:
            if #available(iOS 17.0, *) { return .stressed } else { return nil }
        case .Worried:
            if #available(iOS 17.0, *) { return .worried } else { return nil }
        case .Lonely:
            if #available(iOS 17.0, *) { return .lonely } else { return nil }
        case .Frustrated:
            if #available(iOS 17.0, *) { return .frustrated } else { return nil }
        case .Unknown:
            return nil
        }
    }
}
#endif

// Use Emotion.hkLabel to get HKStateOfMind.Label mapping for HealthKit
