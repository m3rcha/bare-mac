import SwiftUI

struct Tweak: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let command: String
    var isSelected: Bool = false
}

struct TweakCategory: Identifiable {
    let id = UUID()
    let name: String
    var tweaks: [Tweak]
}

struct ContentView: View {
    @State private var showIntro = true
    @State private var categories: [TweakCategory] = [
        TweakCategory(
            name: "Finder",
            tweaks: [
                Tweak(
                    name: "Show Hidden Files",
                    description: "Reveals hidden files in Finder (e.g., .DS_Store, .git)",
                    command: "defaults write com.apple.finder AppleShowAllFiles -bool true && launchctl kickstart -k gui/$(id -u)/com.apple.finder"
                ),
                Tweak(
                    name: "Prevent .DS_Store on Network Volumes",
                    description: "Avoids cluttering network drives with .DS_Store files",
                    command: "defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true"
                ),
                Tweak(
                    name: "Show Full Path in Title Bar",
                    description: "Displays full POSIX path in Finder title bar",
                    command: "defaults write com.apple.finder _FXShowPosixPathInTitle -bool true && killall Finder"
                ),
                Tweak(
                    name: "Enable QuickLook Text Selection",
                    description: "Allows selecting text in QuickLook previews",
                    command: "defaults write com.apple.finder QLEnableTextSelection -bool true && killall Finder"
                ),
            ]
        ),
        TweakCategory(
            name: "Dock",
            tweaks: [
                Tweak(
                    name: "Auto-hide Dock",
                    description: "Automatically hides the Dock with no delay",
                    command: "defaults write com.apple.dock autohide -bool true && defaults write com.apple.dock autohide-delay -float 0 && defaults write com.apple.dock autohide-time-modifier -float 0 && launchctl kickstart -k gui/$(id -u)/com.apple.dock"
                ),
                Tweak(
                    name: "Disable Mission Control Animation",
                    description: "Removes Mission Control transition animation",
                    command: "defaults write com.apple.dock expose-animation-duration -int 0 && killall Dock"
                ),
                Tweak(
                    name: "Enable 2D Dock",
                    description: "Sets Dock to 2D style (no glass)",
                    command: "defaults write com.apple.dock no-glass -bool true && killall Dock"
                ),
                Tweak(
                    name: "Single App Mode",
                    description: "Switches to single-app mode in Dock",
                    command: "defaults write com.apple.dock single-app -bool true && killall Dock"
                ),
            ]
        ),
        TweakCategory(
            name: "System",
            tweaks: [
                Tweak(
                    name: "Disable Animations",
                    description: "Speeds up macOS by disabling window animations",
                    command: "defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false"
                ),
                Tweak(
                    name: "Disable Gatekeeper Warnings",
                    description: "Suppresses 'App downloaded from the internet' dialogs",
                    command: "defaults write com.apple.LaunchServices LSQuarantine -bool false"
                ),
                Tweak(
                    name: "Disable Auto-Correct",
                    description: "Disables automatic spelling correction system-wide",
                    command: "defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false"
                ),
                Tweak(
                    name: "Disable Rubber-Band Scrolling",
                    description: "Turns off elastic scrolling effect",
                    command: "defaults write -g NSScrollViewRubberbanding -int 0 && killall Finder"
                ),
                Tweak(
                    name: "Disable Crash Reporter Dialog",
                    description: "Prevents crash report dialogs from appearing",
                    command: "defaults write com.apple.CrashReporter DialogType none"
                ),
                Tweak(
                    name: "Disable Dashboard",
                    description: "Turns off the Dashboard feature",
                    command: "defaults write com.apple.dock dashboard-enabled-state -int 0 && killall Dock"
                ),
                Tweak(
                    name: "Expand Print & Save Panels",
                    description: "Keeps print and save dialogs expanded by default",
                    command: "defaults write -g PMPrintingExpandedStateForPrint -bool true; defaults write -g NSNavPanelExpandedStateForSaveMode -bool true"
                ),
            ]
        ),
        TweakCategory(
            name: "Screenshot",
            tweaks: [
                Tweak(
                    name: "Set Screenshot Format to JPG",
                    description: "Changes screenshot format from PNG to JPG",
                    command: "defaults write com.apple.screencapture type -string jpg && killall SystemUIServer"
                ),
                Tweak(
                    name: "Change Screenshot Location",
                    description: "Sets default location for screenshots to ~/Screenshots",
                    command: "defaults write com.apple.screencapture location ~/Screenshots && killall SystemUIServer"
                ),
            ]
        )
    ]
    @State private var showConfirmation = false
    @State private var showRevertConfirmation = false
    @State private var showRevertedAlert = false
    @State private var showResetConfirmation = false
    @State private var showApplyAllConfirmation = false
    @State private var showAppliedAllAlert = false

