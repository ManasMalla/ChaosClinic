import SwiftUI

struct SplashView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            ChaosClinicLogo(maxWidth: 200)
        }
    }
}

#Preview{
    SplashView()
}
