import SwiftUI

struct ContentView: View {
    @StateObject private var vm = TweakViewModel()

    var body: some View {
        List {
            ForEach(TweakCategory.allCases, id: \.self) { category in
                Section(header: Text(category.rawValue)) {
                    ForEach(vm.tweaks.filter { $0.category == category }) { tweak in
                        TweakRow(tweak: tweak)
                    }
                }
            }
        }
        .frame(minWidth: 300, minHeight: 400)
    }
}
