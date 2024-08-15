part of 'playback_position_bloc.dart';

@freezed
class AudioPlaybackEvent with _$AudioPlaybackEvent {
  const factory AudioPlaybackEvent.initIsolate() = _InitIsolate;
  const factory AudioPlaybackEvent.disposeIsolate() = _DisposeIsolate;
  const factory AudioPlaybackEvent.loadFromDb() = _LoadFromDb;
  const factory AudioPlaybackEvent.saveToDb({
    required String currentTrackId,
    required int currentPosition,
  }) = _SaveToDb;
  const factory AudioPlaybackEvent.pause() = _Pause;
  const factory AudioPlaybackEvent.play() = _Play;
  const factory AudioPlaybackEvent.seek({required Duration duration}) = _Seek;
}
