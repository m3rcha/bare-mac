import SwiftUI

// MARK: - TweakRow View

struct TweakRow: View {
    @Binding var tweak: Tweak

    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                tweak.isSelected.toggle()
                let task = Process()
                task.standardOutput = FileHandle.nullDevice
                task.standardError = FileHandle.nullDevice
                task.launchPath = "/bin/zsh"
                task.arguments = ["-c", tweak.isSelected ? tweak.command : tweak.revertCommand]
                try? task.run()
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: tweak.isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(tweak.isSelected ? .accentColor : .secondary)
                VStack(alignment: .leading, spacing: 2) {
                    Text(tweak.name)
                        .font(.headline)
                    Text(tweak.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(nsColor: .controlBackgroundColor).opacity(0.1))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - ContentView

struct ContentView: View {
    @State private var showIntro = true
    @State private var selectedCategoryIndex = 0
    @State private var searchText = ""
    @State private var categories = defaultCategories

    // MARK: Intro View

    var introView: some View {
        VStack(spacing: 20) {
            Image("BaremacLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
            Text("Baremac")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.accentColor)
            Text("Version 0.2")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Developed by Mercha")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("A minimal macOS tweak utility built with SwiftUI.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Button("Get Started") {
                withAnimation(.easeInOut) {
                    showIntro = false
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color(nsColor: .windowBackgroundColor))
    }

    // MARK: Main View

    var mainView: some View {
        NavigationSplitView {
            VStack(spacing: 12) {
                TextField("Search tweaks…", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                List(selection: $selectedCategoryIndex) {
                    ForEach(categories.indices, id: \.self) { idx in
                        Text(categories[idx].name)
                            .tag(idx)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                    }
                }
                .listStyle(SidebarListStyle())
            }
            .frame(minWidth: 200)
        } detail: {
            ScrollView {
                Section(
                    header: Text(categories[selectedCategoryIndex].name)
                        .font(.system(size: 24, weight: .bold, design: .rounded)),
                    footer: Text("Applied tweaks take effect immediately.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                ) {
                    // filter and display rows
                    ForEach(categories[selectedCategoryIndex].tweaks.indices.filter { i in
                        searchText.isEmpty ||
                        categories[selectedCategoryIndex].tweaks[i].name
                            .lowercased().contains(searchText.lowercased()) ||
                        categories[selectedCategoryIndex].tweaks[i].description
                            .lowercased().contains(searchText.lowercased())
                    }, id: \.self) { idx in
                        TweakRow(tweak: $categories[selectedCategoryIndex].tweaks[idx])
                    }
                }
                Spacer()
            }
            .padding()
            .transition(.opacity)
        }
        .accentColor(.accentColor)
        .frame(minWidth: 700, minHeight: 500)
        .animation(.easeInOut(duration: 0.3), value: selectedCategoryIndex)
    }

    // MARK: Body

    var body: some View {
        ZStack {
            if showIntro {
                introView
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            } else {
                mainView
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showIntro)
    }
}
