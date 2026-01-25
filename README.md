<p align="center">
  <img src="https://i.imgur.com/oLtk0Cx.png" width="160" alt="BareMac Logo"/>
</p>

<h1 align="center">BareMac</h1>
<p align="center">A minimal and modular macOS tweak utility built with SwiftUI. Fast. Focused. Helper-powered.</p>

> [!NOTE] 
> **We are back!** After a ~5-month hiatus, BareMac is officially back in active development. Expect regular updates and fixes.

---

## 🚀 What is BareMac?

**BareMac** is a lightweight macOS utility that allows users to toggle system-level tweaks instantly, through a simple graphical interface.  
It aims to provide a clean, modern, and modular SwiftUI experience for power users who want more control over macOS behaviors — without touching Terminal.

This version (v0.3) focuses on UI/UX polish, modularization, and **state persistence**.

---

## 🎯 Features

- Organized tweaks under sections
- Expanded library of Finder, Dock, System, and Screenshot tweaks
- **Live toggle system**: changes apply instantly via a native helper
- **State Persistence**: App reads system state on launch to show correct toggle status
- Thread-safe actor-based helper powered by Swift concurrency
- **Search bar** with live filtering and terminal-style aesthetics
- Fully **modular SwiftUI file structure**
- **Graphite-inspired theme** (`#1f1f1e`) and monospaced typography

> **Note:** Some tweaks may require additional permissions or be placeholders on newer macOS versions.

---

## 🧠 Technical Overview

- SwiftUI-first architecture with MVVM-style separation
- Tweaks are executed through `TweakHelper`, an actor using native APIs instead of shell scripts.
- **Bi-directional sync**: Checks system defaults on launch to update UI state
- Reversible tweaks are supported through paired asynchronous apply/revert closures
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

## 🧪 Limitations (v0.3)

- Some system changes may require additional permissions
- No error handling or logs (yet)
- Not notarized — Gatekeeper will warn on first launch
- Some tweaks may be deprecated on newer macOS (Sonoma/Sequoia)

---

## 📆 Installation

> **⚠️ Note:** This is an intermediate release (v0.3) used for development. **No pre-built binaries (.dmg) are provided for this version.**
>
> **v0.4 is coming soon!** 🚀

To test this version:
- Clone the repository
- Open `BareMac.xcodeproj` in Xcode
- Build and Run manually

---

## 📄 License

This project is licensed under the **MIT License**.  

---

## 💬 Contributing

Pull requests are welcome!  
You can submit new tweak ideas, better error handling, or UI suggestions — all are appreciated.

---

## 🖤 Stay Minimal. Stay in Control.

