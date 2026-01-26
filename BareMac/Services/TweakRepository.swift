import Foundation

protocol TweakSourceProtocol {
    func loadTweaks() async throws -> [Tweak]
}

enum TweakSourceError: Error {
    case fileNotFound
    case decodingFailed(Error)
    case networkError(Error)
}

/// Loads tweaks from a local JSON file bundled with the app.
class LegacyTweakSource: TweakSourceProtocol {
    private let fileName: String
    
    init(fileName: String = "legacy_tweaks") {
        self.fileName = fileName
    }
    
    func loadTweaks() async throws -> [Tweak] {
        // Fallback to hardcoded tweaks since resource bundle loading can be flaky without proper Xcode project manipulation
        return [
            Tweak(
                    id: "finder.show-hidden-files",
                    name: "Show Hidden and System Files",
                    description: "Show hidden and system files in Finder.",
                    category: "Finder",
                    platform: "macos",
                    scope: "persistent",
                    riskLevel: "low",
                    supportedOS: ["ventura", "sonoma", "sequoia"],
                    apply: [
                        TweakOperation(
                            type: "defaults",
                            domain: "com.apple.finder",
                            key: "AppleShowAllFiles",
                            value: .bool(true),
                            command: nil
                        ),
                        TweakOperation(
                            type: "shell",
                            domain: nil,
                            key: nil,
                            value: nil,
                            command: "killall Finder"
                        )
                    ],
                    revert: [
                        TweakOperation(
                            type: "defaults",
                            domain: "com.apple.finder",
                            key: "AppleShowAllFiles",
                            value: .bool(false),
                            command: nil
                        ),
                        TweakOperation(
                            type: "shell",
                            domain: nil,
                            key: nil,
                            value: nil,
                            command: "killall Finder"
                        )
                    ]
                ),

                Tweak(
                    id: "finder.show-file-extensions",
                    name: "Show All File Extensions",
                    description: "Always show file extensions for all files in Finder.",
                    category: "Finder",
                    platform: "macos",
                    scope: "persistent",
                    riskLevel: "low",
                    supportedOS: ["ventura", "sonoma", "sequoia"],
                    apply: [
                        TweakOperation(
                            type: "defaults",
                            domain: "NSGlobalDomain",
                            key: "AppleShowAllExtensions",
                            value: .bool(true),
                            command: nil
                        ),
                        TweakOperation(
                            type: "shell",
                            domain: nil,
                            key: nil,
                            value: nil,
                            command: "killall Finder"
                        )
                    ],
                    revert: [
                        TweakOperation(
                            type: "defaults",
                            domain: "NSGlobalDomain",
                            key: "AppleShowAllExtensions",
                            value: .bool(false),
                            command: nil
                        ),
                        TweakOperation(
                            type: "shell",
                            domain: nil,
                            key: nil,
                            value: nil,
                            command: "killall Finder"
                        )
                    ]
                ),

                Tweak(
                    id: "finder.enable-quit-menu",
                    name: "Enable Quit Menu in Finder",
                    description: "Adds a Quit option to Finder’s menu bar.",
                    category: "Finder",
                    platform: "macos",
                    scope: "persistent",
                    riskLevel: "low",
                    supportedOS: ["ventura", "sonoma", "sequoia"],
                    apply: [
                        TweakOperation(
                            type: "defaults",
                            domain: "com.apple.finder",
                            key: "QuitMenuItem",
                            value: .bool(true),
                            command: nil
                        ),
                        TweakOperation(
                            type: "shell",
                            domain: nil,
                            key: nil,
                            value: nil,
                            command: "killall Finder"
                        )
                    ],
                    revert: [
                        TweakOperation(
                            type: "defaults",
                            domain: "com.apple.finder",
                            key: "QuitMenuItem",
                            value: .bool(false),
                            command: nil
                        ),
                        TweakOperation(
                            type: "shell",
                            domain: nil,
                            key: nil,
                            value: nil,
                            command: "killall Finder"
                        )
                    ]
                ),

                Tweak(
                    id: "finder.show-posix-path-in-title",
                    name: "Show Full Path in Finder Title Bar",
                    description: "Display the full POSIX path of the current folder in Finder’s title bar.",
                    category: "Finder",
                    platform: "macos",
                    scope: "persistent",
                    riskLevel: "low",
                    supportedOS: ["ventura", "sonoma", "sequoia"],
                    apply: [
                        TweakOperation(
                            type: "defaults",
                            domain: "com.apple.finder",
                            key: "_FXShowPosixPathInTitle",
                            value: .bool(true),
                            command: nil
                        ),
                        TweakOperation(
                            type: "shell",
                            domain: nil,
                            key: nil,
                            value: nil,
                            command: "killall Finder"
                        )
                    ],
                    revert: [
                        TweakOperation(
                            type: "defaults",
                            domain: "com.apple.finder",
                            key: "_FXShowPosixPathInTitle",
                            value: .bool(false),
                            command: nil
                        ),
                        TweakOperation(
                            type: "shell",
                            domain: nil,
                            key: nil,
                            value: nil,
                            command: "killall Finder"
                        )
                    ]
                ),

                Tweak(
                    id: "desktop.disable-dsstore-network",
                    name: "Disable .DS_Store on Network Volumes",
                    description: "Prevent creation of .DS_Store files on network volumes. Requires logout/login.",
                    category: "Finder",
                    platform: "macos",
                    scope: "persistent",
                    riskLevel: "low",
                    supportedOS: ["ventura", "sonoma", "sequoia"],
                    apply: [
                        TweakOperation(
                            type: "defaults",
                            domain: "com.apple.desktopservices",
                            key: "DSDontWriteNetworkStores",
                            value: .bool(true),
                            command: nil
                        )
                    ],
                    revert: [
                        TweakOperation(
                            type: "defaults",
                            domain: "com.apple.desktopservices",
                            key: "DSDontWriteNetworkStores",
                            value: .bool(false),
                            command: nil
                        )
                    ]
                ),

                Tweak(
                    id: "desktop.disable-dsstore-usb",
                    name: "Disable .DS_Store on USB Volumes",
                    description: "Prevent creation of .DS_Store files on USB volumes. Requires logout/login.",
                    category: "Finder",
                    platform: "macos",
                    scope: "persistent",
                    riskLevel: "low",
                    supportedOS: ["ventura", "sonoma", "sequoia"],
                    apply: [
                        TweakOperation(
                            type: "defaults",
                            domain: "com.apple.desktopservices",
                            key: "DSDontWriteUSBStores",
                            value: .bool(true),
                            command: nil
                        )
                    ],
                    revert: [
                        TweakOperation(
                            type: "defaults",
                            domain: "com.apple.desktopservices",
                            key: "DSDontWriteUSBStores",
                            value: .bool(false),
                            command: nil
                        )
                    ]
                ),
            Tweak(
                    id: "dock.dim-hidden-apps",
                    name: "Dim Hidden Applications",
                    description: "Use dimmed icons for hidden applications in the Dock.",
                    category: "Dock",
                    platform: "macos",
                    scope: "persistent",
                    riskLevel: "low",
                    supportedOS: ["ventura", "sonoma", "sequoia"],
                    apply: [
                        TweakOperation(
                            type: "defaults",
                            domain: "com.apple.dock",
                            key: "showhidden",
                            value: .bool(true),
                            command: nil
                        ),
                        TweakOperation(
                            type: "shell",
                            domain: nil,
                            key: nil,
                            value: nil,
                            command: "killall Dock"
                        )
                    ],
                    revert: [
                        TweakOperation(
                            type: "defaults",
                            domain: "com.apple.dock",
                            key: "showhidden",
                            value: .bool(false),
                            command: nil
                        ),
                        TweakOperation(
                            type: "shell",
                            domain: nil,
                            key: nil,
                            value: nil,
                            command: "killall Dock"
                        )
                    ]
                ),

                Tweak(
                    id: "dock.add-spacer",
                    name: "Add Blank Space to Dock",
                    description: "Adds a blank spacer tile to the Dock. This tweak has no automatic revert; the spacer can be removed by dragging it out of the Dock manually.",
                    category: "Dock",
                    platform: "macos",
                    scope: "one-off",
                    riskLevel: "low",
                    supportedOS: ["ventura", "sonoma", "sequoia"],
                    apply: [
                        TweakOperation(
                            type: "shell",
                            domain: nil,
                            key: nil,
                            value: nil,
                            command: #"defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'"#
                        ),
                        TweakOperation(
                            type: "shell",
                            domain: nil,
                            key: nil,
                            value: nil,
                            command: "killall Dock"
                        )
                    ],
                    revert: [
                        TweakOperation(
                            type: "shell",
                            domain: nil,
                            key: nil,
                            value: nil,
                            command: "echo This tweak has no automatic revert. Remove manually from Dock."
                        )
                    ]
                ),

                Tweak(
                    id: "dock.autohide-animation-speed",
                    name: "Set Dock Auto-hide Animation Speed",
                    description: "Adjust the Dock auto-hide animation speed. Lower values make the animation faster.",
                    category: "Dock",
                    platform: "macos",
                    scope: "persistent",
                    riskLevel: "low",
                    supportedOS: ["ventura", "sonoma", "sequoia"],
                    apply: [
                        TweakOperation(
                            type: "defaults",
                            domain: "com.apple.dock",
                            key: "autohide-time-modifier",
                            value: .double(0.1), // Fallback
                            parameterRef: "speed",
                            command: nil
                        ),
                        TweakOperation(
                            type: "shell",
                            domain: nil,
                            key: nil,
                            value: nil,
                            command: "killall Dock"
                        )
                    ],
                    revert: [
                        TweakOperation(
                            type: "shell",
                            domain: nil,
                            key: nil,
                            value: nil,
                            command: "defaults delete com.apple.dock autohide-time-modifier"
                        ),
                        TweakOperation(
                            type: "shell",
                            domain: nil,
                            key: nil,
                            value: nil,
                            command: "killall Dock"
                        )
                    ],
                    parameters: [
                        TweakParameter(
                            id: "speed",
                            name: "Animation Duration (seconds)",
                            description: "0.01 is instant, 0.6 is slow.",
                            type: .float,
                            defaultValue: .double(0.1),
                            min: 0.01,
                            max: 0.6
                        )
                    ]
                ),

                Tweak(
                    id: "dock.autohide-animation-delay",
                    name: "Set Dock Auto-hide Animation Delay",
                    description: "Adjust the delay before the Dock auto-hide animation starts.",
                    category: "Dock",
                    platform: "macos",
                    scope: "persistent",
                    riskLevel: "low",
                    supportedOS: ["ventura", "sonoma", "sequoia"],
                    apply: [
                        TweakOperation(
                            type: "defaults",
                            domain: "com.apple.dock",
                            key: "autohide-time-delay",
                            value: .double(0.0), // Fallback
                            parameterRef: "delay",
                            command: nil
                        ),
                        TweakOperation(
                            type: "shell",
                            domain: nil,
                            key: nil,
                            value: nil,
                            command: "killall Dock"
                        )
                    ],
                    revert: [
                        TweakOperation(
                            type: "shell",
                            domain: nil,
                            key: nil,
                            value: nil,
                            command: "defaults delete com.apple.dock autohide-time-delay"
                        ),
                        TweakOperation(
                            type: "shell",
                            domain: nil,
                            key: nil,
                            value: nil,
                            command: "killall Dock"
                        )
                    ],
                    parameters: [
                        TweakParameter(
                            id: "delay",
                            name: "Animation Delay (seconds)",
                            description: "No delay (0.0) is standard.",
                            type: .float,
                            defaultValue: .double(0.0),
                            min: 0.0,
                            max: 2.0
                        )
                    ]
                )


        ]
    }
}

