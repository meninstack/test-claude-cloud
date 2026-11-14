import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'app.dart';
import 'core/licenses.dart';
import 'data/app_repository.dart';
import 'state/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerAssetLicenses();

  // Opened before the first frame so the board never flashes empty.
  final repository = await PrefsAppRepository.open();

  runApp(
    ProviderScope(
      overrides: [appRepositoryProvider.overrideWithValue(repository)],
      child: const LittleStepsApp(),
    ),
  );
}
