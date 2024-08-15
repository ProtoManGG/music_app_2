import '../entities/playback_state.dart';

abstract interface class PlaybackRepository {
  // Future<void> savePlaybackState(PlaybackState state);
  Future<PlaybackState?> loadPlaybackState();
}
