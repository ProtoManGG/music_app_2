import 'package:dartz/dartz.dart';
import 'package:music_app_2/core/error/failures.dart';
import 'package:music_app_2/core/usecases/usecase.dart';
import 'package:music_app_2/features/music_app/domain/repositories/playback_repository.dart';

class SaveToDb implements UseCase<void, SaveToDbParams> {
  final PlaybackRepository repository;

  SaveToDb(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveToDbParams params) async {
    return await repository.saveToDb(
      currentPosition: params.currentPosition,
      currentTrackId: params.currentTrackId,
    );
  }
}

class SaveToDbParams {
  final String currentTrackId;
  final int currentPosition;

  SaveToDbParams({
    required this.currentTrackId,
    required this.currentPosition,
  });
}
