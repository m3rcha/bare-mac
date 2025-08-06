import SwiftUI
import Foundation

struct ContentView: View {
    @StateObject private var vm = TweakViewModel()
    var body: some View {
        List(vm.tweaks) { tweak in
            TweakRow(tweak: tweak)
        }
        .frame(minWidth: 300, minHeight: 400)
    }
}
