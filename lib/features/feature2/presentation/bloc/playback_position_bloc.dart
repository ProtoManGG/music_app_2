import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:music_app_2/features/feature2/domain/use_cases/load_playback_state.dart';
import 'package:music_app_2/features/feature2/domain/use_cases/save_playback_state.dart';

part 'playback_position_event.dart';
part 'playback_position_state.dart';
part 'playback_position_bloc.freezed.dart';

class PlaybackPositionBloc
    extends Bloc<PlaybackPositionEvent, PlaybackPositionState> {
  final LoadPlaybackState _loadPlaybackState;
  final SavePlaybackState _savePlaybackState;

  PlaybackPositionBloc({
    required LoadPlaybackState loadPlaybackState,
    required SavePlaybackState savePlaybackState,
  })  : _loadPlaybackState = loadPlaybackState,
        _savePlaybackState = savePlaybackState,
        super(const _Initial()) {
    on<PlaybackPositionEvent>(
      (event, emit) {},
    );
    on<_Load>((event, emit) async {
      await _loadPlaybackState();
    });
    on<_Save>((event, emit) async {
      // await _savePlaybackState(event.pbState);
    });
  }
}
