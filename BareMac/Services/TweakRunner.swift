import Foundation
import AppKit

/// Service responsible for executing system commands and managing defaults.
/// Actors ensure thread safety for async operations.
actor TweakRunner {
    static let shared = TweakRunner()
    private init() {}

    /// Sets a preference value for the given domain.
    func setDefaults(domain: String, key: String, value: Any) {
        let appId = (domain == "NSGlobalDomain") ? kCFPreferencesAnyApplication : domain as CFString
        CFPreferencesSetValue(key as CFString, value as CFPropertyList, appId, kCFPreferencesCurrentUser, kCFPreferencesAnyHost)
        CFPreferencesSynchronize(appId, kCFPreferencesCurrentUser, kCFPreferencesAnyHost)
    }

    /// Reads a preference value for the given domain.
    func getDefaults(domain: String, key: String) -> Any? {
        let appId = (domain == "NSGlobalDomain") ? kCFPreferencesAnyApplication : domain as CFString
        return CFPreferencesCopyValue(key as CFString, appId, kCFPreferencesCurrentUser, kCFPreferencesAnyHost)
    }

    /// Removes a preference value for the given domain.
    func removeDefaults(domain: String, key: String) {
        let appId = (domain == "NSGlobalDomain") ? kCFPreferencesAnyApplication : domain as CFString
        CFPreferencesSetValue(key as CFString, nil, appId, kCFPreferencesCurrentUser, kCFPreferencesAnyHost)
        CFPreferencesSynchronize(appId, kCFPreferencesCurrentUser, kCFPreferencesAnyHost)
    }

    /// Terminates running applications with the provided bundle identifier.
    @MainActor
    func terminateApp(bundleId: String) {
        let apps = NSRunningApplication.runningApplications(withBundleIdentifier: bundleId)
        for app in apps {
            app.terminate()
        }
    }
}
