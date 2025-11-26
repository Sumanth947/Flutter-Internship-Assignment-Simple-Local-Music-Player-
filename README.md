Simple Local Music Player
A straightforward Flutter app to pick and play local MP3 files with essential playback features and clean UI.

Features
Select MP3 files from device storage with file picker (restricted to .mp3).

Displays:

Track title (extracted from filename).

Artist as "Unknown Artist" (no metadata extraction).

Basic playback controls:

Play, pause, and resume.

Seek bar with draggable slider.

Display current playback time and total duration.

Playback resets to start on track completion, ready to replay.

Smoothly switch and play different songs without app restart.

Error handling with user-friendly messages.

State management using Provider for clean separation of logic and UI.

Getting Started
Prerequisites
Flutter SDK installed (check Flutter installation guide)

Android/iOS device or emulator

Installation and Running
Clone the repository:

git clone <your-repo-url>
cd <repo-folder>
Get Flutter dependencies:

flutter pub get
Run the app on your device or emulator:

text
flutter run
Use the Pick MP3 button in the app to select and play music files.
