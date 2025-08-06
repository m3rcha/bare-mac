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
        guard let detect = tweak.detect else { return }
        Task {
            let value = await detect()
            await MainActor.run { self.isOn = value }
        }
    }

    private func apply(_ enabled: Bool) async {
        let ok = await tweak.setState(enabled)
        if !ok {
            await MainActor.run { isOn.toggle() }
            print("[TweakRow] Toggle failed")
        }
    }
}
