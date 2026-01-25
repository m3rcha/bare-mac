import SwiftUI

struct Sidebar: View {
    @ObservedObject var viewModel: AppViewModel
    
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
                VStack(spacing: 2) {
                    Text("BareMac v0.3 early-alpha")
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    Text("© 2026 mercha")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 12)
            }
            .frame(maxWidth: .infinity)
            .background(.regularMaterial)
        }
    }
}
