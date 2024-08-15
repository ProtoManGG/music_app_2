import 'package:dartz/dartz.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app_2/core/error/failures.dart';
import 'package:music_app_2/features/music_app/domain/entities/playback_state.dart';
import 'package:music_app_2/features/music_app/domain/entities/position_data.dart';
import 'package:music_app_2/features/music_app/domain/repositories/playback_repository.dart';
import 'package:rxdart/rxdart.dart';

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
        print("GOT DATA $result");
        return right(result);
      }
      print("NO DATA");
      return left(const CacheFailure(message: "No Data Stored"));
    } catch (e) {
      print("ERROR");
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
      audioPlayer.dispose();
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
  Future<Either<Failure, void>> playAudio() async {
    try {
      await audioPlayer.play();
      return right(null);
    } catch (e) {
      return left(AudioFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PlaybackStateEntity>> seekAudio(Duration duration) async {
    try {
      // Wait until the player is not in processing state
      await for (final state in audioPlayer.playerStateStream) {
        if (state.processingState != ProcessingState.buffering && 
            state.processingState != ProcessingState.ready) {
          continue; // Wait for the player to be ready
        }
        break; // Player is ready, exit the loop
      }

      print("GOT DURATION: $duration");
      await audioPlayer.seek(duration);
      print("AFTER SEEK POSITION: ${audioPlayer.position}");
      return right(
        PlaybackStateEntity(
          currentTrackId: '0',
          currentPosition: audioPlayer.position.inSeconds,
        ),
      );
    } catch (e) {
      return left(AudioFailure(message: e.toString()));
    }
  }

  @override
  Stream<PlayerState> get playerStateStream => audioPlayer.playerStateStream;

  @override
  Duration get position => audioPlayer.position;

  @override
  Stream<PositionData> get positionDataStream {
    return Rx.combineLatest3(
      audioPlayer.positionStream,
      audioPlayer.bufferedPositionStream,
      audioPlayer.durationStream,
      (position, bufferedPosition, duration) {
        return PositionData(
          position: position,
          bufferedPosition: bufferedPosition,
          duration: duration ?? Duration.zero,
        );
      },
    );
  }

  @override
  Stream<SequenceState?> get sequenceStateStream {
    return audioPlayer.sequenceStateStream;
  }
}