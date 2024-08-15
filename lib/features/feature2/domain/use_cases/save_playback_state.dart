import 'package:music_app_2/features/feature2/domain/repositories/playback_repository.dart';

import '../entities/playback_state.dart';

class SavePlaybackState {
  final PlaybackRepository repository;

  SavePlaybackState(this.repository);

  Future<void> call(PlaybackState playbackState) async {
    // await repository.savePlaybackState(playbackState);
  }
}
