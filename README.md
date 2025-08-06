<p align="center">
  <img src="https://i.imgur.com/oLtk0Cx.png" width="160" alt="BareMac Logo"/>
</p>

<h1 align="center">BareMac</h1>
<p align="center">A minimal and modular macOS tweak utility built with SwiftUI. Fast. Focused. Terminal-inspired.</p>

---
## 🚧 PROJECT ON HIATUS — BUT NOT DEAD

Hey folks! BareMac is taking a deliberate pit-stop.

- **Why?** I’m rebuilding the app from the ground up with a cleaner architecture and a larger, fully-tested tweak library.  
- **What stays?** All current code and commit history remain publicly visible for anyone who wants to poke around, fork, or learn from it.  
- **What’s frozen?** I’m disabling new issues and pull requests while the rewrite happens so I can focus. Existing discussions stay archived for reference.  
- **ETA?** No hard date yet. Once the MVP of the rewrite is stable I’ll unfreeze the repo, re-enable contributions, and publish a fresh roadmap.  
- **Want updates?** Hit “Watch → Custom → Releases” on GitHub to get notified the moment development restarts.  
- **Need something now?** Feel free to fork under the project’s current license. Just don’t rely on future merges until the hiatus lifts.  

Thanks for your patience and interest. BareMac *will* return—leaner, faster, and packed with rock-solid tweaks.
---

## 🚀 What is BareMac?

**BareMac** is a lightweight macOS utility that allows users to toggle system-level tweaks instantly, through a simple graphical interface.  
It aims to provide a clean, modern, and modular SwiftUI experience for power users who want more control over macOS behaviors — without touching Terminal.

This version (v0.2) focuses entirely on UI/UX polish, modularization, and performance-oriented view rendering.

---

## 🎯 Features

- Organized tweaks under sections
- **Live toggle system**: no apply button, commands run instantly via `zsh`
- **Search bar** with live filtering and terminal-style aesthetics
- Fully **modular SwiftUI file structure**
- **Graphite-inspired theme** (`#1f1f1e`) and monospaced typography
- Sample Finder, Dock, Safari, and screenshot tweaks using helper-backed actions

> **Note:** The included tweaks are limited but functional; more categories will be added over time.

---

## 🧠 Technical Overview

- SwiftUI-first architecture with MVVM-style separation
- Tweaks are applied through a helper that writes directly to `UserDefaults` and restarts affected processes when needed.

- Reversible tweaks supported via helper-backed state toggles
- Toggle changes are instant and stateless (no persistent preferences yet)
- Built-in `.toastText` system provides lightweight visual feedback
- Sidebar state and selected category managed with `@State` and `@Binding`
- View files include:

```text
🔹 ContentView.swift      // Root logic, main layout and toggle logic
🔹 SidebarView.swift      // Search bar + category sidebar
🔹 TweakRow.swift         // Individual tweak toggle component
🔹 TweaksData.swift       // Tweak definitions, categories, helper actions
🔹 IntroView.swift        // Launch screen with transition binding
```

---

## ⚙️ Requirements

- macOS **Ventura or newer**
- Xcode 14 or newer
- Swift 5.7+
- Full Disk Access (for some tweaks to apply properly)

---

## 🧪 Limitations (v0.2)

- No tweak persistence — all toggles reset on relaunch
- Some system commands may silently fail without permissions
- No error handling or logs (yet)
- Not notarized — Gatekeeper will warn on first launch
- Many tweaks are currently non-functional or deprecated on newer macOS

---

## 📆 Installation

- Download the `.dmg` file from the [Releases](https://github.com/m3rcha/bare-mac/releases) page
- Drag **BareMac.app** into your Applications folder
- Launch the app, and **grant Full Disk Access** via System Settings if required

---

## 📄 License

This project is licensed under the **MIT License**.  

---

## 💬 Contributing

Pull requests are welcome!  
You can submit new tweak ideas, better error handling, or UI suggestions — all are appreciated.

---

## 🖤 Stay Terminal. Stay Minimal.

