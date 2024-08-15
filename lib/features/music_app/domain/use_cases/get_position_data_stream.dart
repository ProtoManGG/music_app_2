import 'package:music_app_2/features/music_app/domain/entities/position_data.dart';
import 'package:music_app_2/features/music_app/domain/repositories/playback_repository.dart';

class GetPositionDataStream {
  final PlaybackRepository _playbackRepository;
  GetPositionDataStream(this._playbackRepository);

  Stream<PositionData> call() {
    return _playbackRepository.positionDataStream;
  }
}
