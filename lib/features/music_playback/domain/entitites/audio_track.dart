import 'package:equatable/equatable.dart';

class AudioTrack extends Equatable {
  final String id;
  final String title;
  final String url;

  const AudioTrack({
    required this.id,
    required this.title,
    required this.url,
  });

  @override
  List<Object> get props => [id, title, url];
}
