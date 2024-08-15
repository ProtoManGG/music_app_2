import 'package:dartz/dartz.dart';
import 'package:music_app_2/core/error/failures.dart';
import 'package:music_app_2/core/usecases/usecase.dart';
import '../repositories/audio_repository.dart';

class PlayAudio implements UseCase<None, PlayAudioParams> {
  final AudioRepository repository;

  PlayAudio(this.repository);

  @override
  Future<Either<Failure, None>> call(PlayAudioParams params) async {
    return await repository.playAudio(params.url);
  }
}

class PlayAudioParams {
  final String url;

  PlayAudioParams({required this.url});
}
