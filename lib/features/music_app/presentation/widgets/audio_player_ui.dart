import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app_2/features/music_app/domain/entities/position_data.dart';
import 'package:music_app_2/features/music_app/presentation/bloc/playback_position_bloc.dart';
import 'package:music_app_2/features/music_app/presentation/widgets/controls_widget.dart';
import 'package:music_app_2/features/music_app/presentation/widgets/media_metadata_widget.dart';

class AudioPlayerUI extends StatelessWidget {
  const AudioPlayerUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaybackPositionBloc, PlaybackPositionState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff144771),
                Color(0xff071a2c),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<SequenceState?>(
                stream:
                    context.read<PlaybackPositionBloc>().sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const SizedBox();
                  }
                  final metadata = state!.currentSource!.tag as MediaItem;
                  return MediaMetadata(
                    imageUrl: metadata.artUri.toString(),
                    artist: metadata.artist ?? '',
                    title: metadata.title,
                  );
                },
              ),
              const SizedBox(height: 20),
              StreamBuilder<PositionData>(
                stream: context.read<PlaybackPositionBloc>().positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return ProgressBar(
                      barHeight: 8,
                      baseBarColor: Colors.grey[600],
                      bufferedBarColor: Colors.grey,
                      progressBarColor: Colors.red,
                      thumbColor: Colors.red,
                      timeLabelTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      progress: positionData?.position ?? Duration.zero,
                      buffered: positionData?.bufferedPosition ?? Duration.zero,
                      total: positionData?.duration ?? Duration.zero,
                      onSeek: (val) {
                        context
                            .read<PlaybackPositionBloc>()
                            .add(AudioPlaybackEvent.seek(duration: val));
                      });
                },
              ),
              const Controls(),
            ],
          ),
        );
      },
    );
  }
}
