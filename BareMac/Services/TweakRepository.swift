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

/// Loads tweaks from a remote URL with caching and validation.
class CommunityTweakSource: TweakSourceProtocol {
    private let url: URL
    private let session: URLSession
    
    /// Cache directory for community tweaks
    private static var cacheDirectory: URL? {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?
            .appendingPathComponent("BareMac")
            .appendingPathComponent("CommunityTweaks")
    }
    
    /// Cache file path based on URL hash
    private var cacheFilePath: URL? {
        guard let cacheDir = Self.cacheDirectory else { return nil }
        let hash = url.absoluteString.hash
        return cacheDir.appendingPathComponent("tweaks_\(abs(hash)).json")
    }
    
    init(url: URL) {
        self.url = url
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.timeoutIntervalForRequest = 30.0
        config.waitsForConnectivity = true
        self.session = URLSession(configuration: config)
    }
    
    /// Validates that the URL is a valid HTTPS URL pointing to a JSON file
    static func validateURL(_ urlString: String) -> (isValid: Bool, error: String?) {
        guard let url = URL(string: urlString) else {
            return (false, "Invalid URL format")
        }
        
        guard url.scheme == "https" else {
            return (false, "URL must use HTTPS for security")
        }
        
        guard url.host != nil else {
            return (false, "URL must have a valid host")
        }
        
        // Optional: Check for .json extension
        if !url.pathExtension.isEmpty && url.pathExtension.lowercased() != "json" {
            return (false, "URL should point to a JSON file")
        }
        
        return (true, nil)
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
                        throw TweakSourceError.networkError(URLError(.badServerResponse))
                    }
                }
                
                let tweaks = try decodeTweaks(from: data)
                
                // Cache the successful response
                await cacheData(data)
                
                await MainActor.run { ConsoleLogger.shared.log("Successfully loaded \(tweaks.count) community tweaks.") }
                return tweaks
                
            } catch let decodingError as DecodingError {
                await MainActor.run { 
                    ConsoleLogger.shared.log("JSON parsing error: \(Self.friendlyDecodingError(decodingError))") 
                }
                // Don't retry on decoding errors - the data is bad
                throw TweakSourceError.decodingFailed(decodingError)
                
            } catch {
                await MainActor.run { ConsoleLogger.shared.log("Fetch failed (attempt \(attempt)): \(error.localizedDescription)") }
                lastError = error
            }
        }
        
        // All retries failed - try loading from cache
        if let cachedTweaks = await loadFromCache() {
            await MainActor.run { ConsoleLogger.shared.log("Using cached community tweaks (\(cachedTweaks.count) tweaks)") }
            return cachedTweaks
        }
        
        throw TweakSourceError.networkError(lastError ?? URLError(.unknown))
    }
    
    /// Decodes tweaks from JSON data and marks them as community source
    private func decodeTweaks(from data: Data) throws -> [Tweak] {
        let wrapper = try JSONDecoder().decode(TweakListWrapper.self, from: data)
        
        // Mark all tweaks as community source
        return wrapper.tweaks.map { tweak in
            var mutableTweak = tweak
            mutableTweak.source = .community
            return mutableTweak
        }
    }
    
    /// Caches data to disk
    private func cacheData(_ data: Data) async {
        guard let cacheDir = Self.cacheDirectory,
              let cachePath = cacheFilePath else { return }
        
        do {
            try FileManager.default.createDirectory(at: cacheDir, withIntermediateDirectories: true)
            try data.write(to: cachePath)
            await MainActor.run { ConsoleLogger.shared.log("Cached community tweaks to disk") }
        } catch {
            await MainActor.run { ConsoleLogger.shared.log("Failed to cache tweaks: \(error.localizedDescription)") }
        }
    }
    
    /// Loads tweaks from cache
    private func loadFromCache() async -> [Tweak]? {
        guard let cachePath = cacheFilePath,
              FileManager.default.fileExists(atPath: cachePath.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: cachePath)
            return try decodeTweaks(from: data)
        } catch {
            await MainActor.run { ConsoleLogger.shared.log("Failed to load cached tweaks: \(error.localizedDescription)") }
            return nil
        }
    }
    
    /// Converts DecodingError to user-friendly message
    static func friendlyDecodingError(_ error: DecodingError) -> String {
        switch error {
        case .keyNotFound(let key, let context):
            return "Missing required field '\(key.stringValue)' at \(context.codingPath.map { $0.stringValue }.joined(separator: "."))"
        case .typeMismatch(let type, let context):
            return "Invalid type (expected \(type)) at \(context.codingPath.map { $0.stringValue }.joined(separator: "."))"
        case .valueNotFound(let type, let context):
            return "Missing value (expected \(type)) at \(context.codingPath.map { $0.stringValue }.joined(separator: "."))"
        case .dataCorrupted(let context):
            return "Corrupted data: \(context.debugDescription)"
        @unknown default:
            return error.localizedDescription
        }
    }
    
    /// Clears the cache for this URL
    func clearCache() {
        guard let cachePath = cacheFilePath else { return }
        try? FileManager.default.removeItem(at: cachePath)
    }
    
    /// Clears all community tweak caches
    static func clearAllCaches() {
        guard let cacheDir = cacheDirectory else { return }
        try? FileManager.default.removeItem(at: cacheDir)
    }
}

// Wrapper for the top-level JSON object
struct TweakListWrapper: Codable {
    let tweaks: [Tweak]
}
