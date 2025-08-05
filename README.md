<p align="center">
  <img src="https://i.imgur.com/oLtk0Cx.png" width="160" alt="BareMac Logo"/>
</p>

<h1 align="center">BareMac</h1>
<p align="center">A minimal and modular macOS tweak utility built with SwiftUI. Fast. Focused. Helper-powered.</p>

---

## 🚀 What is BareMac?

**BareMac** is a lightweight macOS utility that allows users to toggle system-level tweaks instantly, through a simple graphical interface.  
It aims to provide a clean, modern, and modular SwiftUI experience for power users who want more control over macOS behaviors — without touching Terminal.

This version (v0.2) focuses entirely on UI/UX polish, modularization, and performance-oriented view rendering.

---

## 🎯 Features

- Organized tweaks under sections
- Expanded library of Finder, Dock, System, and Screenshot tweaks
- **Live toggle system**: no apply button, changes apply instantly via a native helper
- Thread-safe actor-based helper powered by Swift concurrency
- **Search bar** with live filtering and terminal-style aesthetics
- Fully **modular SwiftUI file structure**
- **Graphite-inspired theme** (`#1f1f1e`) and monospaced typography

> **Note:** Some tweaks may require additional permissions or be placeholders on newer macOS versions.

---

## 🧠 Technical Overview

- SwiftUI-first architecture with MVVM-style separation
- Tweaks are executed through `TweakHelper`, an actor using native APIs instead of shell scripts.
- Reversible tweaks are supported through paired asynchronous apply/revert closures
- Toggle changes are run asynchronously and remain stateless (no persistent preferences yet)
- Built-in `.toastText` system provides lightweight visual feedback
- Sidebar state and selected category managed with `@State` and `@Binding`
- View files include:

```text
🔹 ContentView.swift      // Root logic, main layout and toggle logic
🔹 SidebarView.swift      // Search bar + category sidebar
🔹 TweakRow.swift         // Individual tweak toggle component
🔹 TweaksData.swift       // Tweak definitions and categories
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
- Some system changes may require additional permissions
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

## 🖤 Stay Minimal. Stay in Control.

