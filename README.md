# Simple Local Music Player

A minimal Flutter application that allows users to pick and play local MP3 files with essential playback controls and a clean UI.

---

## Features

- Select MP3 files from device storage using a file picker (restricted to `.mp3`).
- Displays:
  - Track title (extracted from the file name)
  - Artist as "Unknown Artist" (metadata is not extracted)
- Basic playback controls:
  - Play, pause, and resume
  - Seek bar with a draggable slider
  - Current playback time and total duration
- Playback resets to the start when a track finishes.
- Smooth switching between songs without restarting the app.
- Error handling with simple, user-friendly messages.
- State management implemented using Provider for clean separation of logic and UI.

---

## Getting Started

### Prerequisites

- Flutter SDK installed
- Android/iOS device or emulator

---

## Installation and Running

git clone <your-repo-url> ,
cd <repo-folder> ,
flutter pub get ,
flutter run
