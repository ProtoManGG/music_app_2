import 'package:dartz/dartz.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app_2/core/error/failures.dart';
import 'package:music_app_2/features/feature2/domain/entities/playback_state.dart';
import 'package:music_app_2/features/feature2/domain/repositories/playback_repository.dart';

import '../data_sources/playback_local_data_source.dart';

class PlaybackRepositoryImpl implements PlaybackRepository {
  final PlaybackLocalDataSource localDataSource;
  final AudioPlayer audioPlayer;

  PlaybackRepositoryImpl({
    required this.localDataSource,
    required this.audioPlayer,
  });

  @override
  Future<Either<Failure, PlaybackStateEntity>> loadFromDb() async {
    try {
      final result = await localDataSource.loadFromDb();
      if (result != null) {
        return right(result);
      }
      return left(const CacheFailure(message: "No Data Stored"));
    } catch (e) {
      return left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveToDb({
    required String currentTrackId,
    required int currentPosition,
  }) async {
    try {
      await localDataSource.saveToDb(
        currentPosition: currentPosition,
        currentTrackId: currentTrackId,
      );
      return right(null);
    } catch (e) {
      return left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> initIsolate() async {
    try {
      await localDataSource.initIsolate();
      return right(null);
    } catch (e) {
      return left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Either<Failure, void> disposeIsolate() {
    try {
      localDataSource.disposeIsolate();
      return right(null);
    } catch (e) {
      return left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> pauseAudio() async {
    try {
      await audioPlayer.pause();
      return right(null);
    } catch (e) {
      return left(AudioFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> playAudio(String url) async {
    try {
      //FIXME: URL
      await audioPlayer.play();
      return right(null);
    } catch (e) {
      return left(AudioFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> seekAudio(int seconds) async {
    try {
      await audioPlayer
          .seek(Duration(seconds: audioPlayer.position.inSeconds + seconds));
      return right(null);
    } catch (e) {
      return left(AudioFailure(message: e.toString()));
    }
  }
}
