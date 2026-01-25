import Foundation

/// A collection of tweaks grouped under a category name.
struct TweakCategory: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String // SF Symbol Name
    var tweaks: [Tweak]
    
    static func == (lhs: TweakCategory, rhs: TweakCategory) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
