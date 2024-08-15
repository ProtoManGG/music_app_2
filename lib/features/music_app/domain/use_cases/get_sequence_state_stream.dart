import 'package:just_audio/just_audio.dart';
import 'package:music_app_2/features/music_app/domain/repositories/playback_repository.dart';

class GetSequenceStateStream {
  final PlaybackRepository _playbackRepository;
  GetSequenceStateStream(this._playbackRepository);

  Stream<SequenceState?> call() {
    return _playbackRepository.sequenceStateStream;
  }
}
