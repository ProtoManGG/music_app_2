import 'package:dartz/dartz.dart';
import 'package:music_app_2/core/error/failures.dart';

import '../entities/playback_state.dart';

abstract interface class PlaybackRepository {
  Future<Either<Failure, void>> initIsolate();
  Future<Either<Failure, void>> saveToDb({
    required String currentTrackId,
    required int currentPosition,
  });
  Future<Either<Failure, PlaybackStateEntity>> loadFromDb();
  Either<Failure, void> disposeIsolate();
}
