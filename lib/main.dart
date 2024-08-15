import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_app_2/features/feature2/data/data_sources/playback_local_data_source.dart';
import 'package:music_app_2/features/feature2/data/repositories/playback_repository_impl.dart';
import 'package:music_app_2/features/feature2/domain/repositories/playback_repository.dart';
import 'package:music_app_2/features/feature2/domain/use_cases/load_playback_state.dart';
import 'package:music_app_2/features/feature2/domain/use_cases/save_playback_state.dart';
import 'package:music_app_2/features/feature2/presentation/bloc/playback_position_bloc.dart';
import 'package:music_app_2/features/feature2/presentation/views/audio_player_screen.dart';
import 'package:music_app_2/features/feature2/presentation/views/audio_player_screen_2.dart';

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
            final dataSource = PlaybackLocalDataSource();
            final PlaybackRepository repo = PlaybackRepositoryImpl(dataSource);
            return PlaybackPositionBloc(
              loadPlaybackState: LoadPlaybackState(repo),
              savePlaybackState: SavePlaybackState(repo),
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
      // home: const MusicPlayerView(),
    );
  }
}
