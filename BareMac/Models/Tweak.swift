import Foundation

/// Represents a single system tweak.
struct Tweak: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let apply: () async -> Void
    let revert: () async -> Void
    let check: () async -> Bool
    
    // Hashable conformance for UI loops
    static func == (lhs: Tweak, rhs: Tweak) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
