import Foundation

/// Represents a single system tweak.
public struct Tweak: Identifiable {
    public let id = UUID()
    public let name: String
    public let description: String
    public let command: String
    public let revertCommand: String
    public var isSelected: Bool = false
    public var requiresRestart: Bool = false
    public var requiresKillall: Bool {
        return command.contains("killall")
    }
}

/// A collection of tweaks grouped under a category name.
public struct TweakCategory: Identifiable {
    public let id = UUID()
    public let name: String
    public let icon: String?
    public var tweaks: [Tweak]
}

// MARK: - Finder Category Tweaks
private let finderTweaks: [Tweak] = [
    Tweak(
        name: "Show Hidden Files",
        description: "Reveals hidden files in Finder",
        command: "defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder",
        revertCommand: "defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
    ),
    Tweak(
        name: "Prevent .DS_Store on Network",
        description: "Stops .DS_Store creation on network volumes",
        command: "defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true",
        revertCommand: "defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool false"
    ),
    Tweak(
        name: "Show Full Path in Title Bar",
        description: "Displays full POSIX path in Finder title bar",
        command: "defaults write com.apple.finder _FXShowPosixPathInTitle -bool true && killall Finder",
        revertCommand: "defaults write com.apple.finder _FXShowPosixPathInTitle -bool false && killall Finder"
    ),
    Tweak(
        name: "Enable QuickLook Text Selection",
        description: "Allows selecting text in QuickLook previews",
        command: "defaults write com.apple.finder QLEnableTextSelection -bool true && killall Finder",
        revertCommand: "defaults write com.apple.finder QLEnableTextSelection -bool false && killall Finder"
    )
]

// MARK: - Dock Category Tweaks
private let dockTweaks: [Tweak] = [
    Tweak(
        name: "Auto-hide Dock (no delay)",
        description: "Hides the Dock instantly when not in use",
        command: "defaults write com.apple.dock autohide -bool true && defaults write com.apple.dock autohide-delay -float 0 && defaults write com.apple.dock autohide-time-modifier -float 0 && killall Dock",
        revertCommand: "defaults write com.apple.dock autohide -bool false && defaults write com.apple.dock autohide-delay -float 0.5 && defaults write com.apple.dock autohide-time-modifier -float 0.5 && killall Dock"
    ),
    Tweak(
        name: "Disable Mission Control Animation",
        description: "Removes Mission Control transition animation",
        command: "defaults write com.apple.dock expose-animation-duration -int 0 && killall Dock",
        revertCommand: "defaults delete com.apple.dock expose-animation-duration && killall Dock"
    ),
    Tweak(
        name: "Enable 2D Dock",
        description: "Sets Dock to 2D style (no glass)",
        command: "defaults write com.apple.dock no-glass -bool true && killall Dock",
        revertCommand: "defaults delete com.apple.dock no-glass && killall Dock"
    ),
    Tweak(
        name: "Single App Mode",
        description: "Switches to single-app mode in Dock",
        command: "defaults write com.apple.dock single-app -bool true && killall Dock",
        revertCommand: "defaults write com.apple.dock single-app -bool false && killall Dock"
    )
]

// MARK: - System Category Tweaks
private let systemTweaks: [Tweak] = [
    Tweak(
        name: "Disable Animations",
        description: "Turns off window animations system-wide",
        command: "defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false",
        revertCommand: "defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool true"
    ),
    Tweak(
        name: "Disable Gatekeeper Warnings",
        description: "Suppresses 'App downloaded from the internet' dialogs",
        command: "defaults write com.apple.LaunchServices LSQuarantine -bool false",
        revertCommand: "defaults write com.apple.LaunchServices LSQuarantine -bool true"
    ),
    Tweak(
        name: "Disable Auto-Correct",
        description: "Disables automatic spelling correction system-wide",
        command: "defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false",
        revertCommand: "defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool true"
    )
]

// MARK: - Screenshot Category Tweaks
private let screenshotTweaks: [Tweak] = [
    Tweak(
        name: "Set Screenshot Format to JPG",
        description: "Changes screenshot format from PNG to JPG",
        command: "defaults write com.apple.screencapture type -string jpg && killall SystemUIServer",
        revertCommand: "defaults write com.apple.screencapture type -string png && killall SystemUIServer"
    ),
    Tweak(
        name: "Change Screenshot Location",
        description: "Sets default location for screenshots to ~/Screenshots",
        command: "defaults write com.apple.screencapture location ~/Screenshots && killall SystemUIServer",
        revertCommand: "defaults delete com.apple.screencapture location && killall SystemUIServer"
    )
]

/// The complete list of tweak categories for BareMac, each optionally with an icon.
public let defaultCategories: [TweakCategory] = [
    TweakCategory(name: "Finder", icon: "💻", tweaks: finderTweaks),
    TweakCategory(name: "Dock", icon: "🧩", tweaks: dockTweaks),
    TweakCategory(name: "System", icon: "⚙️", tweaks: systemTweaks),
    TweakCategory(name: "Screenshot", icon: "📸", tweaks: screenshotTweaks)
]
