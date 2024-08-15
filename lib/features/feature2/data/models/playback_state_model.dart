import '../../domain/entities/playback_state.dart';

class PlaybackStateModel extends PlaybackStateEntity {
  PlaybackStateModel({
    required super.currentTrackId,
    required super.currentPosition,
  });

  Map<String, dynamic> toJson() => {
        'currentTrackId': currentTrackId,
        'currentPosition': currentPosition,
      };

  static PlaybackStateModel fromJson(Map<String, dynamic> json) {
    return PlaybackStateModel(
      currentTrackId: json['currentTrackId'],
      currentPosition: json['currentPosition'],
    );
  }
}
