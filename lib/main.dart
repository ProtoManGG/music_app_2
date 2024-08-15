import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'di.dart';
import 'features/music_app/presentation/bloc/playback_position_bloc.dart';
import 'features/music_app/presentation/views/audio_player_screen.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audioo',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
    androidStopForegroundOnPause: true,
  );
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<PlaybackPositionBloc>(
          create: (context) => getIt<PlaybackPositionBloc>(),
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
