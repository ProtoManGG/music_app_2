import 'package:dartz/dartz.dart';
import 'package:music_app_2/core/error/failures.dart';
import 'package:music_app_2/core/usecases/usecase.dart';
import 'package:music_app_2/features/music_playback/domain/repositories/audio_repository.dart';

class SeekAudio implements UseCase<None, SeekAudioParams> {
  final AudioRepository repository;

  SeekAudio(this.repository);

  @override
  Future<Either<Failure, None>> call(SeekAudioParams params) async {
    return await repository.seekAudio(params.duration);
  }
}

class SeekAudioParams {
  final Duration duration;

  SeekAudioParams({required this.duration});
}
