import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

import '../core/theme.dart';
import '../data/card_resolver.dart';
import '../state/providers.dart';

/// The picture of a card: bundled artwork or a parent's photo.
class CardArt extends ConsumerWidget {
  const CardArt({super.key, required this.card, required this.size});

  final ResolvedCard card;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asset = card.asset;
    if (asset != null) {
      return SvgPicture.asset(
        asset,
        width: size,
        height: size,
        excludeFromSemantics: true,
      );
    }

    final imageId = card.imageId;
    if (imageId == null) return _Placeholder(size: size);

    final photo = ref.watch(cardImageProvider(imageId));
    final bytes = photo.value;
    if (bytes == null) {
      // Still loading, missing, or unreadable: keep the layout stable.
      return photo.isLoading
          ? SizedBox.square(dimension: size)
          : _Placeholder(size: size);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.22),
      child: Image.memory(
        bytes,
        width: size,
        height: size,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        excludeFromSemantics: true,
        errorBuilder: (_, _, _) => _Placeholder(size: size),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(size * 0.22),
        ),
        child: Icon(
          Icons.image_outlined,
          size: size * 0.5,
          color: AppColors.inkSoft,
        ),
      ),
    );
  }
}
