import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/playback_repository.dart';

class PauseAudio implements UseCase<void, NoParams> {
  final PlaybackRepository repository;

  PauseAudio(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.pauseAudio();
  }
}
