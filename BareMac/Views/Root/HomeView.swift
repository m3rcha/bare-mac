import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            Sidebar(viewModel: viewModel)
                .frame(width: 220)
            
            Divider()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text(viewModel.searchText.isEmpty ? (viewModel.selectedCategory?.name ?? "Tweaks") : "Search Results")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    SearchBar(text: $viewModel.searchText)
                        .frame(width: 250)
                }
                .padding()
                .background(Color(nsColor: .windowBackgroundColor))
                
                // Content
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 16)], spacing: 16) {
                        ForEach(viewModel.filteredTweaks) { tweak in
                            TweakCard(
                                tweak: tweak,
                                isActive: viewModel.isTweakActive(tweak),
                                onToggle: {
                                    Task {
                                        await viewModel.toggleTweak(tweak)
                                    }
                                },
                                onApplyWithParams: { params in
                                    Task {
                                        await viewModel.applyTweak(tweak, params: params)
                                    }
                                }
                            )
                        }
                    }
                    .padding()
                }
                
                ConsoleView() // In-app console at the bottom of the main content area
            }
        }
        .frame(minWidth: 900, minHeight: 600)
        .task {
            // Initial data load handled in App
        }
    }
}

struct SandboxView: View {
    @State private var jsonInput: String = """
    {
      "id": "sandbox.test",
      "name": "Test Tweak",
      "description": "A temporary tweak for testing.",
      "category": "Sandbox",
      "platform": "macos",
      "scope": "temporary",
      "riskLevel": "experimental",
      "apply": [
        {
          "type": "shell",
          "command": "echo 'Hello Sandbox'"
        }
      ],
      "revert": [
        {
          "type": "shell",
          "command": "echo 'Goodbye Sandbox'"
        }
      ]
    }
    """
    @State private var logs: String = "Sandbox ready.\n"
    @State private var isApplying = false
    @State private var validationStatus: ValidationStatus = .unknown
    @State private var validationMessage: String = ""
    @State private var lastAppliedTweak: Tweak? = nil
    @State private var showSaveDialog = false
    @State private var saveName: String = ""
    
    enum ValidationStatus {
        case unknown, valid, invalid
        
        var color: Color {
            switch self {
            case .unknown: return .gray
            case .valid: return .green
            case .invalid: return .red
            }
        }
        
        var icon: String {
            switch self {
            case .unknown: return "questionmark.circle"
            case .valid: return "checkmark.circle.fill"
            case .invalid: return "xmark.circle.fill"
            }
        }
    }
    
