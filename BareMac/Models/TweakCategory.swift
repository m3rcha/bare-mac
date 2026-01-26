import Foundation

/// A collection of tweaks grouped under a category name.
struct TweakCategory: Identifiable, Hashable {
    var id: String { name }
    let name: String
    let icon: String // SF Symbol Name
    var tweaks: [Tweak]
    
    static func == (lhs: TweakCategory, rhs: TweakCategory) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
