import Foundation
import AppKit

/// Service responsible for executing system commands and managing defaults.
/// Actors ensure thread safety for async operations.
actor TweakRunner {
    static let shared = TweakRunner()
    private init() {}

    /// Executes a single tweak operation.
    /// - Parameters:
    ///   - operation: The operation to perform.
    ///   - context: Optional dictionary of parameter values (Key: Parameter ID).
    @MainActor
    func executeOperation(_ operation: TweakOperation, context: [String: Any]? = nil) async -> Bool {
        ConsoleLogger.shared.log("Executing \(operation.type): \(operation.description)")
        switch operation.type {
        case "defaults":
            guard let domain = operation.domain,
                  let key = operation.key else { 
                ConsoleLogger.shared.log("Error: Missing domain/key for defaults operation")
                return false 
            }
            
            // value resolution priority: 1. Context (via parameterRef) 2. Static Value
            var effectiveValue: Any? = operation.value?.anyValue
            
            if let paramRef = operation.parameterRef, 
               let contextValue = context?[paramRef] {
                effectiveValue = contextValue
                ConsoleLogger.shared.log("Using injected value for '\(paramRef)': \(contextValue)")
            }
            
            guard let finalValue = effectiveValue else {
                ConsoleLogger.shared.log("Error: No value provided for defaults operation")
                return false
            }

            await setDefaults(domain: domain, key: key, value: finalValue)
            ConsoleLogger.shared.log("Set defaults: \(domain) \(key) = \(finalValue)")
            return true
            
        case "shell":
            guard var command = operation.command else { 
                ConsoleLogger.shared.log("Error: Missing command for shell operation")
                return false 
            }
            
            // Perform substitutions for parameters in shell command
            // Syntax: {{parameter_id}}
            if let context = context {
                for (paramID, val) in context {
                    command = command.replacingOccurrences(of: "{{\(paramID)}}", with: "\(val)")
                }
            }
            
            let success = await runShellCommand(command)
            ConsoleLogger.shared.log("Shell command finished. Success: \(success)")
            return success
            
        case "admin":
            guard let command = operation.command else { 
                ConsoleLogger.shared.log("Error: Missing command for admin operation")
                return false 
            }
            let success = await runAdminCommand(command)
            ConsoleLogger.shared.log("Admin command finished. Success: \(success)")
            return success
            
        default:
            ConsoleLogger.shared.log("Unknown operation type: \(operation.type)")
            return false
        }
    }

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
        ConsoleLogger.shared.log("Terminating app: \(bundleId)")
        let apps = NSRunningApplication.runningApplications(withBundleIdentifier: bundleId)
        for app in apps {
            app.terminate()
        }
    }
    
    /// Executes a standard shell command (non-admin).
    @MainActor
    func runShellCommand(_ command: String) async -> Bool {
        ConsoleLogger.shared.log("$ \(command)")
        let task = Process()
        task.launchPath = "/bin/zsh"
        task.arguments = ["-c", command]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        
        return await withCheckedContinuation { continuation in
            task.terminationHandler = { process in
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let output = String(data: data, encoding: .utf8), !output.isEmpty {
                    Task { @MainActor in
                        ConsoleLogger.shared.log(output.trimmingCharacters(in: .whitespacesAndNewlines))
                    }
                }
                continuation.resume(returning: process.terminationStatus == 0)
            }
            do {
                try task.run()
            } catch {
                ConsoleLogger.shared.log("Shell command failed: \(error)")
                continuation.resume(returning: false)
            }
        }
    }
    
    /// Executes a shell command with administrator privileges using AppleScript.
    @MainActor
    func runAdminCommand(_ command: String) async -> Bool {
        ConsoleLogger.shared.log("sudo $ \(command)")
        return await withCheckedContinuation { continuation in
            let scriptSource = "do shell script \"\(command)\" with administrator privileges"
            var error: NSDictionary?
            if let scriptObject = NSAppleScript(source: scriptSource) {
                scriptObject.executeAndReturnError(&error)
                if let error = error {
                    ConsoleLogger.shared.log("Admin command failed: \(error)")
                    continuation.resume(returning: false)
                } else {
                    ConsoleLogger.shared.log("Admin command succeeded")
                    continuation.resume(returning: true)
                }
            } else {
                continuation.resume(returning: false)
            }
        }
    }
}

fileprivate extension TweakOperation {
    var description: String {
        switch type {
        case "defaults": return "\(domain ?? "?") \(key ?? "?") = \(String(describing: value))"
        case "shell", "admin": return command ?? "?"
        default: return type
        }
    }
}

@MainActor
class ConsoleLogger: ObservableObject {
    static let shared = ConsoleLogger()
    
    @Published var logs: String = ""
    @Published var isVisible: Bool = true
    
    private init() {
        log("Console ready.")
    }
    
    func log(_ message: String) {
        // Since this is called from @MainActor, we can update directly
        // But if called from background threads in the future, we might need Task { @MainActor in ... }
        // For now, TweakRunner calls are MainActor or async context.
        
        let timestamp = Date().formatted(date: .omitted, time: .standard)
        let newLog = "[\(timestamp)] \(message)\n"
        
        logs += newLog
        
        if logs.count > 100_000 {
            logs = String(logs.suffix(50_000))
        }
    }
    
    func clear() {
        logs = ""
    }
}
