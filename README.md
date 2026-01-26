<p align="center">
  <img src="https://i.imgur.com/oLtk0Cx.png" width="160" alt="BareMac Logo"/>
</p>

<h1 align="center">BareMac</h1>
<p align="center">A minimal and modular macOS tweak utility built with SwiftUI. Fast. Focused. Helper-powered.</p>

## 🚀 BareMac v0.4 Alpha is here

BareMac v0.4 marks a major architectural step forward.

This release introduces **Parameterized Tweaks**, a new **In-App Console**, and
**Menu Bar integration**, while laying the groundwork for a fully
**community-driven tweak ecosystem**.

Community tweaks are not fully enabled yet, but the core engine, execution model,
and Advanced Settings infrastructure are now in place to support them safely
and independently from app updates.

---

## 🚀 What is BareMac?

**BareMac** is a lightweight macOS utility that allows users to toggle system-level tweaks instantly, through a modern graphical interface.  
It creates a bridge between complex terminal commands and a user-friendly dashboard.

 **v0.4** introduces dynamic configuration (sliders/inputs), real-time execution logs, and a menu bar status item for quick access.

---

## 🎯 Features

- **Parameterized Tweaks**: Configure tweaks dynamically (e.g., set Dock animation speed via slider).
- **In-App Console**: Real-time log viewer for tracking tweak execution and errors.
- **Live toggle system**: Changes apply instantly via a native helper.
- **State Persistence**: App reads system state on launch to show correct toggle status.
- **Search bar** with live filtering.
- **Graphite-inspired theme** and native macOS UI components.

### 🚧 Works in Progress (WIP)
- **Sandbox Mode**: A developer playground to test raw JSON tweaks safely.
- **Community Tweaks**: Capability to fetch and load tweaks from remote repositories.
- **Advanced Settings**: Tools to manage external sources.

> **Note:** Some tweaks may require additional permissions or be placeholders on newer macOS versions.

---

## 🧠 Architecture & Design (v0.4)

BareMac follows a strict MVVM architecture with a focus on modularity and safety.

- **Component-Based UI**: Reusable `TweakCard` elements with support for both simple toggles and complex parameter inputs.
- **Tweak Engine**: A robust `TweakRunner` handling `defaults` and `shell` operations.
- **Reactive Logging**: A centralized `ConsoleLogger` service publishing updates to the UI in real-time.

### Folder Structure
```
BareMac/
├── App/           # Entry point & Menu Bar Logic
├── Models/        # Data definitions (Tweak, Operation, Parameter)
├── Services/      # Business logic (Runner, Repository, Logger)
├── ViewModels/    # State management (AppViewModel)
├── Views/         # UI Components (Cards, Console) & Screens
└── Utilities/     # Helpers
```

---

## ⚙️ Requirements

- macOS **Ventura or newer**
- Xcode 14 or newer
- Swift 5.7+
- Full Disk Access (for some tweaks to apply properly)

---

## 📆 Installation

> **⚠️ Note:** This is an **Alpha Release (v0.4)**. Features marked as (WIP) may be incomplete.

To test this version:
1. Clone the repository
2. Open `BareMac.xcodeproj` in Xcode
3. Build and Run manually

---

## 📄 License

This project is licensed under the **MIT License**.  

---

## 💬 Contributing

Pull requests are welcome!  
See [the tweaks repo](https://github.com/m3rcha/baremac-tweaks) for a guide on adding new tweaks to the repository.

---

## 🖤 Stay Minimal. Stay in Control.
