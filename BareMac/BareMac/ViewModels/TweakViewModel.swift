import SwiftUI
import Foundation

@MainActor
final class TweakViewModel: ObservableObject {
    @Published var tweaks = TweaksData.sample
}
