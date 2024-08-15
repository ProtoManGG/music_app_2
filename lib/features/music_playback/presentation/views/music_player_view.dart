import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app_2/features/music_playback/presentation/viewmodels/audio_track/audio_track_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app_2/features/music_playback/data/datasources/audio_remote_data_source.dart';
import 'package:music_app_2/features/music_playback/data/repositories/audio_track_repository_impl.dart';
import 'package:music_app_2/features/music_playback/domain/repositories/audio_repository.dart';
import 'package:music_app_2/features/music_playback/domain/usecases/get_audio_track.dart';
import 'package:music_app_2/features/music_playback/domain/usecases/pause_audio.dart';
import 'package:music_app_2/features/music_playback/domain/usecases/play_audio.dart';
import 'package:music_app_2/features/music_playback/domain/usecases/seek_audio.dart';

class MusicPlayerView extends StatelessWidget {
  const MusicPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Player'),
      ),
      body: BlocProvider(
        create: (context) {
          final AudioPlayer audioPlayer = AudioPlayer();
          final AudioRemoteDataSource audioRemoteDataSource =
              AudioRemoteDataSourceImpl();
          final AudioRepository audioRepository = AudioRepositoryImpl(
            remoteDataSource: audioRemoteDataSource,
            audioPlayer: audioPlayer,
          );
          return AudioTrackBloc(
            getAudioTrack: GetAudioTrack(audioRepository),
            pauseAudio: PauseAudio(audioRepository),
            playAudio: PlayAudio(audioRepository),
            seekAudio: SeekAudio(audioRepository),
          );
        },
        child: const AudioPlayerWidget(),
      ),
    );
  }
}

class AudioPlayerWidget extends StatelessWidget {
  const AudioPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<AudioTrackBloc, AudioTrackState>(
          builder: (context, state) {
            return state.map(
              initial: (value) {
                context
                    .read<AudioTrackBloc>()
                    .add(const AudioTrackEvent.getAudio(id: 'id'));
                return const Text('Loading...');
              },
              loading: (value) {
                return const Text('Loading...');
              },
              failure: (value) {
                return Text('Error: ${value.message}');
              },
              success: (value) {
                return const Text('Playing');
              },
            );
          },
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.replay_10),
              onPressed: () {
                context //
                    .read<AudioTrackBloc>()
                    .add(const AudioTrackEvent.seek(
                        duration: Duration(seconds: 10)));
              },
            ),
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                const url =
                    'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8';
                context
                    .read<AudioTrackBloc>()
                    .add(const AudioTrackEvent.play(url: url));
              },
            ),
            IconButton(
              icon: const Icon(Icons.pause),
              onPressed: () {
                context
                    .read<AudioTrackBloc>()
                    .add(const AudioTrackEvent.pause());
              },
            ),
            IconButton(
              icon: const Icon(Icons.forward_10),
              onPressed: () {
                context //
                    .read<AudioTrackBloc>()
                    .add(const AudioTrackEvent.seek(
                      duration: Duration(seconds: 10),
                    ));
              },
            ),
          ],
        ),
      ],
    );
  }
}
