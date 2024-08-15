import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/playback_repository.dart';

class DisposeIsolate implements UseCase<void, NoParams> {
  final PlaybackRepository repository;
  DisposeIsolate(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return repository.disposeIsolate();
  }
}
