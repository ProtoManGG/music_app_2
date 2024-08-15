part of 'audio_track_bloc.dart';

@freezed
class AudioTrackEvent with _$AudioTrackEvent {
  const factory AudioTrackEvent.getAudio({required String id}) = GetAudio;
  const factory AudioTrackEvent.pause() = Pause;
  const factory AudioTrackEvent.play({required String url}) = Play;
  const factory AudioTrackEvent.seek({required Duration duration}) = Seek;
}
