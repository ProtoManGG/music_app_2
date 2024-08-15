import 'package:dartz/dartz.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../core/error/failures.dart';
import '../entities/position_data.dart';

import '../entities/playback_state.dart';

abstract interface class PlaybackRepository {
  Future<Either<Failure, void>> initIsolate();
  Future<Either<Failure, void>> saveToDb({
    required String currentTrackId,
    required int currentPosition,
  });
  Future<Either<Failure, PlaybackStateEntity>> loadFromDb();
  Either<Failure, void> disposeIsolate();
  Future<Either<Failure, void>> playAudio();
  Future<Either<Failure, void>> pauseAudio();
  Future<Either<Failure, PlaybackStateEntity>> seekAudio(Duration duration);
  Stream<PlayerState> get playerStateStream;
  Duration get position;
  Stream<PositionData> get positionDataStream;
  Stream<SequenceState?> get sequenceStateStream;
}
