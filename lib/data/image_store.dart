import 'dart:typed_data';

import 'image_store_io.dart'
    if (dart.library.js_interop) 'image_store_web.dart'
    as platform;

/// Keeps the photos of parent-made cards on the device.
abstract interface class ImageStore {
  /// Stores [bytes] under [id], replacing any earlier photo with that id.
  Future<void> save(String id, Uint8List bytes);

  /// Returns null when no photo is stored under [id].
  Future<Uint8List?> load(String id);

  Future<void> delete(String id);
}

/// Files in the app's private folder on mobile, browser storage on web.
ImageStore createImageStore() => platform.createImageStore();

/// Holds photos in memory. Used by tests.
class MemoryImageStore implements ImageStore {
  final Map<String, Uint8List> _images = {};

  @override
  Future<void> save(String id, Uint8List bytes) async => _images[id] = bytes;

  @override
  Future<Uint8List?> load(String id) async => _images[id];

  @override
  Future<void> delete(String id) async => _images.remove(id);
}
