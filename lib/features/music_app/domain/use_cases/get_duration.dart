import 'package:music_app_2/features/music_app/domain/repositories/playback_repository.dart';

class GetDuration {
  final PlaybackRepository _playbackRepository;
  GetDuration(this._playbackRepository);

  Duration call() {
    return _playbackRepository.position;
  }
}
