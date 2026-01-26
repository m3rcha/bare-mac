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
    
    var body: some View {
        VSplitView {
            VStack(alignment: .leading) {
                Text("Tweak Definition (JSON)")
                    .font(.headline)
                    .padding(.leading)
                
                TextEditor(text: $jsonInput)
                    .font(.monospaced(.body)())
                    .padding()
                    .background(Color(nsColor: .textBackgroundColor))
                    .cornerRadius(8)
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
                }
                .background(Color(nsColor: .textBackgroundColor))
                .cornerRadius(8)
            }
            .frame(minHeight: 100)
        }
        .padding()
        .toolbar {
            ToolbarItem {
                Button(action: { runTweak(revert: false) }) {
                    Label("Apply", systemImage: "play.fill")
                }
                .disabled(isApplying)
            }
            ToolbarItem {
                Button(action: { runTweak(revert: true) }) {
                    Label("Revert", systemImage: "arrow.counterclockwise")
                }
                .disabled(isApplying)
            }
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
            } catch {
                log("JSON Decode Error: \(error)")
            }
            isApplying = false
        }
    }
    
    private func log(_ message: String) {
        logs += "[\(Date().formatted(date: .omitted, time: .standard))] \(message)\n"
    }
}

struct AdvancedSettingsView: View {
    @AppStorage("communityRepoURL") private var repoURL: String = "https://raw.githubusercontent.com/m3rcha/baremac-tweaks/3ade8c2086e18cad073cb05f3f12e74be33f04ee/tweaks.json"
    @AppStorage("showCommunityTweaks") private var showCommunity: Bool = false
    
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
            
            Section("Community Repository") {
                TextField("Repository URL", text: $repoURL)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minWidth: 350)
                
                HStack {
                    Button("Reset to Default") {
                        repoURL = defaultURL
                    }
                    .controlSize(.small)
                    
                    Spacer()
                }
                .padding(.top, 4)
            }
            
            Section {
                Spacer()
                HStack {
                    Spacer()
                    Button("Close") {
                        // Close window helper not available directly for specific window in SwiftUI 3/4 easily without dismiss, 
                        // but this button implies closing the window via standard UI. 
                        // We can just rely on the window close button, or this button can be removed if not needed.
                        // For now keeping it simple.
                        NSApp.windows.first(where: { $0.identifier?.rawValue == "settings" })?.close()
                    }
                    .keyboardShortcut(.cancelAction)
                }
            }
        }
        .padding()
        .frame(width: 500)
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
