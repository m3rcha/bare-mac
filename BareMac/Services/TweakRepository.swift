import Foundation

struct TweakRepository {
    
    // MARK: - Finders
    
    private static let finderTweaks: [Tweak] = [
        Tweak(
            name: "Show Hidden Files",
            description: "Reveals hidden files in Finder",
            apply: {
                await TweakRunner.shared.setDefaults(domain: "com.apple.finder", key: "AppleShowAllFiles", value: true)
                await TweakRunner.shared.terminateApp(bundleId: "com.apple.finder")
            },
            revert: {
                await TweakRunner.shared.setDefaults(domain: "com.apple.finder", key: "AppleShowAllFiles", value: false)
                await TweakRunner.shared.terminateApp(bundleId: "com.apple.finder")
            },
            check: {
                let val = await TweakRunner.shared.getDefaults(domain: "com.apple.finder", key: "AppleShowAllFiles") as? Bool
                return val == true
            }
        ),
        Tweak(
            name: "Prevent .DS_Store on Network",
            description: "Stops .DS_Store creation on network volumes",
            apply: {
                await TweakRunner.shared.setDefaults(domain: "com.apple.desktopservices", key: "DSDontWriteNetworkStores", value: true)
            },
            revert: {
                await TweakRunner.shared.setDefaults(domain: "com.apple.desktopservices", key: "DSDontWriteNetworkStores", value: false)
            },
            check: {
                let val = await TweakRunner.shared.getDefaults(domain: "com.apple.desktopservices", key: "DSDontWriteNetworkStores") as? Bool
                return val == true
            }
        ),
        Tweak(
            name: "Show Full Path in Title Bar",
            description: "Displays full POSIX path in Finder title bar",
            apply: {
                await TweakRunner.shared.setDefaults(domain: "com.apple.finder", key: "_FXShowPosixPathInTitle", value: true)
                await TweakRunner.shared.terminateApp(bundleId: "com.apple.finder")
            },
            revert: {
                await TweakRunner.shared.setDefaults(domain: "com.apple.finder", key: "_FXShowPosixPathInTitle", value: false)
                await TweakRunner.shared.terminateApp(bundleId: "com.apple.finder")
            },
            check: {
                let val = await TweakRunner.shared.getDefaults(domain: "com.apple.finder", key: "_FXShowPosixPathInTitle") as? Bool
                return val == true
            }
        ),
        Tweak(
            name: "Enable QuickLook Text Selection",
            description: "Allows selecting text in QuickLook previews",
            apply: {
                await TweakRunner.shared.setDefaults(domain: "com.apple.finder", key: "QLEnableTextSelection", value: true)
                await TweakRunner.shared.terminateApp(bundleId: "com.apple.finder")
            },
            revert: {
                await TweakRunner.shared.setDefaults(domain: "com.apple.finder", key: "QLEnableTextSelection", value: false)
                await TweakRunner.shared.terminateApp(bundleId: "com.apple.finder")
            },
            check: {
                let val = await TweakRunner.shared.getDefaults(domain: "com.apple.finder", key: "QLEnableTextSelection") as? Bool
                return val == true
            }
        ),
        Tweak(
            name: "Show Path Bar",
            description: "Displays path bar at bottom of Finder windows",
            apply: {
                await TweakRunner.shared.setDefaults(domain: "com.apple.finder", key: "ShowPathbar", value: true)
                await TweakRunner.shared.terminateApp(bundleId: "com.apple.finder")
            },
            revert: {
                await TweakRunner.shared.setDefaults(domain: "com.apple.finder", key: "ShowPathbar", value: false)
                await TweakRunner.shared.terminateApp(bundleId: "com.apple.finder")
            },
            check: {
                let val = await TweakRunner.shared.getDefaults(domain: "com.apple.finder", key: "ShowPathbar") as? Bool
                return val == true
            }
        )
    ]
    
    // MARK: - Dock
    
