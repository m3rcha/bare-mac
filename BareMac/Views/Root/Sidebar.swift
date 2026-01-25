import SwiftUI

struct Sidebar: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        List(selection: $viewModel.selectedCategory) {
            ForEach(viewModel.categories) { category in
                Label(category.name, systemImage: category.icon)
                    .tag(category)
                    .padding(.vertical, 4)
            }
        }
        .listStyle(.sidebar)
        .frame(minWidth: 200)
    }
}
