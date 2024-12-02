import SwiftUI

class NavigationState: ObservableObject {
    @Published var currentTab: Int = 0
    @Published var isLoggedIn: Bool = false
    @Published var showingSplashScreen: Bool = true
} 
