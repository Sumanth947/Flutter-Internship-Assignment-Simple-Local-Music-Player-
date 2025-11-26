import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';

import '../../../core/constants/app_constants.dart';
import '../models/audio_track.dart';

/// Audio player logic separated from UI (Nice-to-have requirement)
class AudioPlayerProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // State
  AudioTrack? _currentTrack;
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  String? _errorMessage;

  // Getters
  AudioTrack? get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  String? get errorMessage => _errorMessage;
  bool get hasTrack => _currentTrack != null;

  AudioPlayerProvider() {
    _initializePlayer();
  }

  void _initializePlayer() {
    // Player state changes
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      notifyListeners();
    });

    // Position updates (seek bar updates while playing)
    _audioPlayer.onPositionChanged.listen((position) {
      _currentPosition = position;
      notifyListeners();
    });

    // Duration updates
    _audioPlayer.onDurationChanged.listen((duration) {
      _totalDuration = duration;
      notifyListeners();
    });

    // Track completion: reset player and reload source for replay
    _audioPlayer.onPlayerComplete.listen((_) async {
      _isPlaying = false;
      _currentPosition = Duration.zero;

      await _audioPlayer.stop(); // Reset the player fully

      if (_currentTrack != null) {
        await _audioPlayer.setSourceDeviceFile(_currentTrack!.filePath);
      }

      notifyListeners();
    });
  }

  /// Pick MP3 file with file picker (restrict to MP3 files only)
  Future<void> pickMP3File() async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3'], // Restrict to MP3 only
      );

      if (result == null || result.files.single.path == null) {
        // User cancelled
        _errorMessage = AppConstants.noFileSelected;
        _isLoading = false;
        notifyListeners();
        return;
      }

      final filePath = result.files.single.path!;
      await _loadTrack(filePath);
    } catch (e) {
      _errorMessage = AppConstants.errorPlayingFile;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadTrack(String filePath) async {
    try {
      // Stop current playback
      await _audioPlayer.stop();

      // Use filename as title, no metadata extraction
      final title = _extractFileName(filePath);

      _currentTrack = AudioTrack(
        filePath: filePath,
        title: title,
        artist: AppConstants.unknownArtist,
      );

      // Load audio file
      await _audioPlayer.setSourceDeviceFile(filePath);

      _errorMessage = null;
      _currentPosition = Duration.zero;

      notifyListeners();
    } catch (e) {
      // Error handling: show message, go back to safe state
      _errorMessage = AppConstants.errorPlayingFile;
      _currentTrack = null;
      notifyListeners();
    }
  }

  String _extractFileName(String path) {
    return path.split('/').last.replaceAll('.mp3', '').replaceAll('_', ' ');
  }

  /// Play/Pause toggle
  /// Play starts from beginning or from last paused position
  /// Pause keeps current position
  Future<void> togglePlayPause() async {
    if (_currentTrack == null) return;

    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        // Reset source before resuming to ensure player is ready
        await _audioPlayer.setSourceDeviceFile(_currentTrack!.filePath);
        await _audioPlayer.resume();
      }
    } catch (e) {
      _errorMessage = AppConstants.errorPlayingFile;
      notifyListeners();
    }
  }

  /// Seek to position (user drags slider)
  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      _errorMessage = AppConstants.errorPlayingFile;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
