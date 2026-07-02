import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String?> savePdfReport(List<int> bytes, String reportId) async {
  final directory = await getApplicationDocumentsDirectory();
  final pdfDir = Directory('${directory.path}/reports_pdf');
  if (!await pdfDir.exists()) {
    await pdfDir.create(recursive: true);
  }

  final pdfPath =
      '${pdfDir.path}/${reportId}_${DateTime.now().millisecondsSinceEpoch}.pdf';
  final file = File(pdfPath);
  await file.writeAsBytes(bytes);
  return pdfPath;
}

