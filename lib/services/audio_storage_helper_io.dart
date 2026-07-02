import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> createAudioRecordingPath(String section, String uuid) async {
  final dir = await getApplicationDocumentsDirectory();
  final audioDir = Directory('${dir.path}/reports_audio');
  if (!await audioDir.exists()) {
    await audioDir.create(recursive: true);
  }

  return '${audioDir.path}/report_${section}_$uuid.m4a';
}

Future<void> deleteAudioFile(String filePath) async {
  final file = File(filePath);
  if (await file.exists()) {
    await file.delete();
  }
}

