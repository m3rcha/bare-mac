<p align="center">
  <img src="https://i.imgur.com/oLtk0Cx.png" width="160" alt="BareMac Logo"/>
</p>

<h1 align="center">BareMac</h1>
<p align="center">A minimal and modular macOS tweak utility built with SwiftUI. Fast. Focused. Terminal-inspired.</p>

---
# 🚧 Project Abandoned and Archived

BareMac was originally designed as a macOS tweak toolkit for those who like a minimalist approach. It would have run exclusively on zsh commands with a lightweight SwiftUI front-end. Its main aim was to provide power users and terminal enthusiasts with a simple, script-first interface for system customisation. Despite early progress and a working prototype, the strict zsh-only requirement limited the breadth of achievable features, and ongoing changes in macOS security and sandboxing made many shell-based tweaks unreliable and inconsistent.
It proved difficult to balance simplicity against functionality without compromising the original ethos. Consequently, development has been permanently discontinued. This repository is now archived in a read-only state, and no further modifications or updates will be accepted, preserving BareMac as a concise demonstration of zsh-driven minimalism.
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

> **Note:** Most tweaks are placeholders or visual mockups.  
> Core functionality will be expanded in future versions.

---

## 🧠 Technical Overview

- SwiftUI-first architecture with MVVM-style separation
- All toggle commands are handled using:
  
  ```swift
  Process().launchPath = "/bin/zsh"
  Process().arguments = ["-c", tweak.command]
  ```

- Reversible tweaks (with `revertCommand`) supported
- Toggle changes are instant and stateless (no persistent preferences yet)
- Built-in `.toastText` system provides lightweight visual feedback
- Sidebar state and selected category managed with `@State` and `@Binding`
- View files include:

```text
🔹 ContentView.swift      // Root logic, main layout and toggle logic
🔹 SidebarView.swift      // Search bar + category sidebar
🔹 TweakRow.swift         // Individual tweak toggle component
🔹 TweaksData.swift       // Tweak definitions, commands, categories
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

