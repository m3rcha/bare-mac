import SwiftUI

struct SidebarView: View {
    @Binding var searchText: String
    @Binding var selectedCategoryIndex: Int
    @FocusState var isSearchFocused: Bool
    let categories: [TweakCategory]
    @Binding var showIntro: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 10) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .imageScale(.medium)

                    TextField("Search tweaks…", text: $searchText)
                        .focused($isSearchFocused)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.primary)
                }
                .padding(8)
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal, 8)
                .padding(.bottom, 8)

                ScrollView {
                    LazyVStack(spacing: 6) {
                        ForEach(categories.indices, id: \.self) { idx in
                            Button(action: {
                                selectedCategoryIndex = idx
                                isSearchFocused = false
                            }) {
                                SidebarRow(
                                    title: categories[idx].name,
                                    isSelected: selectedCategoryIndex == idx
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 6)
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, 8)
        }
        .frame(minWidth: 200)
        .background(Color(hex: 0x1f1f1e))
    }
}

struct SidebarRow: View {
    let title: String
    let isSelected: Bool

    var body: some View {
        HStack {
            Spacer()
            Text(title)
                .font(.system(size: 14, weight: .semibold, design: .monospaced))
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle()) // Makes entire area tappable
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(isSelected ? Color.accentColor.opacity(0.18) : Color.clear)
        )
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double(hex & 0xff) / 255,
            opacity: alpha
        )
    }
}
