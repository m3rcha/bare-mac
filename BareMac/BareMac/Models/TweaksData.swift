import Foundation

struct TweaksData {
    static let sample: [Tweak] = [
        // Finder
        .init(
            name: "Show File Extensions",
            category: .finder,
            detect: {
                DefaultsHelper.getBool(domain: "NSGlobalDomain", key: "AppleShowAllExtensions")
            },
            setState: { value in
                let ok = DefaultsHelper.setBool(value, domain: "NSGlobalDomain", key: "AppleShowAllExtensions")
                if ok { _ = await TweakExecutor.run("killall Finder") }
                return ok
            }
        ),
        .init(
            name: "Show Hidden Files",
            category: .finder,
            detect: {
                DefaultsHelper.getBool(domain: "com.apple.finder", key: "AppleShowAllFiles")
            },
            setState: { value in
                let ok = DefaultsHelper.setBool(value, domain: "com.apple.finder", key: "AppleShowAllFiles")
                if ok { _ = await TweakExecutor.run("killall Finder") }
                return ok
            }
        ),
        .init(
            name: "Show Path Bar",
            category: .finder,
            detect: {
                DefaultsHelper.getBool(domain: "com.apple.finder", key: "ShowPathbar")
            },
            setState: { value in
                let ok = DefaultsHelper.setBool(value, domain: "com.apple.finder", key: "ShowPathbar")
                if ok { _ = await TweakExecutor.run("killall Finder") }
                return ok
            }
        ),
        .init(
            name: "Show Status Bar",
            category: .finder,
            detect: {
                DefaultsHelper.getBool(domain: "com.apple.finder", key: "ShowStatusBar")
            },
            setState: { value in
                let ok = DefaultsHelper.setBool(value, domain: "com.apple.finder", key: "ShowStatusBar")
                if ok { _ = await TweakExecutor.run("killall Finder") }
                return ok
            }
        ),
        .init(
            name: "Show Full Path in Title",
            category: .finder,
            detect: {
                DefaultsHelper.getBool(domain: "com.apple.finder", key: "_FXShowPosixPathInTitle")
            },
            setState: { value in
                let ok = DefaultsHelper.setBool(value, domain: "com.apple.finder", key: "_FXShowPosixPathInTitle")
                if ok { _ = await TweakExecutor.run("killall Finder") }
                return ok
            }
        ),
        .init(
            name: "Warn Before Emptying Trash",
            category: .finder,
            detect: {
                DefaultsHelper.getBool(domain: "com.apple.finder", key: "WarnOnEmptyTrash")
            },
            setState: { value in
                let ok = DefaultsHelper.setBool(value, domain: "com.apple.finder", key: "WarnOnEmptyTrash")
                if ok { _ = await TweakExecutor.run("killall Finder") }
                return ok
            }
        ),
        .init(
            name: "Expand Save Panel by Default",
            category: .finder,
            detect: {
                DefaultsHelper.getBool(domain: "NSGlobalDomain", key: "NSNavPanelExpandedStateForSaveMode")
            },
            setState: { value in
                DefaultsHelper.setBool(value, domain: "NSGlobalDomain", key: "NSNavPanelExpandedStateForSaveMode")
            }
        ),
        .init(
            name: "Expand Print Panel by Default",
            category: .finder,
            detect: {
                DefaultsHelper.getBool(domain: "NSGlobalDomain", key: "PMPrintingExpandedStateForPrint")
            },
            setState: { value in
                DefaultsHelper.setBool(value, domain: "NSGlobalDomain", key: "PMPrintingExpandedStateForPrint")
            }
        ),
        // Dock
        .init(
            name: "Auto-hide Dock",
            category: .dock,
            detect: {
                DefaultsHelper.getBool(domain: "com.apple.dock", key: "autohide")
            },
            setState: { value in
                let ok = DefaultsHelper.setBool(value, domain: "com.apple.dock", key: "autohide")
                if ok { _ = await TweakExecutor.run("killall Dock") }
                return ok
            }
        ),
        .init(
            name: "Enable Dock Magnification",
            category: .dock,
            detect: {
                DefaultsHelper.getBool(domain: "com.apple.dock", key: "magnification")
            },
            setState: { value in
                let ok = DefaultsHelper.setBool(value, domain: "com.apple.dock", key: "magnification")
                if ok { _ = await TweakExecutor.run("killall Dock") }
                return ok
            }
        ),
        .init(
            name: "Minimize into App Icon",
            category: .dock,
            detect: {
                DefaultsHelper.getBool(domain: "com.apple.dock", key: "minimize-to-application")
            },
            setState: { value in
                let ok = DefaultsHelper.setBool(value, domain: "com.apple.dock", key: "minimize-to-application")
                if ok { _ = await TweakExecutor.run("killall Dock") }
                return ok
            }
        ),
        .init(
            name: "Show Indicator Lights",
            category: .dock,
            detect: {
                DefaultsHelper.getBool(domain: "com.apple.dock", key: "show-process-indicators")
            },
            setState: { value in
                let ok = DefaultsHelper.setBool(value, domain: "com.apple.dock", key: "show-process-indicators")
                if ok { _ = await TweakExecutor.run("killall Dock") }
                return ok
            }
        ),
        .init(
            name: "Show Recent Applications",
            category: .dock,
            detect: {
                DefaultsHelper.getBool(domain: "com.apple.dock", key: "show-recents")
            },
            setState: { value in
                let ok = DefaultsHelper.setBool(value, domain: "com.apple.dock", key: "show-recents")
                if ok { _ = await TweakExecutor.run("killall Dock") }
                return ok
            }
        ),
        .init(
            name: "Automatically Rearrange Spaces",
            category: .dock,
            detect: {
                DefaultsHelper.getBool(domain: "com.apple.dock", key: "mru-spaces")
            },
            setState: { value in
                let ok = DefaultsHelper.setBool(value, domain: "com.apple.dock", key: "mru-spaces")
                if ok { _ = await TweakExecutor.run("killall Dock") }
                return ok
            }
        ),
        // Screenshots
        .init(
            name: "Show Screenshot Thumbnail",
            category: .screenshots,
            detect: {
                DefaultsHelper.getBool(domain: "com.apple.screencapture", key: "show-thumbnail")
            },
            setState: { value in
                let ok = DefaultsHelper.setBool(value, domain: "com.apple.screencapture", key: "show-thumbnail")
                if ok { _ = await TweakExecutor.run("killall SystemUIServer") }
                return ok
            }
        ),
        .init(
            name: "Play Screenshot Sound",
            category: .screenshots,
            detect: {
                !DefaultsHelper.getBool(domain: "com.apple.screencapture", key: "disable-audio")
            },
            setState: { value in
                let ok = DefaultsHelper.setBool(!value, domain: "com.apple.screencapture", key: "disable-audio")
                if ok { _ = await TweakExecutor.run("killall SystemUIServer") }
                return ok
            }
        ),
        // Safari
        .init(
            name: "Show Develop Menu",
            category: .safari,
            detect: {
                DefaultsHelper.getBool(domain: "com.apple.Safari", key: "IncludeDevelopMenu")
            },
            setState: { value in
                let ok = DefaultsHelper.setBool(value, domain: "com.apple.Safari", key: "IncludeDevelopMenu")
                if ok { _ = await TweakExecutor.run("killall Safari") }
                return ok
            }
        ),
        .init(
            name: "Show Full URL in Address Bar",
            category: .safari,
            detect: {
                DefaultsHelper.getBool(domain: "com.apple.Safari", key: "ShowFullURLInSmartSearchField")
            },
            setState: { value in
                let ok = DefaultsHelper.setBool(value, domain: "com.apple.Safari", key: "ShowFullURLInSmartSearchField")
                if ok { _ = await TweakExecutor.run("killall Safari") }
                return ok
            }
        )
    ]
}
