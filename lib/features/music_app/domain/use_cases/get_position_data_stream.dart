import '../entities/position_data.dart';
import '../repositories/playback_repository.dart';

class GetPositionDataStream {
  final PlaybackRepository _playbackRepository;
  GetPositionDataStream(this._playbackRepository);

  Stream<PositionData> call() {
    return _playbackRepository.positionDataStream;
  }
}
