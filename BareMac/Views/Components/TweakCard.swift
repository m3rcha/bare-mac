import SwiftUI

struct TweakCard: View {
    let tweak: Tweak
    let isActive: Bool
    let onToggle: () -> Void
    
    @State private var isHovering = false
    @State private var isLoading = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(tweak.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(tweak.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Toggle("", isOn: Binding(
                get: { isActive },
                set: { _ in
                    Task {
                        isLoading = true
                        onToggle()
                        isLoading = false
                    }
                }
            ))
            .toggleStyle(.switch)
            .disabled(isLoading)
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(isHovering ? 0.1 : 0.05), radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primary.opacity(isHovering ? 0.1 : 0.05), lineWidth: 1)
        )
        .scaleEffect(isHovering ? 1.01 : 1.0)
        .animation(.easeOut(duration: 0.2), value: isHovering)
        .onHover { hover in
            isHovering = hover
        }
    }
}