    private static let dockTweaks: [Tweak] = [
        Tweak(
            name: "Auto-hide Dock (no delay)",
            description: "Hides the Dock instantly when not in use",
            apply: {
                let domain = "com.apple.dock"
                await TweakRunner.shared.setDefaults(domain: domain, key: "autohide", value: true)
                await TweakRunner.shared.setDefaults(domain: domain, key: "autohide-delay", value: 0)
                await TweakRunner.shared.setDefaults(domain: domain, key: "autohide-time-modifier", value: 0)
                await TweakRunner.shared.terminateApp(bundleId: domain)
            },
            revert: {
                let domain = "com.apple.dock"
                await TweakRunner.shared.setDefaults(domain: domain, key: "autohide", value: false)
                await TweakRunner.shared.setDefaults(domain: domain, key: "autohide-delay", value: 0.5)
                await TweakRunner.shared.setDefaults(domain: domain, key: "autohide-time-modifier", value: 0.5)
                await TweakRunner.shared.terminateApp(bundleId: domain)
            },
            check: {
                let domain = "com.apple.dock"
                let autohide = await TweakRunner.shared.getDefaults(domain: domain, key: "autohide") as? Bool
                let delay = await TweakRunner.shared.getDefaults(domain: domain, key: "autohide-delay") as? Double
                return autohide == true && delay == 0
            }
        ),
        Tweak(
            name: "Disable Mission Control Animation",
            description: "Removes Mission Control transition animation",
            apply: {
                await TweakRunner.shared.setDefaults(domain: "com.apple.dock", key: "expose-animation-duration", value: 0)
                await TweakRunner.shared.terminateApp(bundleId: "com.apple.dock")
            },
            revert: {
                await TweakRunner.shared.removeDefaults(domain: "com.apple.dock", key: "expose-animation-duration")
                await TweakRunner.shared.terminateApp(bundleId: "com.apple.dock")
            },
            check: {
                let val = await TweakRunner.shared.getDefaults(domain: "com.apple.dock", key: "expose-animation-duration") as? Double
                return val == 0
            }
        ),
        Tweak(
            name: "Enable 2D Dock",
            description: "Sets Dock to 2D style (no glass)",
            apply: {
                await TweakRunner.shared.setDefaults(domain: "com.apple.dock", key: "no-glass", value: true)
                await TweakRunner.shared.terminateApp(bundleId: "com.apple.dock")
            },
            revert: {
                await TweakRunner.shared.removeDefaults(domain: "com.apple.dock", key: "no-glass")
                await TweakRunner.shared.terminateApp(bundleId: "com.apple.dock")
            },
            check: {
                let val = await TweakRunner.shared.getDefaults(domain: "com.apple.dock", key: "no-glass") as? Bool
                return val == true
            }
        ),
        Tweak(
            name: "Single App Mode",
            description: "Switches to single-app mode in Dock",
            apply: {
                await TweakRunner.shared.setDefaults(domain: "com.apple.dock", key: "single-app", value: true)
                await TweakRunner.shared.terminateApp(bundleId: "com.apple.dock")
            },
            revert: {
                await TweakRunner.shared.setDefaults(domain: "com.apple.dock", key: "single-app", value: false)
                await TweakRunner.shared.terminateApp(bundleId: "com.apple.dock")
            },
            check: {
                let val = await TweakRunner.shared.getDefaults(domain: "com.apple.dock", key: "single-app") as? Bool
                return val == true
            }
        ),
        Tweak(
            name: "Minimize to Application Icon",
            description: "Minimizes windows into their app's Dock icon",
            apply: {
                await TweakRunner.shared.setDefaults(domain: "com.apple.dock", key: "minimize-to-application", value: true)
                await TweakRunner.shared.terminateApp(bundleId: "com.apple.dock")
            },
            revert: {
                await TweakRunner.shared.setDefaults(domain: "com.apple.dock", key: "minimize-to-application", value: false)
                await TweakRunner.shared.terminateApp(bundleId: "com.apple.dock")
            },
            check: {
                let val = await TweakRunner.shared.getDefaults(domain: "com.apple.dock", key: "minimize-to-application") as? Bool
                return val == true
            }
        )
    ]
    
    // MARK: - System
    
