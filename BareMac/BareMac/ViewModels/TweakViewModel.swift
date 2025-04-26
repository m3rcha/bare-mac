import SwiftUI
import Foundation

@MainActor
final class TweakViewModel: ObservableObject {
    @Published var tweaks = TweaksData.sample
    func toggle(_ tweak: Tweak) {
        Task { _ = await TweakExecutor.run(tweak.command) }
    }
}
