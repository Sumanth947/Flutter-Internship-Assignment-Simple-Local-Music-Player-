import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../models/audio_track.dart';

class TrackInfoWidget extends StatelessWidget {
  final AudioTrack track;

  const TrackInfoWidget({
    super.key,
    required this.track,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          track.title,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppConstants.spacingSM),
        Text(
          track.artist,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
