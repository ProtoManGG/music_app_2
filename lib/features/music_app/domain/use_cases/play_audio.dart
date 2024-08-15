import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/playback_repository.dart';

class PlayAudio implements UseCase<void, NoParams> {
  final PlaybackRepository repository;

  PlayAudio(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.playAudio();
  }
}

// class PlayAudioParams {
//   final String url;

//   PlayAudioParams({required this.url});
// }
