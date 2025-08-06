import SwiftUI

@MainActor
final class TweakViewModel: ObservableObject {
    @Published var tweaks = TweaksData.sample
}
