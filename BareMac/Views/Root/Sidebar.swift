import SwiftUI

struct Sidebar: View {
    @ObservedObject var viewModel: AppViewModel
    
    @State private var showResetAlert = false
    
    var body: some View {
        List(selection: Binding(
            get: { viewModel.selectedCategory },
            set: { viewModel.selectCategory($0) }
        )) {
            ForEach(viewModel.categories) { category in
                Label(category.name, systemImage: category.icon)
                    .tag(category)
                    .padding(.vertical, 4)
            }
        }
        .listStyle(.sidebar)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 0) {
                Divider()
                VStack(spacing: 8) {
                    Button(role: .destructive) {
                        showResetAlert = true
                    } label: {
                        Label("Reset All Settings", systemImage: "arrow.counterclockwise")
                    }
                    .buttonStyle(.borderless)
                    .controlSize(.small)
                    .foregroundStyle(.red)
                    
                    VStack(spacing: 2) {
                        Text("BareMac v0.3 early-alpha")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.primary)
                        
                        Text("© 2026 mercha")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 12)
            }
            .frame(maxWidth: .infinity)
            .background(.regularMaterial)
        }
        .alert("Reset All Settings?", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                Task {
                    await viewModel.resetAllTweaks()
                }
            }
        } message: {
            Text("This will revert all applied tweaks to their system defaults. This action cannot be undone.")
        }
    }
}
