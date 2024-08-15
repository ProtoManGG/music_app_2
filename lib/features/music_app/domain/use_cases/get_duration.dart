import '../repositories/playback_repository.dart';

class GetDuration {
  final PlaybackRepository _playbackRepository;
  GetDuration(this._playbackRepository);

  Duration call() {
    return _playbackRepository.position;
  }
}
