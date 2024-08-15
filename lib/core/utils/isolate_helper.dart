import 'dart:isolate';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';

void isolateFunction(SendPort sendPort) async {
  final ReceivePort receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  File? file;
  SendPort? responsePort;

  await for (final message in receivePort) {
    if (message is Map<String, dynamic>) {
      if (message.containsKey('path')) {
        // Initialize the file path
        file = File(message['path']);
        responsePort = message['responsePort'];
        responsePort?.send('Initialized');
      } else if (file != null) {
        final data = {
          'currentTrackId': message['trackId'],
          'currentPosition': message['position'],
        };
        try {
          await file.writeAsString(json.encode(data));
          responsePort?.send('Saved');
        } catch (e) {
          debugPrint('Error saving data: $e'); // Log any errors
        }
      }
    } else if (message == 'exit') {
      break;
    }
  }

  receivePort.close();
}