    var body: some View {
        VSplitView {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Tweak Definition (JSON)")
                        .font(.headline)
                    
                    Spacer()
                    
                    // Validation Status Indicator
                    HStack(spacing: 4) {
                        Image(systemName: validationStatus.icon)
                            .foregroundColor(validationStatus.color)
                        Text(validationMessage)
                            .font(.caption)
                            .foregroundColor(validationStatus.color)
                    }
                    
                    Button("Validate") {
                        validateJSON()
                    }
                    .controlSize(.small)
                }
                .padding(.horizontal)
                
                TextEditor(text: $jsonInput)
                    .font(.monospaced(.body)())
                    .padding()
                    .background(Color(nsColor: .textBackgroundColor))
                    .cornerRadius(8)
                    .onChange(of: jsonInput) { _ in
                        // Reset validation status when input changes
                        validationStatus = .unknown
                        validationMessage = ""
                    }
            }
            .frame(minHeight: 200)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Execution Logs")
                        .font(.headline)
                    Spacer()
                    Button("Clear Logs") {
                        logs = ""
                    }
                    .controlSize(.small)
                }
                .padding(.horizontal)
                
                ScrollView {
                    Text(logs)
                        .font(.monospaced(.caption)())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .textSelection(.enabled)
                }
                .background(Color(nsColor: .textBackgroundColor))
                .cornerRadius(8)
            }
            .frame(minHeight: 100)
        }
        .padding()
        .toolbar {
            ToolbarItemGroup {
                Button(action: loadSavedTweak) {
                    Label("Load", systemImage: "folder")
                }
                
                Button(action: { showSaveDialog = true }) {
                    Label("Save", systemImage: "square.and.arrow.down")
                }
                .disabled(validationStatus != .valid)
                
                Divider()
                
                Button(action: { runTweak(revert: false) }) {
                    Label("Apply", systemImage: "play.fill")
                }
                .disabled(isApplying || validationStatus == .invalid)
                
                Button(action: { runTweak(revert: true) }) {
                    Label("Revert", systemImage: "arrow.counterclockwise")
                }
                .disabled(isApplying)
                
                Button(action: undoLastApply) {
                    Label("Undo Last", systemImage: "arrow.uturn.backward")
                }
                .disabled(lastAppliedTweak == nil || isApplying)
                .help("Revert the last applied tweak")
            }
        }
        .sheet(isPresented: $showSaveDialog) {
            SaveSandboxTweakSheet(
                name: $saveName,
                onSave: { saveTweak(name: saveName) },
                onCancel: { showSaveDialog = false }
            )
        }
    }
    
    private func validateJSON() {
        guard let data = jsonInput.data(using: .utf8) else {
            validationStatus = .invalid
            validationMessage = "Invalid encoding"
            return
        }
        
        do {
            let _ = try JSONDecoder().decode(Tweak.self, from: data)
            validationStatus = .valid
            validationMessage = "Valid tweak schema"
            log("✓ JSON validation passed")
        } catch let error as DecodingError {
            validationStatus = .invalid
            validationMessage = CommunityTweakSource.friendlyDecodingError(error)
            log("✗ Validation failed: \(validationMessage)")
        } catch {
            validationStatus = .invalid
            validationMessage = error.localizedDescription
            log("✗ Validation failed: \(error.localizedDescription)")
        }
    }
    
    private func runTweak(revert: Bool) {
        guard let data = jsonInput.data(using: .utf8) else {
            log("Error: Invalid string encoding")
            return
        }
        
        isApplying = true
        
        Task {
            do {
                let tweak = try JSONDecoder().decode(Tweak.self, from: data)
                log("Executing \(revert ? "Revert" : "Apply") for: \(tweak.name)")
                
                let operations = revert ? tweak.revert : tweak.apply
                for op in operations {
                    log("Running op: \(op.type)")
                    let result = await TweakRunner.shared.executeOperation(op)
                    log("Result: \(result ? "Success" : "Failure")")
                }
                log("Done.")
                
                // Store for undo (only on apply)
                if !revert {
                    lastAppliedTweak = tweak
                }
            } catch {
                log("JSON Decode Error: \(error)")
            }
            isApplying = false
        }
    }
    
    private func undoLastApply() {
        guard let tweak = lastAppliedTweak else { return }
        
        isApplying = true
        log("Undoing: \(tweak.name)")
        
        Task {
            for op in tweak.revert {
                log("Running revert op: \(op.type)")
                let result = await TweakRunner.shared.executeOperation(op)
                log("Result: \(result ? "Success" : "Failure")")
            }
            log("Undo complete.")
            lastAppliedTweak = nil
            isApplying = false
        }
    }
    
    private func saveTweak(name: String) {
        guard let data = jsonInput.data(using: .utf8),
              let saveDir = sandboxSaveDirectory else {
            log("Failed to save tweak")
            return
        }
        
        do {
            try FileManager.default.createDirectory(at: saveDir, withIntermediateDirectories: true)
            let fileName = name.isEmpty ? "sandbox_tweak" : name.replacingOccurrences(of: " ", with: "_")
            let fileURL = saveDir.appendingPathComponent("\(fileName).json")
            try data.write(to: fileURL)
            log("Saved tweak to: \(fileURL.lastPathComponent)")
        } catch {
            log("Save failed: \(error.localizedDescription)")
        }
        
        showSaveDialog = false
        saveName = ""
    }
    
    private func loadSavedTweak() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.json]
        panel.directoryURL = sandboxSaveDirectory
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        
        if panel.runModal() == .OK, let url = panel.url {
            do {
                jsonInput = try String(contentsOf: url, encoding: .utf8)
                log("Loaded: \(url.lastPathComponent)")
                validateJSON()
            } catch {
                log("Load failed: \(error.localizedDescription)")
            }
        }
    }
    
    private var sandboxSaveDirectory: URL? {
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?
            .appendingPathComponent("BareMac")
            .appendingPathComponent("SandboxTweaks")
    }
    
    private func log(_ message: String) {
        logs += "[\(Date().formatted(date: .omitted, time: .standard))] \(message)\n"
    }
}

// MARK: - Save Dialog Sheet

struct SaveSandboxTweakSheet: View {
    @Binding var name: String
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Save Sandbox Tweak")
                .font(.headline)
            
            TextField("Tweak name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 250)
            
            HStack {
                Button("Cancel", action: onCancel)
                    .keyboardShortcut(.cancelAction)
                Button("Save", action: onSave)
                    .keyboardShortcut(.defaultAction)
                    .disabled(name.isEmpty)
            }
        }
        .padding()
        .frame(width: 300)
    }
}



