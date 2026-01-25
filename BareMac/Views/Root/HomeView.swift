import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = AppViewModel()
    
    var body: some View {
        HStack(spacing: 0) {
            Sidebar(viewModel: viewModel)
                .frame(width: 220)
            
            Divider()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text(viewModel.searchText.isEmpty ? (viewModel.selectedCategory?.name ?? "Tweaks") : "Search Results")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    SearchBar(text: $viewModel.searchText)
                        .frame(width: 250)
                }
                .padding()
                .background(Color(nsColor: .windowBackgroundColor))
                
                // Content
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 16)], spacing: 16) {
                        ForEach(viewModel.filteredTweaks) { tweak in
                            TweakCard(
                                tweak: tweak,
                                isActive: viewModel.isTweakActive(tweak),
                                onToggle: {
                                    Task {
                                        await viewModel.toggleTweak(tweak)
                                    }
                                }
                            )
                        }
                    }
                    .padding()
                }
            }
        }
        .frame(minWidth: 900, minHeight: 600)
        .task {
            await viewModel.loadInitialData()
        }
    }
}
