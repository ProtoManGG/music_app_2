import 'package:dartz/dartz.dart';
import 'package:music_app_2/core/error/failures.dart';
import 'package:music_app_2/core/usecases/usecase.dart';
import 'package:music_app_2/features/feature2/domain/repositories/playback_repository.dart';

class DisposeIsolate implements UseCase<void, NoParams> {
  final PlaybackRepository repository;
  DisposeIsolate(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return repository.disposeIsolate();
  }
}
