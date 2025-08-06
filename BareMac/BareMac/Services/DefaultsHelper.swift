import Foundation

enum DefaultsHelper {
    static func setBool(_ value: Bool, domain: String, key: String) -> Bool {
        guard let defaults = UserDefaults(suiteName: domain) else { return false }
        defaults.set(value, forKey: key)
        return defaults.synchronize()
    }

    static func getBool(domain: String, key: String) -> Bool {
        guard let defaults = UserDefaults(suiteName: domain) else { return false }
        return defaults.bool(forKey: key)
    }
}