struct AdvancedSettingsView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @AppStorage("communityRepoURL") private var repoURL: String = "https://raw.githubusercontent.com/m3rcha/baremac-tweaks/3ade8c2086e18cad073cb05f3f12e74be33f04ee/tweaks.json"
    
    @State private var urlValidationError: String? = nil
    @State private var showResetConfirmation = false
    @State private var isResetting = false
    
    // Default URL for reset
    private let defaultURL = "https://raw.githubusercontent.com/m3rcha/baremac-tweaks/3ade8c2086e18cad073cb05f3f12e74be33f04ee/tweaks.json"
    
    var body: some View {
        Form {
            Section {
                Text("Advanced Settings")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                
                Text("Warning: Changing these settings can break community tweak functionality. Proceed with caution.")
                    .font(.caption)
                    .foregroundColor(.orange)
                    .padding(.bottom)
            }
            
            // MARK: - Community Repository Section
            Section("Community Repository") {
                TextField("Repository URL", text: $repoURL)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minWidth: 350)
                    .onChange(of: repoURL) { newValue in
                        validateURL(newValue)
                    }
                
                if let error = urlValidationError {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                HStack {
                    Button("Reset to Default") {
                        repoURL = defaultURL
                        urlValidationError = nil
                    }
                    .controlSize(.small)
                    
                    Button("Clear Cache") {
                        CommunityTweakSource.clearAllCaches()
                        ConsoleLogger.shared.log("Community tweak cache cleared")
                    }
                    .controlSize(.small)
                    
                    Spacer()
                }
                .padding(.top, 4)
            }
            
            // MARK: - Tweaks Management Section
            Section("Tweaks Management") {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Reset All Tweaks")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text("Reverts all currently active tweaks to their default state")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button("Reset All") {
                        showResetConfirmation = true
                    }
                    .disabled(isResetting)
                    .controlSize(.small)
                }
            }
            
            // MARK: - Logging Section
            Section("Logging") {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Export Console Logs")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text("Save all console logs to a text file")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button("Export Logs") {
                        exportLogs()
                    }
                    .controlSize(.small)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Clear Console")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text("Clear all messages from the console log")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button("Clear") {
                        ConsoleLogger.shared.clear()
                    }
                    .controlSize(.small)
                }
            }
            
            // MARK: - Close Button
            Section {
                Spacer()
                HStack {
                    Spacer()
                    Button("Close") {
                        NSApp.windows.first(where: { $0.identifier?.rawValue == "settings" })?.close()
                    }
                    .keyboardShortcut(.cancelAction)
                }
            }
        }
        .padding()
        .frame(width: 500, height: 450)
        .alert("Reset All Tweaks?", isPresented: $showResetConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Reset All", role: .destructive) {
                resetAllTweaks()
            }
        } message: {
            Text("This will revert all active tweaks to their default state. Some changes may require a logout or restart to take full effect.")
        }
    }
    
    private func validateURL(_ urlString: String) {
        let result = CommunityTweakSource.validateURL(urlString)
        urlValidationError = result.isValid ? nil : result.error
    }
    
    private func resetAllTweaks() {
        isResetting = true
        Task {
            await viewModel.resetAllTweaks()
            await MainActor.run {
                isResetting = false
                ConsoleLogger.shared.log("All tweaks have been reset")
            }
        }
    }
    
    private func exportLogs() {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.plainText]
        panel.nameFieldStringValue = "baremac_logs_\(Date().formatted(.iso8601.year().month().day())).txt"
        
        if panel.runModal() == .OK, let url = panel.url {
            do {
                try ConsoleLogger.shared.logs.write(to: url, atomically: true, encoding: .utf8)
                ConsoleLogger.shared.log("Logs exported to: \(url.lastPathComponent)")
            } catch {
                ConsoleLogger.shared.log("Failed to export logs: \(error.localizedDescription)")
            }
        }
    }
}

struct ConsoleView: View {
    @ObservedObject var logger = ConsoleLogger.shared
    
    var body: some View {

        VStack(alignment: .leading, spacing: 0) {
            Divider()
            
            HStack {
                Text("Console")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button("Clear") {
                    logger.clear()
                }
                .controlSize(.mini)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(nsColor: .windowBackgroundColor))
            
            ScrollViewReader { proxy in
                ScrollView {
                    Text(logger.logs)
                        .font(.system(.caption, design: .monospaced))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                        .id("logBottom")
                        .textSelection(.enabled) // Allow copying logs
                }
                .onChange(of: logger.logs) { _ in
                    withAnimation {
                        proxy.scrollTo("logBottom", anchor: .bottom)
                    }
                }
            }
            .background(Color(nsColor: .textBackgroundColor))
            .frame(height: 150) // Fixed height for the console pane
        }
    }

}
