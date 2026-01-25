import SwiftUI
import Combine

@MainActor
class AppViewModel: ObservableObject {
    @Published var categories: [TweakCategory] = []
    @Published var selectedCategory: TweakCategory?
    @Published var searchText: String = ""
    @Published var activeTweaks: Set<UUID> = []
    
    init() {
        self.categories = TweakRepository.categories
        self.selectedCategory = categories.first
        Task {
            await checkAllTweaks()
        }
    }
    
    var filteredTweaks: [Tweak] {
        if !searchText.isEmpty {
            return categories.flatMap { $0.tweaks }.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        } else {
            return selectedCategory?.tweaks ?? []
        }
    }
    
    func toggleTweak(_ tweak: Tweak) async {
        let isActive = activeTweaks.contains(tweak.id)
        
        if isActive {
            await tweak.revert()
            activeTweaks.remove(tweak.id)
        } else {
            await tweak.apply()
            activeTweaks.insert(tweak.id)
        }
    }
    
    private func checkAllTweaks() async {
        for category in categories {
            for tweak in category.tweaks {
                if await tweak.check() {
                    activeTweaks.insert(tweak.id)
                }
            }
        }
    }
    
    func isTweakActive(_ tweak: Tweak) -> Bool {
        return activeTweaks.contains(tweak.id)
    }
}
