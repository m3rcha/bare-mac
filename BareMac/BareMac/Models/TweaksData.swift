struct TweaksData {
    static let sample: [Tweak] = [
        .init(name: "Show File Extensions",
              command: "defaults write NSGlobalDomain AppleShowAllExtensions -bool TRUE && killall Finder",
              revertCommand: "defaults write NSGlobalDomain AppleShowAllExtensions -bool FALSE && killall Finder",
              category: .system,
              detectCommand: "defaults read NSGlobalDomain AppleShowAllExtensions"),
        .init(name: "Show Hidden Files",
              command: "defaults write com.apple.finder AppleShowAllFiles -bool TRUE && killall Finder",
              revertCommand: "defaults write com.apple.finder AppleShowAllFiles -bool FALSE && killall Finder",
              category: .system,
              detectCommand: "defaults read com.apple.finder AppleShowAllFiles")
    ]
}
