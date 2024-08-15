import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app_2/features/music_app/presentation/bloc/playback_position_bloc.dart';

class Controls extends StatelessWidget {
  const Controls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaybackPositionBloc, PlaybackPositionState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                context.read<PlaybackPositionBloc>().add(
                      AudioPlaybackEvent.seek(
                        duration: Duration(
                          seconds: context
                                  .read<PlaybackPositionBloc>()
                                  .position
                                  .inSeconds -
                              10,
                        ),
                      ),
                    );
              },
              icon: const Icon(Icons.replay_10_rounded,
                  size: 60, color: Colors.white),
            ),
            StreamBuilder<PlayerState>(
              stream: context.read<PlaybackPositionBloc>().playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;

                if (!(playing ?? false)) {
                  return IconButton(
                    onPressed: () {
                      context
                          .read<PlaybackPositionBloc>()
                          .add(const AudioPlaybackEvent.play());
                    },
                    icon: const Icon(Icons.play_arrow_rounded,
                        size: 80, color: Colors.white),
                  );
                } else if (processingState != ProcessingState.completed) {
                  return IconButton(
                    onPressed: () {
                      context
                          .read<PlaybackPositionBloc>()
                          .add(const AudioPlaybackEvent.pause());
                    },
                    icon: const Icon(Icons.pause_rounded,
                        size: 80, color: Colors.white),
                  );
                } else {
                  return const Icon(Icons.play_arrow_rounded,
                      size: 80, color: Colors.white);
                }
              },
            ),
            IconButton(
              onPressed: () {
                context.read<PlaybackPositionBloc>().add(
                      AudioPlaybackEvent.seek(
                        duration: Duration(
                          seconds: context
                                  .read<PlaybackPositionBloc>()
                                  .position
                                  .inSeconds +
                              10,
                        ),
                      ),
                    );
              },
              icon: const Icon(Icons.forward_10_rounded,
                  size: 60, color: Colors.white),
            ),
          ],
        );
      },
    );
  }
}
