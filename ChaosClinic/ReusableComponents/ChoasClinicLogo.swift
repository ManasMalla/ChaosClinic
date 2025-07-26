import SwiftUI

struct ChaosClinicLogo: View{
    @Environment(\.colorScheme) var environmentColorScheme
    var colorScheme: ColorScheme?
    var maxWidth: CGFloat?
    var maxHeight: CGFloat?
    init(colorScheme: ColorScheme? = nil, maxWidth: CGFloat? = nil, maxHeight: CGFloat? = nil) {
        self.colorScheme = colorScheme
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
    }
    var body: some View {
        Image(fetchThemeBasedResource(colorScheme: colorScheme ?? environmentColorScheme, light: "chaos-clinic-black-logo", dark: "chaos-clinic-white-logo")).resizable().aspectRatio(contentMode: .fit).frame(maxWidth: maxWidth, maxHeight: maxHeight, alignment: .leading)
    }
}
