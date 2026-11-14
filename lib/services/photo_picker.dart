import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

enum PhotoSource { camera, gallery }

/// Lets a parent take or choose a photo. Returns null when they back out.
typedef PhotoPicker = Future<Uint8List?> Function(PhotoSource source);

final photoPickerProvider = Provider<PhotoPicker>((ref) => _pickWithDevice);

Future<Uint8List?> _pickWithDevice(PhotoSource source) async {
  // Card pictures are shown at most ~170 logical pixels wide, so a photo
  // scaled to 800 px stays sharp on tablets and keeps storage small.
  final file = await ImagePicker().pickImage(
    source: switch (source) {
      PhotoSource.camera => ImageSource.camera,
      PhotoSource.gallery => ImageSource.gallery,
    },
    maxWidth: 800,
    maxHeight: 800,
    imageQuality: 85,
  );
  return file?.readAsBytes();
}
