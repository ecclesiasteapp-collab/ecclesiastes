import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:ecclesiastes/services/file_storage_service.dart';
import 'dart:typed_data';
import '../models/attachment_model.dart';
import '../services/file_attachment_service.dart';

class AttachmentPickerWidget extends StatefulWidget {
  final String contextType; // 'event' ou 'announcement'
  final ValueChanged<Attachment?> onAttachmentChanged;
  final Attachment? initialAttachment;
  final String? customLabel;

  const AttachmentPickerWidget({
    super.key,
    required this.contextType,
    required this.onAttachmentChanged,
    this.initialAttachment,
    this.customLabel,
  });

  @override
  State<AttachmentPickerWidget> createState() => _AttachmentPickerWidgetState();
}

class _AttachmentPickerWidgetState extends State<AttachmentPickerWidget> {
  Attachment? _attachment;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _attachment = widget.initialAttachment;
  }

  Future<void> _pickFile() async {
    final ImagePicker picker = ImagePicker();

    // Si c'est une annonce, on propose la caméra/galerie
    if (widget.contextType == 'announcement') {
      final ImageSource? source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (context) => SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galerie Photos'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Prendre une Photo'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.file_present),
                title: const Text('Document (PDF)'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      );

      if (source != null) {
        setState(() => _isLoading = true);
        try {
          final XFile? image = await picker.pickImage(source: source);
          if (image != null) {
            final bytes = await image.readAsBytes();
            final savedPath = await FileStorageService.saveFile(bytes, image.name);
            final attachment = Attachment(
              id: const Uuid().v4(),
              fileName: image.name,
              mimeType: 'image/jpeg',
              relativePath: savedPath,
              fileSize: bytes.length,
              fileExtension: image.name.split('.').last,
            );
            setState(() => _attachment = attachment);
            widget.onAttachmentChanged(attachment);
          }
        } finally {
          setState(() => _isLoading = false);
        }
        return;
      }
    }

    // Comportement standard (FilePicker)
    setState(() => _isLoading = true);
    try {
      final Attachment? newAttachment = widget.contextType == 'event'
          ? await FileAttachmentService.pickEventDataFile()
          : await FileAttachmentService.pickAnnouncementPoster();

      if (newAttachment != null) {
        setState(() => _attachment = newAttachment);
        widget.onAttachmentChanged(newAttachment);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _removeAttachment() {
    setState(() => _attachment = null);
    widget.onAttachmentChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_attachment != null) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            if (_attachment!.isImage)
              FutureBuilder<Uint8List?>(
                future: FileStorageService.readFile(_attachment!.relativePath),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                    return Image.memory(snapshot.data!, height: 150, width: double.infinity, fit: BoxFit.cover);
                  } else if (snapshot.hasError) {
                    return const Icon(Icons.error, size: 50, color: Colors.red);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              )
            else
              Container(
                height: 100,
                color: Colors.grey[100],
                child: const Icon(Icons.insert_drive_file, size: 40, color: Colors.grey),
              ),
            ListTile(
              title: Text(_attachment!.fileName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              subtitle: Text('${_attachment!.fileSizeInMB.toStringAsFixed(2)} MB', style: const TextStyle(fontSize: 10)),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: _removeAttachment,
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: _pickFile,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[50],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.contextType == 'event' ? Icons.table_chart : Icons.add_a_photo, color: const Color(0xFF003366)),
              const SizedBox(height: 8),
              Text(widget.customLabel ?? 'Ajouter un fichier', style: const TextStyle(color: Color(0xFF003366), fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}

