import SwiftUI
import Foundation

struct TweakRow: View {
    let tweak: Tweak
    @State private var isOn: Bool = false

    var body: some View {
        Toggle(isOn: $isOn) {
            Text(tweak.name)
                .font(.system(size: 14, weight: .medium, design: .monospaced))
        }
        .toggleStyle(.switch)
        .padding(.vertical, 4)
        .onAppear(perform: detectInitialState)
        .onChange(of: isOn) { newValue in
            Task { await apply(newValue) }
        }
    }

    private func detectInitialState() {
    }

    private func apply(_ enabled: Bool) async {
        let cmd = enabled ? tweak.command : tweak.revertCommand
        let ok = await TweakExecutor.run(cmd)
        if !ok {
            isOn.toggle()
            print("[TweakRow] Command failed")
        }
    }
}
