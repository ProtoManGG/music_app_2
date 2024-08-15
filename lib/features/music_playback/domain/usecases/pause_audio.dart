import 'package:dartz/dartz.dart';
import 'package:music_app_2/core/error/failures.dart';
import 'package:music_app_2/core/usecases/usecase.dart';
import '../repositories/audio_repository.dart';

class PauseAudio implements UseCase<None, NoParams> {
  final AudioRepository repository;

  PauseAudio(this.repository);

  @override
  Future<Either<Failure, None>> call(NoParams params) async {
    return await repository.pauseAudio();
  }
}
