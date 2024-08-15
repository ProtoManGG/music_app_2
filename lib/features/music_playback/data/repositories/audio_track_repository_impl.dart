import 'package:dartz/dartz.dart';
import 'package:music_app_2/core/error/failures.dart';
import 'package:music_app_2/features/music_playback/domain/entitites/audio_track.dart';
import '../../domain/repositories/audio_repository.dart';
import '../datasources/audio_remote_data_source.dart';
import 'package:just_audio/just_audio.dart';

class AudioRepositoryImpl implements AudioRepository {
  final AudioRemoteDataSource remoteDataSource;
  final AudioPlayer audioPlayer;

  AudioRepositoryImpl({
    required this.remoteDataSource,
    required this.audioPlayer,
  });

  @override
  Future<Either<Failure, AudioTrack>> getAudioTrack(String id) async {
    try {
      final remoteAudioTrack = await remoteDataSource.getAudioTrack(id);
      return Right(remoteAudioTrack);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, None>> playAudio(String url) async {
    try {
      await audioPlayer.setUrl(url);
      await audioPlayer.play();
      return const Right(None());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, None>> pauseAudio() async {
    try {
      await audioPlayer.pause();
      return const Right(None());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, None>> seekAudio(Duration position) async {
    try {
      await audioPlayer.seek(position);
      return const Right(None());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // @override
  // void dispose() {
  //   audioPlayer.dispose();
  // }

  // @override
  // Stream<PlayerState> get playerStateStream => audioPlayer.playerStateStream;
}
