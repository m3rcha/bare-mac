import SwiftUI

struct TweakRow: View {
    @Binding var tweak: Tweak
    let onToggle: (String) -> Void

    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                tweak.isSelected.toggle()
                let task = Process()
                task.standardOutput = FileHandle.nullDevice
                task.standardError = FileHandle.nullDevice
                task.launchPath = "/bin/zsh"
                task.arguments = ["-c", tweak.isSelected ? tweak.command : tweak.revertCommand]
                try? task.run()
                onToggle(tweak.isSelected ? "enabled" : "reverted")
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: tweak.isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(tweak.isSelected ? .accentColor : .secondary)
                VStack(alignment: .leading, spacing: 4) {
                    Text(tweak.name)
                        .font(.system(.body, design: .monospaced))
                        .fontWeight(.medium)
                    Text(tweak.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(nsColor: .controlBackgroundColor).opacity(0.15))
            )
            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
