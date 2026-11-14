import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Reads card names aloud.
abstract interface class SpeechService {
  /// Speaks [text], cutting off anything still being spoken.
  Future<void> speak(String text, {required String languageCode});

  Future<void> stop();
}

/// Uses the device's own text-to-speech engine, so no audio files ship with
/// the app and every supported language works without recordings.
class DeviceSpeechService implements SpeechService {
  final FlutterTts _tts = FlutterTts();
  String? _language;
  bool _configured = false;

  static String _voiceLocale(String languageCode) =>
      languageCode == 'vi' ? 'vi-VN' : 'en-US';

  @override
  Future<void> speak(String text, {required String languageCode}) async {
    try {
      if (!_configured) {
        // Slightly slower than the default so young children can follow.
        await _tts.setSpeechRate(0.45);
        _configured = true;
      }
      final language = _voiceLocale(languageCode);
      if (language != _language) {
        await _tts.setLanguage(language);
        _language = language;
      }
      await _tts.stop();
      await _tts.speak(text);
    } on Exception catch (error) {
      // A device without a voice for this language should stay usable; the
      // picture and the written name still carry the meaning.
      debugPrint('Text-to-speech failed: $error');
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _tts.stop();
    } on Exception catch (error) {
      debugPrint('Text-to-speech stop failed: $error');
    }
  }
}

/// Says nothing. Used by tests.
class SilentSpeechService implements SpeechService {
  final List<String> spoken = [];

  @override
  Future<void> speak(String text, {required String languageCode}) async {
    spoken.add(text);
  }

  @override
  Future<void> stop() async {}
}
