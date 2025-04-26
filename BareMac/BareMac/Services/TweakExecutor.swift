import Foundation

enum TweakExecutor {
    static func run(_ cmd: String) async -> Bool {
        await withCheckedContinuation { cont in
            let p = Process()
            p.launchPath = "/bin/zsh"
            p.arguments = ["-c", cmd]
            p.terminationHandler = { cont.resume(returning: $0.terminationStatus == 0) }
            try? p.run()
        }
    }
}
