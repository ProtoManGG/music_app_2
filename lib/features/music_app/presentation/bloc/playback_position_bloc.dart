import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app_2/core/usecases/usecase.dart';
import 'package:music_app_2/features/music_app/domain/entities/playback_state.dart';
import 'package:music_app_2/features/music_app/domain/entities/position_data.dart';
import 'package:music_app_2/features/music_app/domain/use_cases/dispose_isolate.dart';
import 'package:music_app_2/features/music_app/domain/use_cases/get_duration.dart';
import 'package:music_app_2/features/music_app/domain/use_cases/get_player_state_stream.dart';
import 'package:music_app_2/features/music_app/domain/use_cases/get_position_data_stream.dart';
import 'package:music_app_2/features/music_app/domain/use_cases/get_sequence_state_stream.dart';
import 'package:music_app_2/features/music_app/domain/use_cases/init_isolate.dart';
import 'package:music_app_2/features/music_app/domain/use_cases/load_from_db.dart';
import 'package:music_app_2/features/music_app/domain/use_cases/pause_audio.dart';
import 'package:music_app_2/features/music_app/domain/use_cases/play_audio.dart';
import 'package:music_app_2/features/music_app/domain/use_cases/save_to_db.dart';
import 'package:music_app_2/features/music_app/domain/use_cases/seek_audio.dart';

part 'playback_position_bloc.freezed.dart';
part 'playback_position_event.dart';
part 'playback_position_state.dart';

class PlaybackPositionBloc
    extends Bloc<AudioPlaybackEvent, PlaybackPositionState> {
  final LoadFromDb _loadFromDb;
  final SaveToDb _saveToDb;
  final InitIsolate _initIsolate;
  final DisposeIsolate _disposeIsolate;
  final PauseAudio _pauseAudio;
  final PlayAudio _playAudio;
  final SeekAudio _seekAudio;
  final GetDuration _getDuration;
  final GetPlayerStateStream _getPlayerStateStream;
  final GetPositionDataStream _getPositionDataStream;
  final GetSequenceStateStream _getSequenceStateStream;

  PlaybackPositionBloc({
    required LoadFromDb loadFromDb,
    required SaveToDb saveToDb,
    required InitIsolate initIsolate,
    required DisposeIsolate disposeIsolate,
    required PauseAudio pauseAudio,
    required PlayAudio playAudio,
    required SeekAudio seekAudio,
    required GetDuration getDuration,
    required GetPlayerStateStream getPlayerStateStream,
    required GetPositionDataStream getPositionDataStream,
    required GetSequenceStateStream getSequenceStateStream,
  })  : _loadFromDb = loadFromDb,
        _saveToDb = saveToDb,
        _initIsolate = initIsolate,
        _disposeIsolate = disposeIsolate,
        _pauseAudio = pauseAudio,
        _playAudio = playAudio,
        _seekAudio = seekAudio,
        _getDuration = getDuration,
        _getPlayerStateStream = getPlayerStateStream,
        _getPositionDataStream = getPositionDataStream,
        _getSequenceStateStream = getSequenceStateStream,
        super(const _Initial()) {
    on<AudioPlaybackEvent>(
        (_, emit) => emit(const PlaybackPositionState.loading()));
    on<_LoadFromDb>(_onLoadFromDb);
    on<_SaveToDb>(_onSaveToDb);
    on<_InitIsolate>(_onInitIsolate);
    on<_DisposeIsolate>(_onDisposeIsolate);
    on<_Pause>(_onPause);
    on<_Play>(_onPlay);
    on<_Seek>(_onSeek);
  }

  Future<void> _onSaveToDb(
    _SaveToDb event,
    Emitter<PlaybackPositionState> emit,
  ) async {
    final result = await _saveToDb(
      SaveToDbParams(
        currentTrackId: event.currentTrackId,
        currentPosition: event.currentPosition,
      ),
    );
    result.fold(
      (l) => emit(PlaybackPositionState.error(message: l.message)),
      (r) {},
    );
  }

  Future<void> _onLoadFromDb(
    _LoadFromDb event,
    Emitter<PlaybackPositionState> emit,
  ) async {
    final result = await _loadFromDb(NoParams());
    result.fold(
      (l) => emit(
        PlaybackPositionState.loaded(
          playbackStateEntity: PlaybackStateEntity(
            currentTrackId: '0',
            currentPosition: 0,
          ),
        ),
      ),
      (r) => emit(PlaybackPositionState.loaded(playbackStateEntity: r)),
    );
  }

  Future<void> _onInitIsolate(
    _InitIsolate event,
    Emitter<PlaybackPositionState> emit,
  ) async {
    final result = await _initIsolate(NoParams());
    result.fold(
      (l) => emit(PlaybackPositionState.error(message: l.message)),
      (r) => add(const AudioPlaybackEvent.loadFromDb()),
    );
  }

  Future<void> _onDisposeIsolate(
    event,
    Emitter<PlaybackPositionState> emit,
  ) async {
    final result = await _disposeIsolate(NoParams());
    result.fold(
      (l) => emit(PlaybackPositionState.error(message: l.message)),
      (r) {},
    );
  }

  Future<void> _onPause(
    _Pause event,
    Emitter<PlaybackPositionState> emit,
  ) async {
    final result = await _pauseAudio(NoParams());
    result.fold(
      (l) => emit(PlaybackPositionState.error(message: l.message)),
      (r) {},
    );
  }

  Future<void> _onPlay(
    _Play event,
    Emitter<PlaybackPositionState> emit,
  ) async {
    final result = await _playAudio(NoParams());
    result.fold(
      (l) => emit(PlaybackPositionState.error(message: l.message)),
      (r) {},
    );
  }

  Future<void> _onSeek(
    _Seek event,
    Emitter<PlaybackPositionState> emit,
  ) async {
    final result = await _seekAudio(SeekAudioParams(duration: event.duration));
    result.fold(
      (l) => emit(PlaybackPositionState.error(message: l.message)),
      // (r) => null,
      (r) => emit(PlaybackPositionState.seeked(playbackStateEntity: r)),
    );
  }

  Stream<PlayerState> get playerStateStream => _getPlayerStateStream();

  Duration get position => _getDuration();

  Stream<PositionData> get positionDataStream => _getPositionDataStream();

  Stream<SequenceState?> get sequenceStateStream => _getSequenceStateStream();
}
