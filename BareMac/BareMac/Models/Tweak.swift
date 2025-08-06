import Foundation

struct Tweak: Identifiable {
    let id = UUID()
    let name: String
    let command: String
    let revertCommand: String
    let category: TweakCategory
    let detectCommand: String?
    
    init(name: String,
         command: String,
         revertCommand: String,
         category: TweakCategory,
         detectCommand: String? = nil) {
        self.name = name
        self.command = command
        self.revertCommand = revertCommand
        self.category = category
        self.detectCommand = detectCommand
    }
}
