import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:music_app_2/core/utils/isolate_helper.dart';
import 'package:path_provider/path_provider.dart';

import '../models/playback_state_model.dart';

abstract interface class PlaybackLocalDataSource {
  Future<void> initIsolate();
  void disposeIsolate();
  Future<PlaybackStateModel?> loadFromDb();
  Future<void> saveToDb({
    required String currentTrackId,
    required int currentPosition,
  });
}

class PlaybackLocalDataSourceImpl implements PlaybackLocalDataSource {
  Isolate? _isolate;
  SendPort? _sendPort;
  String? _filePath;
  final Completer<void> _isolateReady = Completer<void>();

  @override
  Future<void> initIsolate() async {
    final dir = await getApplicationDocumentsDirectory();
    _filePath = '${dir.path}/playback_state.json';

    final receivePort = ReceivePort();
    _isolate = await Isolate.spawn(isolateFunction, receivePort.sendPort);

    _sendPort = await receivePort.first;

    // Initialize the isolate with the file path
    final responsePort = ReceivePort();
    _sendPort!.send({
      'path': _filePath,
      'responsePort': responsePort.sendPort
    }); // Send response port

    await for (var message in responsePort) {
      if (message == 'Initialized') {
        // print(
        //     'Main thread received message: Initialized'); // Log received message
        responsePort.close();
        _isolateReady.complete();
        break;
      }
    }
  }

  @override
  Future<PlaybackStateModel?> loadFromDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/playback_state.json';
    final file = File(filePath);

    if (await file.exists()) {
      final contents = await file.readAsString();
      final data = json.decode(contents);

      // Assuming you have a method to set the audio player state
      if (data is Map<String, dynamic>) {
        final trackId = data['currentTrackId'];
        final position = data['currentPosition'];
        return PlaybackStateModel(
          currentTrackId: trackId,
          currentPosition: position,
        );
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<void> saveToDb({
    required String currentTrackId,
    required int currentPosition,
  }) async {
    await _isolateReady.future; // Wait for isolate to be ready
    if (_sendPort != null) {
      final completer = Completer<void>();
      final responsePort = ReceivePort();

      // Send the current track ID and position to the isolate
      _sendPort!.send({
        'trackId': currentTrackId,
        'position': currentPosition,
      });

      responsePort.listen((message) {
        if (message == 'Saved') {
          completer.complete();
          responsePort.close();
        }
      });

      await completer.future;
    }
  }

  @override
  void disposeIsolate() {
    if (_isolate != null) {
      _sendPort?.send('exit');
      _isolate!.kill(priority: Isolate.immediate);
      _isolate = null;
    }
  }
}
