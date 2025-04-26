import SwiftUI
import Foundation

struct ContentView: View {
    @StateObject private var vm = TweakViewModel()
    var body: some View {
        List(vm.tweaks) { tweak in
            Button(tweak.name) { vm.toggle(tweak) }
        }
        .frame(minWidth: 300, minHeight: 400)
    }
}
