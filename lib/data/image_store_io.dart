import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

import 'image_store.dart';

ImageStore createImageStore() => FileImageStore();

/// One file per photo in `<app documents>/card_images/`.
class FileImageStore implements ImageStore {
  Future<Directory>? _directory;

  Future<Directory> _open() => _directory ??= () async {
    final documents = await getApplicationDocumentsDirectory();
    return Directory('${documents.path}/card_images').create(recursive: true);
  }();

  Future<File> _file(String id) async => File('${(await _open()).path}/$id');

  @override
  Future<void> save(String id, Uint8List bytes) async {
    await (await _file(id)).writeAsBytes(bytes, flush: true);
  }

  @override
  Future<Uint8List?> load(String id) async {
    final file = await _file(id);
    if (!file.existsSync()) return null;
    return file.readAsBytes();
  }

  @override
  Future<void> delete(String id) async {
    final file = await _file(id);
    if (file.existsSync()) await file.delete();
  }
}
