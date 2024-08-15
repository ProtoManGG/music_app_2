import 'package:dartz/dartz.dart';
import 'package:music_app_2/core/error/failures.dart';
import 'package:music_app_2/core/usecases/usecase.dart';
import 'package:music_app_2/features/music_app/domain/entities/playback_state.dart';
import 'package:music_app_2/features/music_app/domain/repositories/playback_repository.dart';

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
