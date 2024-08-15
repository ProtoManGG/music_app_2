import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/playback_state.dart';
import '../repositories/playback_repository.dart';

class SeekAudio implements UseCase<PlaybackStateEntity, SeekAudioParams> {
  final PlaybackRepository repository;

  SeekAudio(this.repository);

  @override
  Future<Either<Failure, PlaybackStateEntity>> call(SeekAudioParams params) async {
    return await repository.seekAudio(params.duration);
  }
}

class SeekAudioParams {
  final Duration duration;

  SeekAudioParams({required this.duration});
}
