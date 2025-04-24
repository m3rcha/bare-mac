# Baremac

Baremac is a minimal macOS tweak utility built with SwiftUI. It provides an easy-to-use interface for applying system tweaks instantly, without manual Terminal commands.

## 🚀 Features

- **Modern SwiftUI UI**: Polished splash screen, searchable sidebar, and card-style tweak rows.
- **Instant Apply/Revert**: Click a tweak to apply or revert it immediately—no extra buttons required.
- **Categorized Tweaks**: Organized into Finder, Dock, System, and Screenshot sections.
- **Smooth Animations**: Subtle transitions between screens and categories.
- **Data-Driven**: All tweak definitions live in `TweaksData.swift` for easy editing and extension.

## ✅ Usage

- On launch, review the splash screen information and click **Get Started**.
- Use the **Search** field in the sidebar to filter tweaks by name or description.
- Click on any tweak card to toggle it on or off; changes apply immediately.

## ✨ Available Tweak Categories

- **Finder**: Show hidden files, prevent .DS_Store on network volumes, show full path in title bar, enable QuickLook text selection.
- **Dock**: Auto-hide with no delay, disable Mission Control animation, enable 2D Dock, single-app mode.
- **System**: Disable window animations, suppress Gatekeeper warnings, disable auto-correct.
- **Screenshot**: Change format to JPG, set custom screenshot location.

## 🚧 Known Limitations

- Many tweaks come from older macOS versions and may not function correctly in v0.1.
- Some tweaks (Finder/Dock restarts) may require additional system permissions.
- Settings do not persist beyond the current session.

## 📄 License

This project is licensed under the [MIT License](LICENSE).

