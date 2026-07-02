import 'dart:io';
import 'dart:typed_data';

import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

Future<void> openPlatformFile(String path) async {
  await OpenFilex.open(path);
}

Future<void> openBytesAsTemporaryFile(Uint8List bytes, String fileName) async {
  final tempDir = await getTemporaryDirectory();
  final file = await File('${tempDir.path}/$fileName').create();
  await file.writeAsBytes(bytes);
  await openPlatformFile(file.path);
}

Future<String?> saveAttachmentBytesToDisk(Uint8List bytes, String fileName) async {
  try {
    final appDir = await getApplicationDocumentsDirectory();
    final attachmentsDir = Directory('${appDir.path}/attachments');
    if (!await attachmentsDir.exists()) {
      await attachmentsDir.create(recursive: true);
    }
    // Prefix the file name with a timestamp to avoid collisions
    final uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}_$fileName';
    final file = File('${attachmentsDir.path}/$uniqueFileName');
    await file.writeAsBytes(bytes);
    return file.path;
  } catch (e) {
    return null;
  }
}

