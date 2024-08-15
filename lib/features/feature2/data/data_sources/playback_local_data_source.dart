import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/playback_state_model.dart';

class PlaybackLocalDataSource {
  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/playback_state.json');
  }

  Future<void> saveState(PlaybackStateModel state) async {
    final file = await _getFile();
    await file.writeAsString(json.encode(state.toJson()));
  }

  Future<PlaybackStateModel?> loadState() async {
    final file = await _getFile();
    if (await file.exists()) {
      final contents = await file.readAsString();
      return PlaybackStateModel.fromJson(json.decode(contents));
    }
    return null;
  }
}
