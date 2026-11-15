import 'dart:math';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';

/// Asks a multiplication question before opening the parent area.
///
/// The app is made for children under six, who cannot yet multiply, so this
/// keeps them out of editing and settings without a password to remember.
/// Returns true when the answer was right.
Future<bool> showParentalGate(BuildContext context, Random random) async {
  final a = 3 + random.nextInt(7);
  final b = 3 + random.nextInt(7);
  final passed = await showDialog<bool>(
    context: context,
    builder: (_) => _GateDialog(a: a, b: b),
  );
  return passed ?? false;
}

class _GateDialog extends StatefulWidget {
  const _GateDialog({required this.a, required this.b});

  final int a;
  final int b;

  @override
  State<_GateDialog> createState() => _GateDialogState();
}

class _GateDialogState extends State<_GateDialog> {
  final TextEditingController _answer = TextEditingController();
  final FocusNode _answerFocus = FocusNode();
  bool _wrong = false;

  @override
  void dispose() {
    _answer.dispose();
    _answerFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (int.tryParse(_answer.text) == widget.a * widget.b) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() => _wrong = true);
    _answer.clear();
    // Pressing the button took focus away; put the cursor back so the
    // next attempt can be typed straight away.
    _answerFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.gateTitle),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.gateQuestion(widget.a, widget.b),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _answer,
              focusNode: _answerFocus,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              textInputAction: TextInputAction.done,
              // The default handler closes the keyboard on "done"; keep it
              // open so a wrong answer can be corrected without reopening.
              onEditingComplete: () {},
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: l10n.gateAnswerLabel,
                errorText: _wrong ? l10n.gateWrong : null,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(onPressed: _submit, child: Text(l10n.commonContinue)),
      ],
    );
  }
}
