import SwiftUI

@main
struct BareMacApp: App {
    @StateObject private var viewModel = AppViewModel()
    @StateObject private var menuHelper = MenuBarWrapper()
    @Environment(\.openWindow) var openWindow
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(viewModel)
                .frame(minWidth: 900, minHeight: 600)
                .onAppear {
                    menuHelper.setup(viewModel: viewModel, openWindow: { id in
                        openWindow(id: id)
                    })
                    Task {
                        await viewModel.loadInitialData()
                    }
                }
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified)
        .commands {
            CommandMenu("Tools") {
                Button("Open Sandbox (WIP)") {
                    openWindow(id: "sandbox")
                }
                .keyboardShortcut("s", modifiers: [.command, .shift])
                
                Button("Advanced Settings (WIP)...") {
                    openWindow(id: "settings")
                }
                .keyboardShortcut(",", modifiers: [.command, .option])
                
                Divider()
                
                Toggle("Show Community Tweaks (WIP)", isOn: $viewModel.showCommunityTweaks)
                    .keyboardShortcut("t", modifiers: [.command, .shift])
            }
        }
        
        Window("Sandbox", id: "sandbox") {
            SandboxView()
                .frame(minWidth: 500, minHeight: 400)
        }
        
        Window("Advanced Settings", id: "settings") {
            AdvancedSettingsView()
        }
        .windowResizability(.contentSize)
    }
}

class MenuBarWrapper: ObservableObject {
    var manager: MenuBarManager?
    
    @MainActor
    func setup(viewModel: AppViewModel, openWindow: @escaping (String) -> Void) {
        if manager == nil {
            manager = MenuBarManager(viewModel: viewModel, openWindow: openWindow)
        }
    }
}

@MainActor
class MenuBarManager: NSObject {
    private var statusItem: NSStatusItem!
    private var viewModel: AppViewModel
    private var openWindow: (String) -> Void
    
    init(viewModel: AppViewModel, openWindow: @escaping (String) -> Void) {
        self.viewModel = viewModel
        self.openWindow = openWindow
        super.init()
        setupMenuBar()
    }
    
    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "slider.horizontal.3", accessibilityDescription: "BareMac")
        }
        
        updateMenu()
    }
    
    private func updateMenu() {
        let menu = NSMenu()
        
        let openAppItem = NSMenuItem(title: "Open BareMac", action: #selector(openApp), keyEquivalent: "o")
        openAppItem.target = self
        menu.addItem(openAppItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Community Tweaks Toggle
        let communityTitle = viewModel.showCommunityTweaks ? "Hide Community Tweaks (WIP)" : "Show Community Tweaks (WIP)"
        let communityItem = NSMenuItem(title: communityTitle, action: #selector(toggleCommunity), keyEquivalent: "")
        communityItem.target = self
        menu.addItem(communityItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let sandboxItem = NSMenuItem(title: "Open Sandbox (WIP)", action: #selector(openSandbox), keyEquivalent: "s")
        sandboxItem.target = self
        menu.addItem(sandboxItem)
        
        let settingsItem = NSMenuItem(title: "Advanced Settings (WIP)...", action: #selector(openSettings), keyEquivalent: ",")
        settingsItem.target = self
        menu.addItem(settingsItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusItem.menu = menu
    }
    
    @objc private func openApp() {
        NSApp.activate(ignoringOtherApps: true)
        // Ensure main window is visible
        if let window = NSApp.windows.first {
            window.makeKeyAndOrderFront(nil)
        }
    }
    
    @objc private func toggleCommunity() {
        // Toggle the state in ViewModel
        // Since we are not in a View, we need to be careful with MainActor updates if binding is involved
        // But viewModel is a class reference.
        Task { @MainActor in
            viewModel.showCommunityTweaks.toggle()
            // Update menu text
            updateMenu()
        }
    }
    
    @objc private func openSandbox() {
        Task { @MainActor in
            openWindow("sandbox")
        }
    }
    
    @objc private func openSettings() {
        Task { @MainActor in
            openWindow("settings")
        }
    }
    
    @objc private func quitApp() {
        NSApp.terminate(nil)
    }
}
