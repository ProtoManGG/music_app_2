import 'package:dartz/dartz.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:music_app_2/core/error/failures.dart';
import 'package:music_app_2/features/music_playback/domain/entitites/audio_track.dart';

abstract class AudioRepository {
  Future<Either<Failure, AudioTrack>> getAudioTrack(String id);
  Future<Either<Failure, None>> playAudio(String url);
  Future<Either<Failure, None>> pauseAudio();
  Future<Either<Failure, None>> seekAudio(Duration position);
  // void dispose();
  // Stream<PlayerState> get playerStateStream;
}
