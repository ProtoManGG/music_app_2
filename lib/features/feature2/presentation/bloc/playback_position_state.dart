part of 'playback_position_bloc.dart';

@freezed
class PlaybackPositionState with _$PlaybackPositionState {
  const factory PlaybackPositionState.initial() = _Initial;
  const factory PlaybackPositionState.loading() = _Loading;
  const factory PlaybackPositionState.loaded({
    required PlaybackStateEntity playbackStateEntity,
    // required Stream<PlayerState> playerStateStream,
  }) = _Loaded;
  const factory PlaybackPositionState.error({required String message}) = _Error;
}
