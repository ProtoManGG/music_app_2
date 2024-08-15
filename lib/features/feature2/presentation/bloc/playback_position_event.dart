part of 'playback_position_bloc.dart';

@freezed
class PlaybackPositionEvent with _$PlaybackPositionEvent {
  const factory PlaybackPositionEvent.load() = _Load;
  const factory PlaybackPositionEvent.save({required PlaybackState pbState}) = _Save;
}