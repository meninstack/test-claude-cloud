import '../data/models.dart';
import '../l10n/app_localizations.dart';

/// The name to show for a routine: what the parent typed, or a translated
/// default for a starter or still-unnamed routine.
String routineDisplayName(Routine routine, AppLocalizations l10n) {
  final name = routine.name.trim();
  if (name.isNotEmpty) return name;
  return switch (routine.presetKey) {
    'morning' => l10n.presetMorning,
    'evening' => l10n.presetEvening,
    _ => l10n.newRoutine,
  };
}
