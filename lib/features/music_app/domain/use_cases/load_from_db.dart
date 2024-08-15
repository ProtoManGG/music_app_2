import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/playback_repository.dart';

import '../entities/playback_state.dart';

class LoadFromDb implements UseCase<void, NoParams> {
  final PlaybackRepository repository;
  LoadFromDb(this.repository);

  @override
  Future<Either<Failure, PlaybackStateEntity>> call(NoParams params) async {
    return await repository.loadFromDb();
  }
}
