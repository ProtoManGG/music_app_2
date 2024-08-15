import 'package:dartz/dartz.dart';
import 'package:music_app_2/core/error/failures.dart';
import 'package:music_app_2/core/usecases/usecase.dart';
import 'package:music_app_2/features/feature2/domain/repositories/playback_repository.dart';

import '../entities/playback_state.dart';

class LoadFromDb implements UseCase<void, NoParams> {
  final PlaybackRepository repository;
  LoadFromDb(this.repository);

  @override
  Future<Either<Failure, PlaybackStateEntity>> call(NoParams params) async {
    return await repository.loadFromDb();
  }
}
