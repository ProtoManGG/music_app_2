import 'package:dartz/dartz.dart';
import 'package:music_app_2/core/error/failures.dart';
import 'package:music_app_2/core/usecases/usecase.dart';
import 'package:music_app_2/features/feature2/domain/repositories/playback_repository.dart';

class PlayAudio implements UseCase<void, PlayAudioParams> {
  final PlaybackRepository repository;

  PlayAudio(this.repository);

  @override
  Future<Either<Failure, void>> call(PlayAudioParams params) async {
    return await repository.playAudio(params.url);
  }
}

class PlayAudioParams {
  final String url;

  PlayAudioParams({required this.url});
}
