import 'dart:typed_data';

import 'package:flutter/material.dart';

ImageProvider? buildProfileImageProvider(dynamic profilePhoto) {
  if (profilePhoto is Uint8List) {
    return MemoryImage(profilePhoto);
  }
  return null;
}

