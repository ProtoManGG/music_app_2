import 'dart:isolate';
import 'dart:io';
import 'dart:convert';

void isolateFunction(SendPort sendPort) async {
  final ReceivePort receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  File? file;
  SendPort? responsePort; // Declare a variable for the response port

  await for (final message in receivePort) {
    // print('Received message: $message'); // Log the received message

    if (message is Map<String, dynamic>) {
      if (message.containsKey('path')) {
        // Initialize the file path
        file = File(message['path']);
        // print('File path set to: ${file.path}'); // Log the file path
        responsePort = message['responsePort']; // Get the response port
        responsePort?.send('Initialized'); // Send the message back
        // print('Sent message: Initialized'); // Log the sent message
      } else if (file != null) {
        // Save data
        final data = {
          'currentTrackId': message['trackId'],
          'currentPosition': message['position'],
        };
        try {
          await file.writeAsString(json.encode(data));
          // print('Data saved: $data'); // Log the saved data
          responsePort?.send('Saved');
        } catch (e) {
          // print('Error saving data: $e'); // Log any errors
        }
      }
    } else if (message == 'exit') {
      // print('Exiting isolate'); // Log when exiting
      break;
    }
  }

  receivePort.close();
}