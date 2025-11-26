import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../providers/audio_player_provider.dart';
import '../widgets/album_art_widget.dart';
import '../widgets/track_info_widget.dart';
import '../widgets/seek_bar_widget.dart';
import '../widgets/play_pause_button.dart';

/// Main screen with home state and player state
class MusicPlayerScreen extends StatelessWidget {
  const MusicPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appTitle),
      ),
      body: Consumer<AudioPlayerProvider>(
        builder: (context, provider, _) {
          // Home screen: no track loaded
          if (!provider.hasTrack) {
            return _buildHomeScreen(context, provider);
          }

          // Player screen: track loaded
          return _buildPlayerScreen(context, provider);
        },
      ),
    );
  }

  /// Home screen with "Pick MP3" button
  Widget _buildHomeScreen(BuildContext context, AudioPlayerProvider provider) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingLG),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            
            // Music icon
            Icon(
              Icons.music_note_rounded,
              size: 100,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
            
            const SizedBox(height: AppConstants.spacingXL),
            
            // App title
            Text(
              AppConstants.appTitle,
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppConstants.spacingMD),
            
            // Instruction text
            Text(
              AppConstants.tapToSelect,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            
            const Spacer(),
            
            // Pick MP3 button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: provider.isLoading ? null : provider.pickMP3File,
                icon: provider.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.library_music_rounded),
                label: Text(
                  provider.isLoading ? 'Loading...' : AppConstants.pickMP3,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.spacingMD,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                  ),
                ),
              ),
            ),
            
            // Error message
            if (provider.errorMessage != null) ...[
              const SizedBox(height: AppConstants.spacingMD),
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingMD),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: AppConstants.spacingMD),
                    Expanded(
                      child: Text(
                        provider.errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: provider.clearError,
                      icon: const Icon(Icons.close),
                      iconSize: 20,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: AppConstants.spacingXXL),
          ],
        ),
      ),
    );
  }

  /// Player screen with album art, track info, controls
  Widget _buildPlayerScreen(BuildContext context, AudioPlayerProvider provider) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingLG),
        child: Column(
          children: [
            const Spacer(flex: 1),
            
            // Album art widget (reusable)
            const AlbumArtWidget(),
            
            const SizedBox(height: AppConstants.spacingXXL),
            
            // Track info widget (reusable)
            TrackInfoWidget(track: provider.currentTrack!),
            
            const SizedBox(height: AppConstants.spacingXL),
            
            // Seek bar widget (reusable)
            SeekBarWidget(
              currentPosition: provider.currentPosition,
              totalDuration: provider.totalDuration,
              onSeek: provider.seek,
            ),
            
            const SizedBox(height: AppConstants.spacingXL),
            
            // Play/Pause button widget (reusable)
            PlayPauseButton(
              isPlaying: provider.isPlaying,
              onPressed: provider.togglePlayPause,
            ),
            
            const SizedBox(height: AppConstants.spacingXL),
            
            // Option to select different MP3 file
            OutlinedButton.icon(
              onPressed: provider.pickMP3File,
              icon: const Icon(Icons.library_music_rounded),
              label: const Text('Select Different MP3'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingLG,
                  vertical: AppConstants.spacingMD,
                ),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
            
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
