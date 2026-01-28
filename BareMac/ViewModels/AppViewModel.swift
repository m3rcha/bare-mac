import SwiftUI
import Combine

@MainActor
class AppViewModel: ObservableObject {
    // MARK: - UserDefaults Keys
    private static let activeTweaksKey = "activeTweakIDs"
    private static let communityRepoURLKey = "communityRepoURL"
    
    // MARK: - Published Properties
    @Published var categories: [TweakCategory] = []
    @Published var selectedCategory: TweakCategory?
    @Published var searchText: String = ""
    @Published var activeTweaks: Set<String> = [] {
        didSet {
            // Persist active tweaks whenever they change
            saveActiveTweaks()
        }
    }
    @Published var showCommunityTweaks: Bool = false {
        didSet {
            if showCommunityTweaks {
                Task { await loadCommunityTweaks() }
            } else {
                // Remove community tweaks from display
                // For simplicity, reload legacy only
                Task { await loadInitialData() }
            }
        }
    }
    
    private let legacySource = LegacyTweakSource()
    
    private var legacyTweaks: [Tweak] = []
    private var communityTweaks: [Tweak] = []
    
    init() {
        // Restore persisted active tweaks
        restoreActiveTweaks()
        
        // Migration: Fix incorrect default URL from previous builds if it exists
        // We also want to migrate from the "main" branch URL to this specific commit URL if desired, 
        // or just ensure this new one is the target for any resets/fresh installs.
        let oldBadURL = "https://raw.githubusercontent.com/m3rcha/bare-mac-tweaks/main/tweaks.json"
        let previousAttemptURL = "https://raw.githubusercontent.com/m3rcha/baremac-tweaks/main/tweaks.json"
        
        let targetURL = "https://raw.githubusercontent.com/m3rcha/baremac-tweaks/3ade8c2086e18cad073cb05f3f12e74be33f04ee/tweaks.json"
        
        let currentURL = UserDefaults.standard.string(forKey: "communityRepoURL")
        
        // Migrate if legacy bad URL OR if we want to force this specific commit for the user now
        if currentURL == oldBadURL || currentURL == previousAttemptURL {
            UserDefaults.standard.set(targetURL, forKey: "communityRepoURL")
            print("Migrated communityRepoURL to correct path: \(targetURL)")
        }
    }
    
    func loadInitialData() async {
        do {
            self.legacyTweaks = try await legacySource.loadTweaks()
            updateDisplayedTweaks()
        } catch {
            print("Failed to load tweaks: \(error)")
        }
    }
    
    func loadCommunityTweaks() async {
        let defaultURL = "https://raw.githubusercontent.com/m3rcha/baremac-tweaks/3ade8c2086e18cad073cb05f3f12e74be33f04ee/tweaks.json"
        let urlString = UserDefaults.standard.string(forKey: "communityRepoURL") ?? defaultURL
        
        guard let url = URL(string: urlString) else {
            print("Invalid community repo URL: \(urlString)")
            return
        }
        
        let source = CommunityTweakSource(url: url)
        
        do {
            self.communityTweaks = try await source.loadTweaks()
            await MainActor.run {
                updateDisplayedTweaks()
            }
        } catch {
            print("Failed to load community tweaks: \(error)")
        }
    }
    
    private func updateDisplayedTweaks() {
        var allTweaks = legacyTweaks
        if showCommunityTweaks {
            allTweaks.append(contentsOf: communityTweaks)
        }
        
        // Remove duplicates if any (based on ID)
        // Prefer local/legacy if conflict? Or remote? 
        // Let's assume distinct IDs or distinct sets for now.
        
        self.categories = groupTweaksIntoCategories(allTweaks)
        if selectedCategory == nil {
            self.selectedCategory = categories.first
        }
    }
    
    private func groupTweaksIntoCategories(_ tweaks: [Tweak]) -> [TweakCategory] {
        let grouped = Dictionary(grouping: tweaks, by: { $0.category })
        return grouped.map { key, value in
            TweakCategory(name: key, icon: iconForCategory(key), tweaks: value)
        }.sorted { $0.name < $1.name }
    }
    
    private func iconForCategory(_ category: String) -> String {
        switch category.lowercased() {
        case "dock": return "dock.rectangle"
        case "finder": return "magnifyingglass"
        case "system": return "gear"
        case "interface": return "macwindow"
        case "performance": return "speedometer"
        default: return "gearshape"
        }
    }
    
    func selectCategory(_ category: TweakCategory?) {
        if selectedCategory != category {
            selectedCategory = category
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
        // For now, toggle based on current simple state or just apply/revert
        let isCurrentlyActive = activeTweaks.contains(tweak.id)
        
        if isCurrentlyActive {
            await revertBaseTweak(tweak)
        } else {
            await applyBaseTweak(tweak)
        }
    }
    
    func applyTweak(_ tweak: Tweak, params: [String: Any]? = nil) async {
        await applyBaseTweak(tweak, params: params)
    }
    
    func revertTweak(_ tweak: Tweak) async {
        await revertBaseTweak(tweak)
    }
    
    private func applyBaseTweak(_ tweak: Tweak, params: [String: Any]? = nil) async {
        for op in tweak.apply {
            _ = await TweakRunner.shared.executeOperation(op, context: params)
        }
        activeTweaks.insert(tweak.id)
    }
    
    private func revertBaseTweak(_ tweak: Tweak) async {
        for op in tweak.revert {
            _ = await TweakRunner.shared.executeOperation(op)
        }
        activeTweaks.remove(tweak.id)
    }
    
    func isTweakActive(_ tweak: Tweak) -> Bool {
        return activeTweaks.contains(tweak.id)
    }
    
    func resetAllTweaks() async {
        // Iterate over all known tweaks and revert them if active
        // Flatten all tweaks from categories
        let allTweaks = categories.flatMap { $0.tweaks }
        
        for tweak in allTweaks {
            if activeTweaks.contains(tweak.id) {
                await revertTweak(tweak)
            }
        }
    }
    
    // MARK: - State Persistence
    
    /// Saves active tweak IDs to UserDefaults
    private func saveActiveTweaks() {
        let tweakIDs = Array(activeTweaks)
        UserDefaults.standard.set(tweakIDs, forKey: Self.activeTweaksKey)
        ConsoleLogger.shared.log("Saved \(tweakIDs.count) active tweak(s) to storage")
    }
    
    /// Restores active tweak IDs from UserDefaults
    private func restoreActiveTweaks() {
        if let savedIDs = UserDefaults.standard.stringArray(forKey: Self.activeTweaksKey) {
            // Temporarily disable the didSet observer during restoration
            // by setting the backing storage directly isn't possible with @Published,
            // so we'll just set it - the save will be a no-op since values are the same
            activeTweaks = Set(savedIDs)
            print("Restored \(savedIDs.count) active tweak(s) from storage")
        }
    }
}
