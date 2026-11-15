import 'dart:convert';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

import 'image_store.dart';

ImageStore createImageStore() => BrowserImageStore();

/// Base64 strings in browser storage. Only the web preview uses this.
class BrowserImageStore implements ImageStore {
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  String _key(String id) => 'card_image_$id';

  @override
  Future<void> save(String id, Uint8List bytes) =>
      _prefs.setString(_key(id), base64Encode(bytes));

  @override
  Future<Uint8List?> load(String id) async {
    final encoded = await _prefs.getString(_key(id));
    return encoded == null ? null : base64Decode(encoded);
  }

  @override
  Future<void> delete(String id) => _prefs.remove(_key(id));
}
