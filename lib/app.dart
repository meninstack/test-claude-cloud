import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'core/theme.dart';
import 'features/child/child_home_screen.dart';
import 'l10n/app_localizations.dart';
import 'state/app_controller.dart';

class LittleStepsApp extends ConsumerStatefulWidget {
  const LittleStepsApp({super.key});

  @override
  ConsumerState<LittleStepsApp> createState() => _LittleStepsAppState();
}

class _LittleStepsAppState extends ConsumerState<LittleStepsApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // A tablet left on the kitchen counter overnight comes back the next
    // morning with yesterday's stars; clear them as soon as it wakes.
    if (state == AppLifecycleState.resumed) {
      ref.read(appControllerProvider.notifier).refreshDay();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeCode = ref.watch(
      appControllerProvider.select((data) => data.localeCode),
    );

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      locale: localeCode == null ? null : Locale(localeCode),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      // The board is laid out for large type already; very large system
      // font settings would push card names out of their tiles.
      builder: (context, child) =>
          MediaQuery.withClampedTextScaling(maxScaleFactor: 1.3, child: child!),
      home: const ChildHomeScreen(),
    );
  }
}
