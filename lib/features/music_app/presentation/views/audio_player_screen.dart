import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/playback_position_bloc.dart';
import '../widgets/audio_player_ui.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context
        .read<PlaybackPositionBloc>()
        .add(const AudioPlaybackEvent.initIsolate());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    context
        .read<PlaybackPositionBloc>()
        .add(const AudioPlaybackEvent.disposeIsolate());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        context.read<PlaybackPositionBloc>().add(
              AudioPlaybackEvent.saveToDb(
                currentTrackId: '0',
                currentPosition: context
                    .read<PlaybackPositionBloc>()
                    .position
                    .inMilliseconds,
              ),
            );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: BlocListener<PlaybackPositionBloc, PlaybackPositionState>(
        listener: (context, state) {
          state.map(
            initial: (initial) {},
            loading: (loading) {},
            loaded: (loaded) {
              // Seek to the saved position
              context.read<PlaybackPositionBloc>().add(
                    AudioPlaybackEvent.seek(
                      duration: Duration(
                        milliseconds:
                            loaded.playbackStateEntity.currentPosition,
                      ),
                    ),
                  );
            },
            seeked: (value) {},
            error: (error) {
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(SnackBar(content: Text(error.message)));
            },
          );
        },
        child: const AudioPlayerUI(),
      ),
    );
  }
}
