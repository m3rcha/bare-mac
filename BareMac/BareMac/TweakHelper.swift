import Foundation
import AppKit

/// Actor-based helper that applies and reverts tweaks without shell scripts.
actor TweakHelper {
    static let shared = TweakHelper()
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