    private static let systemTweaks: [Tweak] = [
        Tweak(
            name: "Disable Animations",
            description: "Turns off window animations system-wide",
            apply: {
                await TweakRunner.shared.setDefaults(domain: "NSGlobalDomain", key: "NSAutomaticWindowAnimationsEnabled", value: false)
            },
            revert: {
                await TweakRunner.shared.setDefaults(domain: "NSGlobalDomain", key: "NSAutomaticWindowAnimationsEnabled", value: true)
            },
            check: {
                let val = await TweakRunner.shared.getDefaults(domain: "NSGlobalDomain", key: "NSAutomaticWindowAnimationsEnabled") as? Bool
                return val == false
            }
        ),
        Tweak(
            name: "Disable Gatekeeper Warnings",
            description: "Suppresses 'App downloaded from the internet' dialogs",
            apply: {
                await TweakRunner.shared.setDefaults(domain: "com.apple.LaunchServices", key: "LSQuarantine", value: false)
            },
            revert: {
                await TweakRunner.shared.setDefaults(domain: "com.apple.LaunchServices", key: "LSQuarantine", value: true)
            },
            check: {
                let val = await TweakRunner.shared.getDefaults(domain: "com.apple.LaunchServices", key: "LSQuarantine") as? Bool
                return val == false
            }
        ),
        Tweak(
            name: "Disable Auto-Correct",
            description: "Disables automatic spelling correction system-wide",
            apply: {
                await TweakRunner.shared.setDefaults(domain: "NSGlobalDomain", key: "NSAutomaticSpellingCorrectionEnabled", value: false)
            },
            revert: {
                await TweakRunner.shared.setDefaults(domain: "NSGlobalDomain", key: "NSAutomaticSpellingCorrectionEnabled", value: true)
            },
            check: {
                let val = await TweakRunner.shared.getDefaults(domain: "NSGlobalDomain", key: "NSAutomaticSpellingCorrectionEnabled") as? Bool
                return val == false
            }
        ),
        Tweak(
            name: "Show All File Extensions",
            description: "Displays file extensions for all files",
            apply: {
                await TweakRunner.shared.setDefaults(domain: "NSGlobalDomain", key: "AppleShowAllExtensions", value: true)
                await TweakRunner.shared.terminateApp(bundleId: "com.apple.finder")
            },
            revert: {
                await TweakRunner.shared.setDefaults(domain: "NSGlobalDomain", key: "AppleShowAllExtensions", value: false)
                await TweakRunner.shared.terminateApp(bundleId: "com.apple.finder")
            },
            check: {
                let val = await TweakRunner.shared.getDefaults(domain: "NSGlobalDomain", key: "AppleShowAllExtensions") as? Bool
                return val == true
            }
        ),
        Tweak(
            name: "Disable Automatic Capitalization",
            description: "Turns off auto-capitalization system-wide",
            apply: {
                await TweakRunner.shared.setDefaults(domain: "NSGlobalDomain", key: "NSAutomaticCapitalizationEnabled", value: false)
            },
            revert: {
                await TweakRunner.shared.setDefaults(domain: "NSGlobalDomain", key: "NSAutomaticCapitalizationEnabled", value: true)
            },
            check: {
                let val = await TweakRunner.shared.getDefaults(domain: "NSGlobalDomain", key: "NSAutomaticCapitalizationEnabled") as? Bool
                return val == false
            }
        )
    ]
    
    // MARK: - Screenshot
    
    private static let screenshotTweaks: [Tweak] = [
        Tweak(
            name: "Set Screenshot Format to JPG",
            description: "Changes screenshot format from PNG to JPG",
            apply: {
                await TweakRunner.shared.setDefaults(domain: "com.apple.screencapture", key: "type", value: "jpg")
                await TweakRunner.shared.terminateApp(bundleId: "com.apple.SystemUIServer")
            },
            revert: {
                await TweakRunner.shared.setDefaults(domain: "com.apple.screencapture", key: "type", value: "png")
                await TweakRunner.shared.terminateApp(bundleId: "com.apple.SystemUIServer")
            },
            check: {
                let val = await TweakRunner.shared.getDefaults(domain: "com.apple.screencapture", key: "type") as? String
                return val == "jpg"
            }
        ),
        Tweak(
            name: "Change Screenshot Location",
            description: "Sets default location for screenshots to ~/Screenshots",
            apply: {
                let path = NSString(string: "~/Screenshots").expandingTildeInPath
                await TweakRunner.shared.setDefaults(domain: "com.apple.screencapture", key: "location", value: path)
                await TweakRunner.shared.terminateApp(bundleId: "com.apple.SystemUIServer")
            },
            revert: {
                await TweakRunner.shared.removeDefaults(domain: "com.apple.screencapture", key: "location")
                await TweakRunner.shared.terminateApp(bundleId: "com.apple.SystemUIServer")
            },
            check: {
                let path = NSString(string: "~/Screenshots").expandingTildeInPath
                let val = await TweakRunner.shared.getDefaults(domain: "com.apple.screencapture", key: "location") as? String
                return val == path
            }
        ),
        Tweak(
            name: "Disable Screenshot Shadow",
            description: "Removes drop shadow from screenshots",
            apply: {
                await TweakRunner.shared.setDefaults(domain: "com.apple.screencapture", key: "disable-shadow", value: true)
                await TweakRunner.shared.terminateApp(bundleId: "com.apple.SystemUIServer")
            },
            revert: {
                await TweakRunner.shared.setDefaults(domain: "com.apple.screencapture", key: "disable-shadow", value: false)
                await TweakRunner.shared.terminateApp(bundleId: "com.apple.SystemUIServer")
            },
            check: {
                let val = await TweakRunner.shared.getDefaults(domain: "com.apple.screencapture", key: "disable-shadow") as? Bool
                return val == true
            }
        )
    ]
    
    // MARK: - Public Access
    
    static let categories: [TweakCategory] = [
        TweakCategory(name: "Finder", icon: "laptopcomputer", tweaks: finderTweaks),
        TweakCategory(name: "Dock", icon: "menubar.dock.rectangle", tweaks: dockTweaks),
        TweakCategory(name: "System", icon: "gearshape", tweaks: systemTweaks),
        TweakCategory(name: "Screenshot", icon: "camera.viewfinder", tweaks: screenshotTweaks)
    ]
}
