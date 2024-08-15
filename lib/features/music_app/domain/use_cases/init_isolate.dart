import 'package:dartz/dartz.dart';
import 'package:music_app_2/core/error/failures.dart';
import 'package:music_app_2/core/usecases/usecase.dart';
import 'package:music_app_2/features/music_app/domain/repositories/playback_repository.dart';

class InitIsolate implements UseCase<void, NoParams> {
  final PlaybackRepository repository;
  InitIsolate(this.repository);
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.initIsolate();
  }
}

