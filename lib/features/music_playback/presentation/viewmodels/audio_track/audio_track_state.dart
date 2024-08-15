part of 'audio_track_bloc.dart';

@freezed
class AudioTrackState with _$AudioTrackState {
  const factory AudioTrackState.initial() = _Initial;
  const factory AudioTrackState.loading() = _Loading;
  const factory AudioTrackState.failure({required String message}) = _Failure;
  const factory AudioTrackState.success() = _Success;
}
/**
 *   if (state is AudioPlayerInitial) {
            } else if (state is AudioPlayerReady) {
              return const Text('Ready to play');
            } else if (state is AudioPlayerPlaying) {
              return const Text('Playing');
            } else if (state is AudioPlayerPaused) {
              return const Text('Paused');
            } else {
              return const Text('Unknown state');
            }
 */