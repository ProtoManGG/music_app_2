import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:music_app_2/core/usecases/usecase.dart';
import 'package:music_app_2/features/feature2/domain/entities/playback_state.dart';
import 'package:music_app_2/features/feature2/domain/use_cases/dispose_isolate.dart';
import 'package:music_app_2/features/feature2/domain/use_cases/init_isolate.dart';
import 'package:music_app_2/features/feature2/domain/use_cases/load_from_db.dart';
import 'package:music_app_2/features/feature2/domain/use_cases/save_to_db.dart';

part 'playback_position_bloc.freezed.dart';
part 'playback_position_event.dart';
part 'playback_position_state.dart';

class PlaybackPositionBloc
    extends Bloc<AudioPlaybackEvent, PlaybackPositionState> {
  final LoadFromDb _loadFromDb;
  final SaveToDb _saveToDb;
  final InitIsolate _initIsolate;
  final DisposeIsolate _disposeIsolate;

  PlaybackPositionBloc({
    required LoadFromDb loadFromDb,
    required SaveToDb saveToDb,
    required InitIsolate initIsolate,
    required DisposeIsolate disposeIsolate,
  })  : _loadFromDb = loadFromDb,
        _saveToDb = saveToDb,
        _initIsolate = initIsolate,
        _disposeIsolate = disposeIsolate,
        super(const _Initial()) {
    on<AudioPlaybackEvent>(
        (_, emit) => emit(const PlaybackPositionState.loading()));
    on<_LoadFromDb>(_onLoadFromDb);
    on<_SaveToDb>(_onSaveToDb);
    on<_InitIsolate>(_onInitIsolate);
    on<_DisposeIsolate>(_onDisposeIsolate);
    // on<_Load>((event, emit) async {
    //   await _loadPlaybackState();
    // });
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
}
