class PlaybackStateEntity {
  final String currentTrackId;
  final int currentPosition;

  PlaybackStateEntity({
    required this.currentTrackId,
    required this.currentPosition,
  });

  @override
  String toString() =>
      'PlaybackStateEntity(currentTrackId: $currentTrackId, currentPosition: $currentPosition)';
}
