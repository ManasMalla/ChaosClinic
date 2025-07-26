import SwiftUI

struct ChaosClinicTheme{
    static func getColor(red: Int, green: Int, blue: Int, alpha: CGFloat)-> Color{
        return Color(uiColor: UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: alpha))
    }
    static let primary = getColor(red: 12, green: 111, blue: 249, alpha: 1)
    static let orange = getColor(red: 255, green: 115,blue: 2, alpha: 1)
    static let pastelBlue = getColor(red: 171, green: 206, blue: 255, alpha: 0.34)
    static let aiPurpleAccent = getColor(red: 73, green: 11, blue: 127, alpha: 1.0)
    static let bugHoleColor = getColor(red: 226, green: 169, blue: 0, alpha: 1.0)
    static let nonBugHoleColor = getColor(red: 226, green: 169, blue: 0, alpha: 0.5)
}
