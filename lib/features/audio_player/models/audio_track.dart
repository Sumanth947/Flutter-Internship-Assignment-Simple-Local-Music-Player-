class AudioTrack {
  final String filePath;
  final String title;
  final String artist;
  final int? albumId;  

  AudioTrack({
    required this.filePath,
    required this.title,
    required this.artist,
    this.albumId,       
  });
}
