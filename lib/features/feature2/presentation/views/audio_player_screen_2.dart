import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app_2/features/feature2/presentation/views/isolate_helper.dart';
import 'package:music_app_2/features/feature2/presentation/widgets/audio_player_ui.dart';
import 'package:music_app_2/features/music_playback/domain/entitites/position_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen>
    with WidgetsBindingObserver {
  late AudioPlayer _audioPlayer;
  Isolate? _isolate;
  SendPort? _sendPort;
  String? _filePath;
  final Completer<void> _isolateReady = Completer<void>();

  static const url =
      'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8';

  final _playlist = ConcatenatingAudioSource(
    children: [
      AudioSource.uri(
        Uri.parse(url),
        tag: MediaItem(
          id: '0',
          title: 'NASA\'s view on Space',
          artist: 'NASA COM',
          artUri: Uri.parse(
            'https://images.unsplash.com/photo-1723375386110-729a0612ab99',
          ),
        ),
      ),
    ],
  );

  Stream<PositionData> get _positionDataStream => Rx.combineLatest3(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) {
          return PositionData(
            position: position,
            bufferedPosition: bufferedPosition,
            duration: duration ?? Duration.zero,
          );
        },
      );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _audioPlayer = AudioPlayer();
    _initIsolate().then((_) {
      _loadPlaybackState(); // Load the saved state
      // _init();
    });

    // Listen to position stream and save playback state every 5 seconds
    _audioPlayer.positionStream.listen((position) {
      // print('Current position: $position'); // Log the current position
      // if (position.inSeconds % 5 == 0) {
      //   _savePlaybackState();
      // }
    });

    _audioPlayer.play(); // Start playback
  }

  Future<void> _initIsolate() async {
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
        print(
            'Main thread received message: Initialized'); // Log received message
        responsePort.close();
        _isolateReady.complete();
        break;
      }
    }
  }

  Future<void> _loadPlaybackState() async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/playback_state.json';
    final file = File(filePath);

    if (await file.exists()) {
      final contents = await file.readAsString();
      print('Loaded contents: $contents'); // Log the contents of the file
      final data = json.decode(contents);

      // Assuming you have a method to set the audio player state
      if (data is Map<String, dynamic>) {
        final trackId = data['currentTrackId'];
        final position = data['currentPosition'];

        // Load the audio source with the MediaItem
        await _audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(url),
            tag: MediaItem(
              id: '0',
              title: 'NASA\'s view on Space',
              artist: 'NASA COM',
              artUri: Uri.parse(
                'https://images.unsplash.com/photo-1723375386110-729a0612ab99',
              ),
            ),
          ),
        );

        // Seek to the saved position
        await _audioPlayer.seek(
            Duration(milliseconds: position)); // Use milliseconds for seeking
        print(
            'Loaded state: trackId = $trackId, position = $position'); // Log loaded state
      }
    } else {
      print(
          'Playback state file does not exist.'); // Log if the file does not exist

      await _audioPlayer.setLoopMode(LoopMode.all);
      await _audioPlayer.setAudioSource(_playlist);
    }
  }

  // Future<void> _init() async {
  //   await _audioPlayer.setLoopMode(LoopMode.all);
  //   await _audioPlayer.setAudioSource(_playlist);
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer.dispose();
    if (_isolate != null) {
      _sendPort?.send('exit');
      _isolate!.kill(priority: Isolate.immediate);
      _isolate = null;
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      print("+++ for PAUSE");
      _savePlaybackState(); // Save state when app goes to background
    } else if (state == AppLifecycleState.inactive) {
      print("+++ for INACTIVE");
      _savePlaybackState(); // Save state when app is terminated
    } else if (state == AppLifecycleState.detached) {
      print("+++ for KILL");
      _savePlaybackState(); // Save state when app is terminated
    }
  }

  Future<void> _savePlaybackState() async {
    await _isolateReady.future; // Wait for isolate to be ready
    if (_sendPort != null) {
      final completer = Completer<void>();
      final responsePort = ReceivePort();

      // Send the current track ID and position to the isolate
      _sendPort!.send({
        'trackId': '0', // Assuming a single track for simplicity
        'position': _audioPlayer.position
            .inMilliseconds, // Save the current position in milliseconds
      });

      responsePort.listen((message) {
        if (message == 'Saved') {
          completer.complete();
          responsePort.close();
        }
      });

      await completer.future;

      // Log the saved state
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/playback_state.json';
      final file = File(filePath);
      final contents = await file.readAsString();
      print('Saved contents: $contents'); // Log the contents after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: AudioPlayerUI(
          audioPlayer: _audioPlayer, positionDataStream: _positionDataStream),
    );
  }
}
