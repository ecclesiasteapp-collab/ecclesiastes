import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

ImageProvider? buildProfileImageProvider(dynamic profilePhoto) {
  if (profilePhoto is Uint8List) {
    return MemoryImage(profilePhoto);
  }
  if (profilePhoto is File) {
    return FileImage(profilePhoto);
  }
  if (profilePhoto is String && profilePhoto.isNotEmpty) {
    return FileImage(File(profilePhoto));
  }
  return null;
}

