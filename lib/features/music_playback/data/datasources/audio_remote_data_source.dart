import '../models/audio_track_model.dart';

abstract class AudioRemoteDataSource {
  Future<AudioTrackModel> getAudioTrack(String id);
}

class AudioRemoteDataSourceImpl implements AudioRemoteDataSource {
  //TODO: In a real app, you'd inject an HTTP client here
  AudioRemoteDataSourceImpl();

  @override
  Future<AudioTrackModel> getAudioTrack(String id) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return AudioTrackModel(
      id: id,
      title: 'Sample Track',
      url: 'https://example.com/sample.m3u8',
    );
  }
}
