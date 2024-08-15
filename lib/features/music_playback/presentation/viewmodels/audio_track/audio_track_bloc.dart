import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:music_app_2/core/usecases/usecase.dart';
import 'package:music_app_2/features/music_playback/domain/usecases/get_audio_track.dart';
import 'package:music_app_2/features/feature2/domain/use_cases/pause_audio.dart';
import 'package:music_app_2/features/feature2/domain/use_cases/play_audio.dart';
import 'package:music_app_2/features/feature2/domain/use_cases/seek_audio.dart';

part 'audio_track_bloc.freezed.dart';
part 'audio_track_event.dart';
part 'audio_track_state.dart';

class AudioTrackBloc extends Bloc<AudioTrackEvent, AudioTrackState> {
  final GetAudioTrack _getAudioTrack;
  final PlayAudio _playAudio;
  final PauseAudio _pauseAudio;
  final SeekAudio _seekAudio;

  AudioTrackBloc({
    required GetAudioTrack getAudioTrack,
    required PlayAudio playAudio,
    required PauseAudio pauseAudio,
    required SeekAudio seekAudio,
  })  : _getAudioTrack = getAudioTrack,
        _playAudio = playAudio,
        _pauseAudio = pauseAudio,
        _seekAudio = seekAudio,
        super(const AudioTrackState.initial()) {
    on<AudioTrackEvent>((event, emit) => emit(const AudioTrackState.loading()));
    on<GetAudio>(onGetAudio);
    on<Pause>(onPause);
    on<Play>(onPlay);
    on<Seek>(onSeek);
  }

  Future<void> onGetAudio(GetAudio event, Emitter<AudioTrackState> emit) async {
    final res = await _getAudioTrack(GetAudioTrackParams(id: event.id));
    res.fold(
      (l) => emit(AudioTrackState.failure(message: l.message)),
      (r) => emit(const AudioTrackState.success()),
    );
  }

  Future<void> onPause(Pause event, Emitter<AudioTrackState> emit) async {
    final res = await _pauseAudio(NoParams());
    res.fold(
      (l) => emit(AudioTrackState.failure(message: l.message)),
      (r) => emit(const AudioTrackState.success()),
    );
  }

  Future<void> onPlay(Play event, Emitter<AudioTrackState> emit) async {
    final res = await _playAudio(PlayAudioParams(url: event.url));
    res.fold(
      (l) => emit(AudioTrackState.failure(message: l.message)),
      (r) => emit(const AudioTrackState.success()),
    );
  }

  Future<void> onSeek(Seek event, Emitter<AudioTrackState> emit) async {
    final res =
        await _seekAudio(SeekAudioParams(duration: const Duration(seconds: 1)));
    res.fold(
      (l) => emit(AudioTrackState.failure(message: l.message)),
      (r) => emit(const AudioTrackState.success()),
    );
  }
}
