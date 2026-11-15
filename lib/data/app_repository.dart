import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

/// Loads and saves the whole [AppData] document on the device.
abstract interface class AppRepository {
  /// Returns null on first launch, or when the stored data cannot be read.
  AppData? load();

  Future<void> save(AppData data);
}

/// Stores [AppData] as one JSON string in the platform key-value store.
///
/// The document is a few kilobytes: routines, card names and one day of
/// progress. Photos live in the image store, not here.
class PrefsAppRepository implements AppRepository {
  PrefsAppRepository(this._prefs);

  static const String storageKey = 'app_data';

  final SharedPreferencesWithCache _prefs;

  static Future<PrefsAppRepository> open() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: {storageKey},
      ),
    );
    return PrefsAppRepository(prefs);
  }

  @override
  AppData? load() {
    final raw = _prefs.getString(storageKey);
    if (raw == null) return null;
    try {
      return AppData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object catch (error) {
      // FormatException from bad JSON, TypeError from an unexpected shape.
      // Starting over beats refusing to open the app.
      debugPrint('Stored app data is unreadable, starting fresh: $error');
      return null;
    }
  }

  @override
  Future<void> save(AppData data) =>
      _prefs.setString(storageKey, jsonEncode(data.toJson()));
}