/// Loads tweaks from a remote URL.
class CommunityTweakSource: TweakSourceProtocol {
    private let url: URL
    private let session: URLSession
    
    init(url: URL) {
        self.url = url
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.timeoutIntervalForRequest = 30.0
        config.waitsForConnectivity = true
        self.session = URLSession(configuration: config)
    }
    
    func loadTweaks() async throws -> [Tweak] {
        let maxRetries = 3
        var lastError: Error?
        
        await MainActor.run { ConsoleLogger.shared.log("Fetching community tweaks from: \(url.absoluteString)") }
        
        for attempt in 1...maxRetries {
            do {
                if attempt > 1 {
                    // Exponential backoff: 0.5s, 1s, 2s...
                    let delay = UInt64(0.5 * pow(2.0, Double(attempt - 2)) * 1_000_000_000)
                    try await Task.sleep(nanoseconds: delay)
                    await MainActor.run { ConsoleLogger.shared.log("Retrying fetch (attempt \(attempt))...") }
                }
                
                let (data, response) = try await self.session.data(from: url)
                
                if let httpResponse = response as? HTTPURLResponse {
                    await MainActor.run { ConsoleLogger.shared.log("Status: \(httpResponse.statusCode)") }
                    if !(200...299).contains(httpResponse.statusCode) {
                        throw URLError(.badServerResponse)
                    }
                }
                
                let wrapper = try JSONDecoder().decode(TweakListWrapper.self, from: data)
                await MainActor.run { ConsoleLogger.shared.log("Successfully loaded \(wrapper.tweaks.count) tweaks.") }
                return wrapper.tweaks
                
            } catch {
                await MainActor.run { ConsoleLogger.shared.log("Fetch failed (attempt \(attempt)): \(error.localizedDescription)") }
                lastError = error
            }
        }
        
        throw TweakSourceError.networkError(lastError ?? URLError(.unknown))
    }
}

// Wrapper for the top-level JSON object
struct TweakListWrapper: Codable {
    let tweaks: [Tweak]
}
