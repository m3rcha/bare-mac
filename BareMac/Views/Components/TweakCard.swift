import SwiftUI

struct TweakCard: View {
    let tweak: Tweak
    let isActive: Bool
    let onToggle: () -> Void // Used for simple toggles or Revert
    let onApplyWithParams: (([String: Any]) -> Void)? // Optional handler for parameterized apply
    
    @State private var isExpanded: Bool = false
    @State private var paramValues: [String: AnyCodable] = [:]
    @State private var showRiskConfirmation: Bool = false
    
    init(tweak: Tweak, isActive: Bool, onToggle: @escaping () -> Void, onApplyWithParams: (([String: Any]) -> Void)? = nil) {
        self.tweak = tweak
        self.isActive = isActive
        self.onToggle = onToggle
        self.onApplyWithParams = onApplyWithParams
        
        // Initialize default param values
        if let params = tweak.parameters {
            var defaults: [String: AnyCodable] = [:]
            for p in params {
                defaults[p.id] = p.defaultValue
            }
            _paramValues = State(initialValue: defaults)
        }
    }
    
    /// Whether this tweak requires confirmation before applying
    private var requiresConfirmation: Bool {
        tweak.riskLevel.lowercased() == "high" || tweak.riskLevel.lowercased() == "experimental"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                // Icon
                Image(systemName: "gearshape.fill") // Placeholder or category icon
                    .font(.title2)
                    .foregroundStyle(.blue)
                    .frame(width: 32, height: 32)
                    .background(.blue.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(tweak.name)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        RiskBadge(riskLevel: tweak.riskLevel)
                        SourceBadge(source: tweak.source)
                    }
                    
                    Text(tweak.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
                
                // Action Button
                if let params = tweak.parameters, !params.isEmpty, !isActive {
                    // Parameterized Tweak: Show Tweak Name + Chevron to expand
                    Button(action: {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }) {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.secondary)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                } else {
                    // Simple Tweak or Active Parameterized (Revert)
                    Toggle("", isOn: Binding(
                        get: { isActive },
                        set: { newValue in
                            // Only show confirmation when enabling a high-risk tweak
                            if newValue && !isActive && requiresConfirmation {
                                showRiskConfirmation = true
                            } else {
                                onToggle()
                            }
                        }
                    ))
                    .toggleStyle(.switch)
                    .controlSize(.mini)
                }
            }
            
            // Parameter Configuration Area
            if isExpanded, let params = tweak.parameters {
                Divider()
                
                ForEach(params) { param in
                    ParameterInputView(parameter: param, value: Binding(
                        get: { paramValues[param.id] ?? param.defaultValue },
                        set: { paramValues[param.id] = $0 }
                    ))
                }
                
                HStack {
                    Spacer()
                    Button("Apply Tweak") {
                        if requiresConfirmation {
                            showRiskConfirmation = true
                        } else {
                            applyWithCurrentParams()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isActive) // Should not happen if logic above is correct, but safe guard
                }
            }
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )
        .alert("High Risk Tweak", isPresented: $showRiskConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Apply Anyway", role: .destructive) {
                if tweak.parameters?.isEmpty == false && isExpanded {
                    applyWithCurrentParams()
                } else {
                    onToggle()
                }
            }
        } message: {
            Text("'\(tweak.name)' is marked as \(tweak.riskLevel). This tweak may cause system instability or require a restart to revert. Are you sure you want to apply it?")
        }
    }
    
    private func applyWithCurrentParams() {
        var rawParams: [String: Any] = [:]
        for (k, v) in paramValues {
            rawParams[k] = v.anyValue
        }
        onApplyWithParams?(rawParams)
        withAnimation { isExpanded = false }
    }
}

// MARK: - Risk Badge Component

struct RiskBadge: View {
    let riskLevel: String
    
    private var color: Color {
        switch riskLevel.lowercased() {
        case "low": return .green
        case "medium": return .yellow
        case "high": return .orange
        case "experimental": return .red
        default: return .gray
        }
    }
    
    private var icon: String {
        switch riskLevel.lowercased() {
        case "low": return "checkmark.shield"
        case "medium": return "exclamationmark.shield"
        case "high": return "exclamationmark.triangle"
        case "experimental": return "flask"
        default: return "questionmark.circle"
        }
    }
    
    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: icon)
                .font(.caption2)
            Text(riskLevel.capitalized)
                .font(.caption2)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(color.opacity(0.15))
        .foregroundColor(color)
        .clipShape(Capsule())
    }
}

// MARK: - Source Badge Component

struct SourceBadge: View {
    let source: TweakSource
    
    var body: some View {
        if source == .community {
            HStack(spacing: 3) {
                Image(systemName: "globe")
                    .font(.caption2)
                Text("Community")
                    .font(.caption2)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.purple.opacity(0.15))
            .foregroundColor(.purple)
            .clipShape(Capsule())
        }
    }
}

struct ParameterInputView: View {
    let parameter: TweakParameter
    @Binding var value: AnyCodable
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(parameter.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                if let desc = parameter.description {
                    Text(desc)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            switch parameter.type {
            case .string:
                TextField(parameter.name, text: Binding(
                    get: {
                        if case .string(let s) = value { return s }
                        return ""
                    },
                    set: { value = .string($0) }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
            case .bool:
                Toggle(parameter.name, isOn: Binding(
                    get: {
                        if case .bool(let b) = value { return b }
                        return false
                    },
                    set: { value = .bool($0) }
                ))
                
            case .int:
                TextField(parameter.name, value: Binding(
                    get: {
                        if case .int(let i) = value { return i }
                        return 0
                    },
                    set: { value = .int($0) }
                ), formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
            case .float:
                if let min = parameter.min, let max = parameter.max {
                    VStack {
                        Slider(
                            value: Binding(
                                get: {
                                    if case .double(let d) = value { return d }
                                    // Handle float stored as int or other cases?
                                    // For now assume strictly double
                                    return 0.0
                                },
                                set: { value = .double($0) }
                            ),
                            in: min...max
                        )
                        .layoutPriority(1)
                        
                        Text(String(format: "%.2f", (value.anyValue as? Double) ?? 0.0))
                            .font(.caption)
                            .monospacedDigit()
                    }
                } else {
                    TextField(parameter.name, value: Binding(
                        get: {
                            if case .double(let d) = value { return d }
                            return 0.0
                        },
                        set: { value = .double($0) }
                    ), formatter: {
                        let f = NumberFormatter()
                        f.numberStyle = .decimal
                        return f
                    }())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
        }
        .padding(.vertical, 4)
    }
}
