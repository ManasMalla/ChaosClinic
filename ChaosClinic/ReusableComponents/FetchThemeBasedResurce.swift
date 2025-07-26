import SwiftUI

func fetchThemeBasedResource<T>(colorScheme: ColorScheme, light: T, dark: T)->T{
    return colorScheme == .dark ? dark : light
}
