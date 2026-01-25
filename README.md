<p align="center">
  <img src="https://i.imgur.com/oLtk0Cx.png" width="160" alt="BareMac Logo"/>
</p>

<h1 align="center">BareMac</h1>
<p align="center">A minimal and modular macOS tweak utility built with SwiftUI. Fast. Focused. Helper-powered.</p>

> [!NOTE] 
> **BareMac v0.3 is here!** Major Redesign, **macOS Sequoia** support, and Window Management tools.

---

## 🚀 What is BareMac?

**BareMac** is a lightweight macOS utility that allows users to toggle system-level tweaks instantly, through a modern graphical interface.  
It creates a bridge between complex terminal commands and a user-friendly dashboard.

 **v0.3** introduces strict MVVM architecture, proper state management, **macOS Sequoia compatibility**, and a dedicated **Window Management** suite.


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

## 🧠 Architecture & Design (v0.3)

**Why this new UI?**
The v0.3 redesign moves away from the "terminal-like" aesthetic to a modern, "native-plus" feel. The goal was to reduce visual clutter and make the app feel like a premium tool.

- **MVVM Architecture**: Strict separation between Logic (`TweakRunner`), Data (`TweakRepository`), and View (`HomeView`).
- **Component-Based**: Every UI element is a reusable component (`TweakCard`, `SearchBar`).
- **State Persistence**: The app treats the System as the Source of Truth. It reads values on launch and stays in sync.
- **Performance**: Asynchronous checks ensure the UI never blocks the main thread.

### Folder Structure
```
BareMac/
├── App/           # Entry point & Assets
├── Models/        # Data definitions
├── Services/      # Business logic (Runner, Repository)
├── ViewModels/    # State management
├── Views/         # UI Components & Screens
└── Utilities/     # Helpers
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