    // Separate out intro and main views for clean animation
    var introView: some View {
        VStack(spacing: 20) {
            Image("BaremacLogo")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .frame(width: 120, height: 120)
                .padding(.bottom, 10)
            Button(action: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showIntro = false
                }
            }) {
                Text("Get Started")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(Color("AccentColor"))
            }
            Text("This app helps you apply minimal macOS tweaks safely and easily.")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)
        }
        .frame(minWidth: 450, idealWidth: 500, maxWidth: 550, minHeight: 480)
    }

    var mainTabView: some View {
        TabView {
            ForEach($categories) { $category in
                VStack(alignment: .leading) {
                    Text(category.name)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.accentColor)
                    Divider().padding(.bottom, 8)

                    ForEach($category.tweaks) { $tweak in
                        Toggle(isOn: $tweak.isSelected) {
                            VStack(alignment: .leading) {
                                Text(tweak.name).bold()
                                Text(tweak.description)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 4)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: tweak.isSelected)
                    }

                    Spacer()

                    Button("Apply Tweaks") {
                        applySelectedAll()
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)

                    Spacer()
                }
                .padding()
                .toolbar {
                    ToolbarItemGroup(placement: .primaryAction) {
                        Button("Deselect All") {
                            for index in category.tweaks.indices {
                                category.tweaks[index].isSelected = false
                            }
                        }
                    }
                }
                .alert("Tweaks Applied", isPresented: $showConfirmation) {
                    Button("OK", role: .cancel) { }
                }
                .alert("Are you sure?", isPresented: $showResetConfirmation) {
                    Button("Reset", role: .destructive) {
                        revertTweaks()
                    }
                    Button("Cancel", role: .cancel) {}
                }
                .tabItem { Text(category.name) }
            }
            VStack(spacing: 20) {
                Text("Apply All Tweaks")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .padding(.bottom, 8)
                Text("This will apply all available tweaks at once.")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                Button("Apply All Tweaks") {
                    showApplyAllConfirmation = true
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .tabItem {
                Text("Apply All")
            }
            .alert("Apply All Tweaks?", isPresented: $showApplyAllConfirmation) {
                Button("Apply", role: .destructive) {
                    applyAllTweaks()
                }
                Button("Cancel", role: .cancel) {}
            }
            .alert("Tweaks Applied", isPresented: $showAppliedAllAlert) {
                Button("OK", role: .cancel) {}
            }
            VStack(spacing: 20) {
                Text("Reset All Tweaks")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .padding(.bottom, 8)
                Text("This will undo all applied tweaks and restore defaults.")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                Button("Reset All Tweaks") {
                    showRevertConfirmation = true
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .tabItem {
                Text("Reset")
            }
            .alert("Are you sure?", isPresented: $showRevertConfirmation) {
                Button("Reset", role: .destructive) {
                    revertTweaks()
                }
                Button("Cancel", role: .cancel) {}
            }
            .alert("Tweaks Reset", isPresented: $showRevertedAlert) {
                Button("OK", role: .cancel) {}
            }
        }
        .accentColor(Color("AccentColor"))
        .frame(minWidth: 450, idealWidth: 500, maxWidth: 550, minHeight: 480)
    }

    var body: some View {
        ZStack {
            if showIntro {
                introView
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            } else {
                mainTabView
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showIntro)
    }

    func applyTweaks(in category: TweakCategory) {
        for tweak in category.tweaks where tweak.isSelected {
            let task = Process()
            task.standardOutput = FileHandle.nullDevice
            task.standardError = FileHandle.nullDevice
            task.launchPath = "/bin/zsh"
            task.arguments = ["-c", tweak.command]
            try? task.run()
        }
        showConfirmation = true
    }

    func revertTweaks() {
        let revertCommands = [
            "defaults write com.apple.finder AppleShowAllFiles -bool false && launchctl kickstart -k gui/$(id -u)/com.apple.finder",
            "defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool false",
            "defaults write com.apple.dock autohide -bool false && defaults write com.apple.dock autohide-delay -float 0.5 && defaults write com.apple.dock autohide-time-modifier -float 0.5 && launchctl kickstart -k gui/$(id -u)/com.apple.dock",
            "defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool true && killall Dock && killall Finder",
            "defaults write com.apple.LaunchServices LSQuarantine -bool true",
            "defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool true",
            "defaults write com.apple.screencapture type -string png && killall SystemUIServer",
            "defaults write com.apple.finder _FXShowPosixPathInTitle -bool false && killall Finder",
            "defaults write com.apple.finder QLEnableTextSelection -bool false && killall Finder",
            "defaults delete com.apple.dock expose-animation-duration && killall Dock",
            "defaults delete com.apple.dock no-glass && killall Dock",
            "defaults write com.apple.dock single-app -bool false && killall Dock",
            "defaults write -g NSScrollViewRubberbanding -int 1 && killall Finder",
            "defaults delete com.apple.CrashReporter DialogType",
            "defaults write com.apple.dock dashboard-enabled-state -int 1 && killall Dock",
            "defaults write -g PMPrintingExpandedStateForPrint -bool false; defaults write -g NSNavPanelExpandedStateForSaveMode -bool false",
            "defaults delete com.apple.screencapture location && killall SystemUIServer"
        ]
        for cmd in revertCommands {
            let task = Process()
            task.standardOutput = FileHandle.nullDevice
            task.standardError = FileHandle.nullDevice
            task.launchPath = "/bin/zsh"
            task.arguments = ["-c", cmd]
            try? task.run()
        }
        showRevertedAlert = true
    }
    
    func applyAllTweaks() {
        for category in categories {
            for tweak in category.tweaks {
                let task = Process()
                task.standardOutput = FileHandle.nullDevice
                task.standardError = FileHandle.nullDevice
                task.launchPath = "/bin/zsh"
                task.arguments = ["-c", tweak.command]
                try? task.run()
            }
        }
        showAppliedAllAlert = true
    }
    func applySelectedAll() {
        for category in categories {
            for tweak in category.tweaks where tweak.isSelected {
                let task = Process()
                task.standardOutput = FileHandle.nullDevice
                task.standardError = FileHandle.nullDevice
                task.launchPath = "/bin/zsh"
                task.arguments = ["-c", tweak.command]
                try? task.run()
            }
        }
        showConfirmation = true
    }
}
