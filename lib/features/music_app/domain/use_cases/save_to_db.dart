import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/playback_repository.dart';

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
