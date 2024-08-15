import 'package:music_app_2/features/feature2/domain/repositories/playback_repository.dart';

import '../entities/playback_state.dart';

class LoadPlaybackState {
  final PlaybackRepository repository;
  LoadPlaybackState(this.repository);

  Future<PlaybackState?> call() async {
    return await repository.loadPlaybackState();
  }
}
