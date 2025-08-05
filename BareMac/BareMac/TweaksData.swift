import Foundation

/// Represents a single system tweak.
public struct Tweak: Identifiable {
    public let id = UUID()
    public let name: String
    public let description: String
    public let apply: () async -> Void
    public let revert: () async -> Void
    public var isSelected: Bool = false
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
        apply: {
            await TweakHelper.shared.setDefaults(domain: "com.apple.finder", key: "AppleShowAllFiles", value: true)
            await TweakHelper.shared.terminateApp(bundleId: "com.apple.finder")
        },
        revert: {
            await TweakHelper.shared.setDefaults(domain: "com.apple.finder", key: "AppleShowAllFiles", value: false)
            await TweakHelper.shared.terminateApp(bundleId: "com.apple.finder")
        }
    ),
    Tweak(
        name: "Prevent .DS_Store on Network",
        description: "Stops .DS_Store creation on network volumes",
        apply: {
            await TweakHelper.shared.setDefaults(domain: "com.apple.desktopservices", key: "DSDontWriteNetworkStores", value: true)
        },
        revert: {
            await TweakHelper.shared.setDefaults(domain: "com.apple.desktopservices", key: "DSDontWriteNetworkStores", value: false)
        }
    ),
    Tweak(
        name: "Show Full Path in Title Bar",
        description: "Displays full POSIX path in Finder title bar",
        apply: {
            await TweakHelper.shared.setDefaults(domain: "com.apple.finder", key: "_FXShowPosixPathInTitle", value: true)
            await TweakHelper.shared.terminateApp(bundleId: "com.apple.finder")
        },
        revert: {
            await TweakHelper.shared.setDefaults(domain: "com.apple.finder", key: "_FXShowPosixPathInTitle", value: false)
            await TweakHelper.shared.terminateApp(bundleId: "com.apple.finder")
        }
    ),
    Tweak(
        name: "Enable QuickLook Text Selection",
        description: "Allows selecting text in QuickLook previews",
        apply: {
            await TweakHelper.shared.setDefaults(domain: "com.apple.finder", key: "QLEnableTextSelection", value: true)
            await TweakHelper.shared.terminateApp(bundleId: "com.apple.finder")
        },
        revert: {
            await TweakHelper.shared.setDefaults(domain: "com.apple.finder", key: "QLEnableTextSelection", value: false)
            await TweakHelper.shared.terminateApp(bundleId: "com.apple.finder")
        }
    ),
    Tweak(
        name: "Show Path Bar",
        description: "Displays path bar at bottom of Finder windows",
        apply: {
            await TweakHelper.shared.setDefaults(domain: "com.apple.finder", key: "ShowPathbar", value: true)
            await TweakHelper.shared.terminateApp(bundleId: "com.apple.finder")
        },
        revert: {
            await TweakHelper.shared.setDefaults(domain: "com.apple.finder", key: "ShowPathbar", value: false)
            await TweakHelper.shared.terminateApp(bundleId: "com.apple.finder")
        }
    )
]

// MARK: - Dock Category Tweaks
private let dockTweaks: [Tweak] = [
    Tweak(
        name: "Auto-hide Dock (no delay)",
        description: "Hides the Dock instantly when not in use",
        apply: {
            let domain = "com.apple.dock"
            await TweakHelper.shared.setDefaults(domain: domain, key: "autohide", value: true)
            await TweakHelper.shared.setDefaults(domain: domain, key: "autohide-delay", value: 0)
            await TweakHelper.shared.setDefaults(domain: domain, key: "autohide-time-modifier", value: 0)
            await TweakHelper.shared.terminateApp(bundleId: domain)
        },
        revert: {
            let domain = "com.apple.dock"
            await TweakHelper.shared.setDefaults(domain: domain, key: "autohide", value: false)
            await TweakHelper.shared.setDefaults(domain: domain, key: "autohide-delay", value: 0.5)
            await TweakHelper.shared.setDefaults(domain: domain, key: "autohide-time-modifier", value: 0.5)
            await TweakHelper.shared.terminateApp(bundleId: domain)
        }
    ),
    Tweak(
        name: "Disable Mission Control Animation",
        description: "Removes Mission Control transition animation",
        apply: {
            await TweakHelper.shared.setDefaults(domain: "com.apple.dock", key: "expose-animation-duration", value: 0)
            await TweakHelper.shared.terminateApp(bundleId: "com.apple.dock")
        },
        revert: {
            await TweakHelper.shared.removeDefaults(domain: "com.apple.dock", key: "expose-animation-duration")
            await TweakHelper.shared.terminateApp(bundleId: "com.apple.dock")
        }
    ),
    Tweak(
        name: "Enable 2D Dock",
        description: "Sets Dock to 2D style (no glass)",
        apply: {
            await TweakHelper.shared.setDefaults(domain: "com.apple.dock", key: "no-glass", value: true)
            await TweakHelper.shared.terminateApp(bundleId: "com.apple.dock")
        },
        revert: {
            await TweakHelper.shared.removeDefaults(domain: "com.apple.dock", key: "no-glass")
            await TweakHelper.shared.terminateApp(bundleId: "com.apple.dock")
        }
    ),
    Tweak(
        name: "Single App Mode",
        description: "Switches to single-app mode in Dock",
        apply: {
            await TweakHelper.shared.setDefaults(domain: "com.apple.dock", key: "single-app", value: true)
            await TweakHelper.shared.terminateApp(bundleId: "com.apple.dock")
        },
        revert: {
            await TweakHelper.shared.setDefaults(domain: "com.apple.dock", key: "single-app", value: false)
            await TweakHelper.shared.terminateApp(bundleId: "com.apple.dock")
        }
    ),
    Tweak(
        name: "Minimize to Application Icon",
        description: "Minimizes windows into their app's Dock icon",
        apply: {
            await TweakHelper.shared.setDefaults(domain: "com.apple.dock", key: "minimize-to-application", value: true)
            await TweakHelper.shared.terminateApp(bundleId: "com.apple.dock")
        },
        revert: {
            await TweakHelper.shared.setDefaults(domain: "com.apple.dock", key: "minimize-to-application", value: false)
            await TweakHelper.shared.terminateApp(bundleId: "com.apple.dock")
        }
    )
]

