import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:logger/logger.dart';
import 'dart:io' as io;

final logger = Logger();

class AudioService {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  
  String? _currentRecordingPath;
  bool _isRecording = false;
  Duration _recordingDuration = Duration.zero;

  Stream<Duration> get recordingDurationStream => Stream.periodic(
    const Duration(milliseconds: 100),
    (_) => _recordingDuration,
  );

  Future<bool> requestPermission() async {
    if (kIsWeb) return true;
    return await _recorder.hasPermission();
  }

  Future<String?> startRecording(String section) async {
    if (kIsWeb) {
      logger.w('Enregistrement non supporté sur Web.');
      return null;
    }
    try {
      if (await _recorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        final audioDir = io.Directory('${dir.path}/reports_audio');
        if (!await audioDir.exists()) {
          await audioDir.create(recursive: true);
        }

        final fileName = 'report_${section}_${const Uuid().v4()}.m4a';
        _currentRecordingPath = '${audioDir.path}/$fileName';

        await _recorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000, sampleRate: 44100),
          path: _currentRecordingPath!,
        );

        _isRecording = true;
        _recordingDuration = Duration.zero;
        
        return _currentRecordingPath;
      }
      return null;
    } catch (e) {
      logger.e('Erreur démarrage enregistrement: $e');
      return null;
    }
  }

  Future<Duration?> stopRecording() async {
    if (kIsWeb) return null;
    try {
      if (_isRecording) {
        await _recorder.stop();
        _isRecording = false;
        return _recordingDuration;
      }
      return null;
    } catch (e) {
      logger.e('Erreur arrêt enregistrement: $e');
      return null;
    }
  }

  Future<void> pauseRecording() async {
    if (!kIsWeb && _isRecording) {
      await _recorder.pause();
    }
  }

  Future<void> resumeRecording() async {
    if (!kIsWeb && !_isRecording && _currentRecordingPath != null) {
      await _recorder.resume();
      _isRecording = true;
    }
  }

  Future<void> playAudio(String filePath) async {
    try {
      await _player.play(DeviceFileSource(filePath));
    } catch (e) {
      logger.e('Erreur lecture: $e');
    }
  }

  Future<void> pausePlayback() async => await _player.pause();
  Future<void> resumePlayback() async => await _player.resume();
  Future<void> stopPlayback() async => await _player.stop();

  Stream<Duration> get playerPositionStream => _player.onPositionChanged;
  Stream<PlayerState> get playerStateStream => _player.onPlayerStateChanged;

  Duration get currentRecordingDuration => _recordingDuration;
  bool get isRecording => _isRecording;

  Future<void> deleteAudio(String filePath) async {
    if (kIsWeb) return;
    try {
      final file = io.File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      logger.e('Erreur suppression fichier audio: $e');
    }
  }

  void dispose() {
    _recorder.dispose();
    _player.dispose();
  }
}
