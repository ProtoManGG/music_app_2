import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app_2/features/feature2/presentation/bloc/playback_position_bloc.dart';
import 'package:music_app_2/features/feature2/presentation/widgets/audio_player_ui.dart';
import 'package:music_app_2/features/feature2/domain/entities/position_data.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen>
    with WidgetsBindingObserver {
  late AudioPlayer _audioPlayer;

  Stream<PositionData> get _positionDataStream => Rx.combineLatest3(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) {
          return PositionData(
            position: position,
            bufferedPosition: bufferedPosition,
            duration: duration ?? Duration.zero,
          );
        },
      );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _audioPlayer = AudioPlayer();
    context
        .read<PlaybackPositionBloc>()
        .add(const AudioPlaybackEvent.initIsolate());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer.dispose();
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
                currentPosition: _audioPlayer.position.inMilliseconds,
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
            loaded: (loaded) async {
              const url =
                  'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8';

              // Load the audio source with the MediaItem
              await _audioPlayer.setAudioSource(
                AudioSource.uri(
                  Uri.parse(url),
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

              // Seek to the saved position
              await _audioPlayer.seek(
                Duration(
                  milliseconds: loaded.playbackStateEntity.currentPosition,
                ),
              );
            },
            error: (error) {
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(SnackBar(content: Text(error.message)));
            },
          );
        },
        child: AudioPlayerUI(
          audioPlayer: _audioPlayer,
          positionDataStream: _positionDataStream,
        ),
      ),
    );
  }
}
