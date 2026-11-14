import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../services/photo_picker.dart';
import '../../state/app_controller.dart';

/// Dialog where a parent makes a card from a photo and a name.
class CustomCardEditor extends ConsumerStatefulWidget {
  const CustomCardEditor({super.key});

  @override
  ConsumerState<CustomCardEditor> createState() => _CustomCardEditorState();
}

class _CustomCardEditorState extends ConsumerState<CustomCardEditor> {
  final TextEditingController _name = TextEditingController();
  Uint8List? _photo;
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _pick(PhotoSource source) async {
    final l10n = AppLocalizations.of(context);
    try {
      final bytes = await ref.read(photoPickerProvider)(source);
      if (bytes == null || !mounted) return;
      setState(() {
        _photo = bytes;
        _error = null;
      });
    } on Exception {
      // Camera unavailable, permission refused, or an unreadable file.
      if (mounted) setState(() => _error = l10n.photoError);
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final photo = _photo;
    final name = _name.text.trim();
    if (photo == null) {
      setState(() => _error = l10n.cardNeedsPhoto);
      return;
    }
    if (name.isEmpty) {
      setState(() => _error = l10n.cardNeedsName);
      return;
    }
    setState(() => _saving = true);
    try {
      await ref
          .read(appControllerProvider.notifier)
          .addCustomCard(label: name, imageBytes: photo);
    } on Exception {
      // Writing the photo to the device failed, e.g. storage is full.
      if (mounted) {
        setState(() {
          _saving = false;
          _error = l10n.photoError;
        });
      }
      return;
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final photo = _photo;
    final error = _error;

    return AlertDialog(
      title: Text(l10n.newCard),
      content: SizedBox(
        width: 340,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: SizedBox.square(
                  dimension: 150,
                  child: photo == null
                      ? ColoredBox(
                          color: cardTint(null),
                          child: const Icon(
                            Icons.add_a_photo_rounded,
                            size: 52,
                            color: AppColors.inkSoft,
                          ),
                        )
                      : Image.memory(
                          photo,
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                          errorBuilder: (_, _, _) => ColoredBox(
                            color: cardTint(null),
                            child: const Icon(Icons.broken_image_rounded),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: _saving ? null : () => _pick(PhotoSource.camera),
                    icon: const Icon(Icons.photo_camera_rounded),
                    label: Text(l10n.takePhoto),
                  ),
                  OutlinedButton.icon(
                    onPressed: _saving
                        ? null
                        : () => _pick(PhotoSource.gallery),
                    icon: const Icon(Icons.photo_library_rounded),
                    label: Text(l10n.choosePhoto),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _name,
                maxLength: 30,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(labelText: l10n.cardNameLabel),
              ),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    error,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}
