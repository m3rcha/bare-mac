import Foundation
import AppKit

/// Service responsible for executing system commands and managing defaults.
/// Actors ensure thread safety for async operations.
actor TweakRunner {
    static let shared = TweakRunner()
    private init() {}

    /// Sets a preference value for the given domain.
    func setDefaults(domain: String, key: String, value: Any) {
        if let defaults = UserDefaults(suiteName: domain) {
            defaults.set(value, forKey: key)
            defaults.synchronize()
        } else {
            UserDefaults.standard.set(value, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }

    /// Reads a preference value for the given domain.
    func getDefaults(domain: String, key: String) -> Any? {
        if let defaults = UserDefaults(suiteName: domain) {
            return defaults.object(forKey: key)
        } else {
            return UserDefaults.standard.object(forKey: key)
        }
    }

    /// Removes a preference value for the given domain.
    func removeDefaults(domain: String, key: String) {
        if let defaults = UserDefaults(suiteName: domain) {
            defaults.removeObject(forKey: key)
            defaults.synchronize()
        } else {
            UserDefaults.standard.removeObject(forKey: key)
            UserDefaults.standard.synchronize()
        }
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
