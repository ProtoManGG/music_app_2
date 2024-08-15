import 'package:music_app_2/features/feature2/domain/entities/audio_track.dart';

class AudioTrackModel extends AudioTrack {
  const AudioTrackModel({
    required super.id,
    required super.title,
    required super.url,
  });

  factory AudioTrackModel.fromJson(Map<String, dynamic> json) {
    return AudioTrackModel(
      id: json['id'],
      title: json['title'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
    };
  }
}
