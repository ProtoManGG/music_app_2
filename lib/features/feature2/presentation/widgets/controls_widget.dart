import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Controls extends StatelessWidget {
  const Controls({
    super.key,
    required this.audioPlayer,
  });

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            audioPlayer
                .seek(Duration(seconds: audioPlayer.position.inSeconds - 10));
          },
          icon: const Icon(
            Icons.replay_10_rounded,
            size: 60,
            color: Colors.white,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;

            if (!(playing ?? false)) {
              return IconButton(
                onPressed: audioPlayer.play,
                icon: const Icon(
                  Icons.play_arrow_rounded,
                  size: 80,
                  color: Colors.white,
                ),
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                onPressed: audioPlayer.pause,
                icon: const Icon(
                  Icons.pause_rounded,
                  size: 80,
                  color: Colors.white,
                ),
              );
            } else {
              return const Icon(
                Icons.play_arrow_rounded,
                size: 80,
                color: Colors.white,
              );
            }
          },
        ),
        IconButton(
          onPressed: () {
            audioPlayer
                .seek(Duration(seconds: audioPlayer.position.inSeconds + 10));
          },
          icon: const Icon(
            Icons.forward_10_rounded,
            size: 60,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
