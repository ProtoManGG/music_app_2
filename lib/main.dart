import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
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
import 'package:music_app_2/features/music_app/presentation/views/audio_player_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            // Load the audio source with the MediaItem
            final AudioPlayer audioPlayer = AudioPlayer()
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
              );
            final PlaybackLocalDataSource dataSource =
                PlaybackLocalDataSourceImpl();
            final PlaybackRepository repo = PlaybackRepositoryImpl(
              audioPlayer: audioPlayer,
              localDataSource: dataSource,
            );
            return PlaybackPositionBloc(
              loadFromDb: LoadFromDb(repo),
              saveToDb: SaveToDb(repo),
              initIsolate: InitIsolate(repo),
              disposeIsolate: DisposeIsolate(repo),
              pauseAudio: PauseAudio(repo),
              playAudio: PlayAudio(repo),
              seekAudio: SeekAudio(repo),
              getDuration: GetDuration(repo),
              getPlayerStateStream: GetPlayerStateStream(repo),
              getPositionDataStream: GetPositionDataStream(repo),
              getSequenceStateStream: GetSequenceStateStream(repo),
            );
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AudioPlayerScreen(),
    );
  }
}
