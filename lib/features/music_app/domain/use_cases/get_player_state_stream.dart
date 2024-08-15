import 'package:just_audio/just_audio.dart';
import '../repositories/playback_repository.dart';

class GetPlayerStateStream {
  final PlaybackRepository _playbackRepository;
  GetPlayerStateStream(this._playbackRepository);

  Stream<PlayerState> call() {
    return _playbackRepository.playerStateStream;
  }
}
