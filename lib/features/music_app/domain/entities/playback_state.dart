// ignore_for_file: public_member_api_docs, sort_constructors_first
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
