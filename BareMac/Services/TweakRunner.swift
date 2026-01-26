import Foundation
import AppKit

/// Service responsible for executing system commands and managing defaults.
/// Actors ensure thread safety for async operations.
actor TweakRunner {
    static let shared = TweakRunner()
    private init() {}

    /// Sets a preference value for the given domain.
    func setDefaults(domain: String, key: String, value: Any, byHost: Bool = false) {
        let appId = (domain == "NSGlobalDomain") ? kCFPreferencesAnyApplication : domain as CFString
        let host = byHost ? kCFPreferencesCurrentHost : kCFPreferencesAnyHost
        CFPreferencesSetValue(key as CFString, value as CFPropertyList, appId, kCFPreferencesCurrentUser, host)
        CFPreferencesSynchronize(appId, kCFPreferencesCurrentUser, host)
    }

    /// Reads a preference value for the given domain.
    func getDefaults(domain: String, key: String, byHost: Bool = false) -> Any? {
        let appId = (domain == "NSGlobalDomain") ? kCFPreferencesAnyApplication : domain as CFString
        let host = byHost ? kCFPreferencesCurrentHost : kCFPreferencesAnyHost
        return CFPreferencesCopyValue(key as CFString, appId, kCFPreferencesCurrentUser, host)
    }

    /// Removes a preference value for the given domain.
    func removeDefaults(domain: String, key: String, byHost: Bool = false) {
        let appId = (domain == "NSGlobalDomain") ? kCFPreferencesAnyApplication : domain as CFString
        let host = byHost ? kCFPreferencesCurrentHost : kCFPreferencesAnyHost
        CFPreferencesSetValue(key as CFString, nil, appId, kCFPreferencesCurrentUser, host)
        CFPreferencesSynchronize(appId, kCFPreferencesCurrentUser, host)
    }

    /// Terminates running applications with the provided bundle identifier.
    @MainActor
    func terminateApp(bundleId: String) {
        let apps = NSRunningApplication.runningApplications(withBundleIdentifier: bundleId)
        for app in apps {
            app.terminate()
        }
    }
    
    /// Executes a shell command with administrator privileges using AppleScript.
    @MainActor
    func runAdminCommand(_ command: String) async -> Bool {
        return await withCheckedContinuation { continuation in
            let scriptSource = "do shell script \"\(command)\" with administrator privileges"
            var error: NSDictionary?
            if let scriptObject = NSAppleScript(source: scriptSource) {
                scriptObject.executeAndReturnError(&error)
                if let error = error {
                    print("Admin command failed: \(error)")
                    continuation.resume(returning: false)
                } else {
                    continuation.resume(returning: true)
                }
            } else {
                continuation.resume(returning: false)
            }
        }
    }
}
