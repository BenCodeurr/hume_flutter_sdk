import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class HumeAI {
  final String apiKey;
  final String baseUrl;
  late final AudioRecorder _recorder;

  HumeAI({
    required this.apiKey,
    this.baseUrl = 'https://api.hume.ai/v0/evi/',
  }) {
    _recorder = AudioRecorder();
  }

//check if microphone permissions are granted
  Future<bool> checkPermission() async {
    return await _recorder.hasPermission();
  }

//Start recording audio
  Future startRecording() async {
    if (!await checkPermission()) {
      throw Exception('Microphone Permission not granted');
    }

    //get temporary directory for storing user's recorded audio
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/audio_recording.wav';

    //configure recoding parameters
    await _recorder.start(
      const RecordConfig(
          encoder: AudioEncoder.wav, sampleRate: 16000, numChannels: 1),
      path: filePath,
    );
  }

  //Stop recording and return file path
  Future<String> stopRecording() async {
    final path = await _recorder.stop();
    if (path == null) {
      throw Exception('Recording failed');
    }
    return path;
  }

  //Disposes of recorder ressources
  Future<void> dispose() async {
    await _recorder.dispose();
  }
}