// MARK: - System Category Tweaks
private let systemTweaks: [Tweak] = [
    Tweak(
        name: "Disable Animations",
        description: "Turns off window animations system-wide",
        apply: {
            await TweakHelper.shared.setDefaults(domain: "NSGlobalDomain", key: "NSAutomaticWindowAnimationsEnabled", value: false)
        },
        revert: {
            await TweakHelper.shared.setDefaults(domain: "NSGlobalDomain", key: "NSAutomaticWindowAnimationsEnabled", value: true)
        }
    ),
    Tweak(
        name: "Disable Gatekeeper Warnings",
        description: "Suppresses 'App downloaded from the internet' dialogs",
        apply: {
            await TweakHelper.shared.setDefaults(domain: "com.apple.LaunchServices", key: "LSQuarantine", value: false)
        },
        revert: {
            await TweakHelper.shared.setDefaults(domain: "com.apple.LaunchServices", key: "LSQuarantine", value: true)
        }
    ),
    Tweak(
        name: "Disable Auto-Correct",
        description: "Disables automatic spelling correction system-wide",
        apply: {
            await TweakHelper.shared.setDefaults(domain: "NSGlobalDomain", key: "NSAutomaticSpellingCorrectionEnabled", value: false)
        },
        revert: {
            await TweakHelper.shared.setDefaults(domain: "NSGlobalDomain", key: "NSAutomaticSpellingCorrectionEnabled", value: true)
        }
    ),
    Tweak(
        name: "Show All File Extensions",
        description: "Displays file extensions for all files",
        apply: {
            await TweakHelper.shared.setDefaults(domain: "NSGlobalDomain", key: "AppleShowAllExtensions", value: true)
            await TweakHelper.shared.terminateApp(bundleId: "com.apple.finder")
        },
        revert: {
            await TweakHelper.shared.setDefaults(domain: "NSGlobalDomain", key: "AppleShowAllExtensions", value: false)
            await TweakHelper.shared.terminateApp(bundleId: "com.apple.finder")
        }
    ),
    Tweak(
        name: "Disable Automatic Capitalization",
        description: "Turns off auto-capitalization system-wide",
        apply: {
            await TweakHelper.shared.setDefaults(domain: "NSGlobalDomain", key: "NSAutomaticCapitalizationEnabled", value: false)
        },
        revert: {
            await TweakHelper.shared.setDefaults(domain: "NSGlobalDomain", key: "NSAutomaticCapitalizationEnabled", value: true)
        }
    )
]

// MARK: - Screenshot Category Tweaks
private let screenshotTweaks: [Tweak] = [
    Tweak(
        name: "Set Screenshot Format to JPG",
        description: "Changes screenshot format from PNG to JPG",
        apply: {
            await TweakHelper.shared.setDefaults(domain: "com.apple.screencapture", key: "type", value: "jpg")
            await TweakHelper.shared.terminateApp(bundleId: "com.apple.SystemUIServer")
        },
        revert: {
            await TweakHelper.shared.setDefaults(domain: "com.apple.screencapture", key: "type", value: "png")
            await TweakHelper.shared.terminateApp(bundleId: "com.apple.SystemUIServer")
        }
    ),
    Tweak(
        name: "Change Screenshot Location",
        description: "Sets default location for screenshots to ~/Screenshots",
        apply: {
            let path = NSString(string: "~/Screenshots").expandingTildeInPath
            await TweakHelper.shared.setDefaults(domain: "com.apple.screencapture", key: "location", value: path)
            await TweakHelper.shared.terminateApp(bundleId: "com.apple.SystemUIServer")
        },
        revert: {
            await TweakHelper.shared.removeDefaults(domain: "com.apple.screencapture", key: "location")
            await TweakHelper.shared.terminateApp(bundleId: "com.apple.SystemUIServer")
        }
    ),
    Tweak(
        name: "Disable Screenshot Shadow",
        description: "Removes drop shadow from screenshots",
        apply: {
            await TweakHelper.shared.setDefaults(domain: "com.apple.screencapture", key: "disable-shadow", value: true)
            await TweakHelper.shared.terminateApp(bundleId: "com.apple.SystemUIServer")
        },
        revert: {
            await TweakHelper.shared.setDefaults(domain: "com.apple.screencapture", key: "disable-shadow", value: false)
            await TweakHelper.shared.terminateApp(bundleId: "com.apple.SystemUIServer")
        }
    )
]

/// The complete list of tweak categories for BareMac, each optionally with an icon.
public let defaultCategories: [TweakCategory] = [
    TweakCategory(name: "Finder", icon: "💻", tweaks: finderTweaks),
    TweakCategory(name: "Dock", icon: "🧩", tweaks: dockTweaks),
    TweakCategory(name: "System", icon: "⚙️", tweaks: systemTweaks),
    TweakCategory(name: "Screenshot", icon: "📸", tweaks: screenshotTweaks)
]
