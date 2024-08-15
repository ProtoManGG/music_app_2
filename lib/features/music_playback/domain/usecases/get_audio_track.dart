import 'package:dartz/dartz.dart';
import 'package:music_app_2/core/error/failures.dart';
import 'package:music_app_2/core/usecases/usecase.dart';
import 'package:music_app_2/features/music_playback/domain/entitites/audio_track.dart';
import '../repositories/audio_repository.dart';

class GetAudioTrack implements UseCase<AudioTrack, GetAudioTrackParams> {
  final AudioRepository repository;

  GetAudioTrack(this.repository);

  @override
  Future<Either<Failure, AudioTrack>> call(GetAudioTrackParams params) async {
    return await repository.getAudioTrack(params.id);
  }
}

class GetAudioTrackParams {
  final String id;

  GetAudioTrackParams({required this.id});
}
