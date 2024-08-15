import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app_2/features/music_app/data/data_sources/playback_local_data_source.dart';
import 'package:music_app_2/features/music_app/data/repositories/playback_repository_impl.dart';
import 'package:music_app_2/features/music_app/domain/repositories/playback_repository.dart';
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
import 'package:music_app_2/features/music_app/presentation/bloc/playback_position_bloc.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<AudioPlayer>(AudioPlayer()
    ..setAudioSource(
      AudioSource.uri(
        Uri.parse(
            'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8'),
        tag: MediaItem(
          id: '0',
          title: 'NASA\'s view on Space',
          artist: 'NASA COM',
          artUri: Uri.parse(
            'https://images.unsplash.com/photo-1723375386110-729a0612ab99',
          ),
        ),
      ),
    ));

  getIt.registerLazySingleton<PlaybackLocalDataSource>(
      () => PlaybackLocalDataSourceImpl());

  getIt.registerLazySingleton<PlaybackRepository>(
    () => PlaybackRepositoryImpl(
      audioPlayer: getIt<AudioPlayer>(),
      localDataSource: getIt<PlaybackLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<LoadFromDb>(() => LoadFromDb(getIt()));
  getIt.registerLazySingleton<SaveToDb>(() => SaveToDb(getIt()));
  getIt.registerLazySingleton<InitIsolate>(() => InitIsolate(getIt()));
  getIt.registerLazySingleton<DisposeIsolate>(() => DisposeIsolate(getIt()));
  getIt.registerLazySingleton<PauseAudio>(() => PauseAudio(getIt()));
  getIt.registerLazySingleton<PlayAudio>(() => PlayAudio(getIt()));
  getIt.registerLazySingleton<SeekAudio>(() => SeekAudio(getIt()));
  getIt.registerLazySingleton<GetDuration>(() => GetDuration(getIt()));
  getIt.registerLazySingleton<GetPlayerStateStream>(
      () => GetPlayerStateStream(getIt()));
  getIt.registerLazySingleton<GetPositionDataStream>(
      () => GetPositionDataStream(getIt()));
  getIt.registerLazySingleton<GetSequenceStateStream>(
      () => GetSequenceStateStream(getIt()));

  getIt.registerLazySingleton<PlaybackPositionBloc>(
    () => PlaybackPositionBloc(
      loadFromDb: getIt(),
      saveToDb: getIt(),
      initIsolate: getIt(),
      disposeIsolate: getIt(),
      pauseAudio: getIt(),
      playAudio: getIt(),
      seekAudio: getIt(),
      getDuration: getIt(),
      getPlayerStateStream: getIt(),
      getPositionDataStream: getIt(),
      getSequenceStateStream: getIt(),
    ),
  );
}
