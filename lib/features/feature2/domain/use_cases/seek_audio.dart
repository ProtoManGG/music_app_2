import 'package:dartz/dartz.dart';
import 'package:music_app_2/core/error/failures.dart';
import 'package:music_app_2/core/usecases/usecase.dart';
import 'package:music_app_2/features/feature2/domain/repositories/playback_repository.dart';

class SeekAudio implements UseCase<void, SeekAudioParams> {
  final PlaybackRepository repository;

  SeekAudio(this.repository);

  @override
  Future<Either<Failure, void>> call(SeekAudioParams params) async {
    return await repository.seekAudio(params.seconds);
  }
}

class SeekAudioParams {
  final int seconds;

  SeekAudioParams({required this.seconds});
}
