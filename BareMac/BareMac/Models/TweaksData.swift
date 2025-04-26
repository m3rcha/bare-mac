struct TweaksData {
    static let sample: [Tweak] = [
        .init(name: "Show File Extensions",
              command: "defaults write NSGlobalDomain AppleShowAllExtensions -bool TRUE && killall Finder",
              revertCommand: "defaults write NSGlobalDomain AppleShowAllExtensions -bool FALSE && killall Finder",
              category: .system)
    ]
}
