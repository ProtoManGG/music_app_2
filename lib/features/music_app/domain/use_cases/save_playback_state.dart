import '../repositories/playback_repository.dart';

import '../entities/playback_state.dart';

class SavePlaybackState {
  final PlaybackRepository repository;

  SavePlaybackState(this.repository);

  Future<void> call(PlaybackStateEntity playbackState) async {
    // await repository.savePlaybackState(playbackState);
  }
}
