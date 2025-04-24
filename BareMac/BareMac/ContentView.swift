import SwiftUI

struct Tweak: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let command: String
    var isSelected: Bool = false
}

struct ContentView: View {
    @State private var tweaks: [Tweak] = [
        Tweak(
            name: "Show Hidden Files",
            description: "Reveals hidden files in Finder (e.g., .DS_Store, .git)",
            command: "defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
        ),
        Tweak(
            name: "Auto-hide Dock",
            description: "Automatically hides the Dock with no delay",
            command: "defaults write com.apple.dock autohide -bool true && defaults write com.apple.dock autohide-delay -float 0 && killall Dock"
        ),
        Tweak(
            name: "Disable Animations",
            description: "Speeds up macOS by disabling window animations",
            command: "defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false"
        ),
        Tweak(
            name: "Set Screenshot Format to JPG",
            description: "Changes screenshot format from PNG to JPG",
            command: "defaults write com.apple.screencapture type -string jpg && killall SystemUIServer"
        )
    ]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Baremac Tweaks")
                .font(.largeTitle)
                .padding(.bottom, 10)

            ForEach($tweaks) { $tweak in
                Toggle(isOn: $tweak.isSelected) {
                    VStack(alignment: .leading) {
                        Text(tweak.name).bold()
                        Text(tweak.description)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 4)
            }

            Spacer()

            Button("Apply Tweaks") {
                applySelectedTweaks()
            }
            .padding()
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(width: 400, height: 400)
    }

    func applySelectedTweaks() {
        for tweak in tweaks where tweak.isSelected {
            let task = Process()
            task.launchPath = "/bin/zsh"
            task.arguments = ["-c", tweak.command]
            try? task.run()
        }
    }
}
