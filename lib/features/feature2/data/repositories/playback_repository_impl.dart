import 'package:music_app_2/features/feature2/domain/repositories/playback_repository.dart';

import '../data_sources/playback_local_data_source.dart';
import '../models/playback_state_model.dart';

class PlaybackRepositoryImpl implements PlaybackRepository {
  final PlaybackLocalDataSource localDataSource;

  PlaybackRepositoryImpl(this.localDataSource);

  // @override
  // Future<void> savePlaybackState(PlaybackStateModel state) async {
  //   await localDataSource.saveState(state);
  // }

  @override
  Future<PlaybackStateModel?> loadPlaybackState() async {
    return await localDataSource.loadState();
  }
}
