import SwiftUI

@main
struct BareMacApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .frame(minWidth: 900, minHeight: 600)
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified)
    }
}
