import SwiftUI

// MARK: - ContentView

struct ContentView: View {
    @State private var showIntro = true
    @State private var selectedCategoryIndex = 0
    @State private var searchText = ""
    @State private var categories = defaultCategories
    @State private var toastText: String? = nil
    @FocusState private var isSearchFocused: Bool

    private func binding(for tweak: Tweak) -> Binding<Tweak>? {
        for catIndex in categories.indices {
            if let tweakIndex = categories[catIndex].tweaks.firstIndex(where: { $0.id == tweak.id }) {
                return $categories[catIndex].tweaks[tweakIndex]
            }
        }
        return nil
    }

    private func checkAllTweaks() async {
        var newCategories = categories
        for catIndex in newCategories.indices {
            for tweakIndex in newCategories[catIndex].tweaks.indices {
                let isEnabled = await newCategories[catIndex].tweaks[tweakIndex].check()
                newCategories[catIndex].tweaks[tweakIndex].isSelected = isEnabled
            }
        }
        withAnimation {
            categories = newCategories
        }
    }

    // MARK: Main View

    var mainView: some View {
        NavigationSplitView {
            SidebarView(
                searchText: $searchText,
                selectedCategoryIndex: $selectedCategoryIndex,
                isSearchFocused: _isSearchFocused,
                categories: categories,
                showIntro: $showIntro
            )
        } detail: {
            let filteredTweaks: [Tweak] =
                (searchText.isEmpty && isSearchFocused) || !searchText.isEmpty
                ? categories.flatMap { $0.tweaks }
                    .filter {
                        searchText.isEmpty ||
                        $0.name.lowercased().contains(searchText.lowercased()) ||
                        $0.description.lowercased().contains(searchText.lowercased())
                    }
                : categories[selectedCategoryIndex].tweaks

            let headerTitle: String = (searchText.isEmpty && isSearchFocused) || !searchText.isEmpty
                ? "Search Results"
                : categories[selectedCategoryIndex].name

            ScrollView {
                Section(
                    header: Text(headerTitle)
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 16),
                    footer: filteredTweaks.isEmpty ? nil :
                        Text("Applied tweaks take effect immediately.")
                        .font(.system(.caption, design: .monospaced))
                        .opacity(0.6)
                ) {
                    VStack(spacing: 6) {
                        ForEach(filteredTweaks.indices, id: \.self) { idx in
                            if let binding = binding(for: filteredTweaks[idx]) {
                                TweakRow(tweak: binding) { message in
                                    withAnimation {
                                        toastText = message
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                            toastText = nil
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.bottom, 12)
                .id(searchText)
                .transition(.opacity)

                if filteredTweaks.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        Text("No tweaks found.")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        Text("Try a different keyword.")
                            .font(.system(.subheadline, design: .monospaced))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 60)
                    .padding(.horizontal, 20)
                }
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(minWidth: 700, minHeight: 500)
        .task {
            await checkAllTweaks()
        }
    }

    // MARK: Body

    var body: some View {
        ZStack {
            if showIntro {
                IntroView(showIntro: $showIntro)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            } else {
                mainView
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showIntro)
        .animation(.easeInOut(duration: 0.3), value: selectedCategoryIndex)
        .overlay(alignment: .bottom) {
            if let toast = toastText {
                Text(toast)
                    .font(.system(.caption, design: .monospaced))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color(nsColor: .controlBackgroundColor).opacity(0.85))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    .transition(.opacity)
                    .padding(.bottom, 40)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

