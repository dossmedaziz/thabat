import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Google profile photo, or the first letter of the name on the design's peach circle.
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.name, this.photoUrl, this.size = 44, this.ring = false});
  final String name;
  final String? photoUrl;
  final double size;
  final bool ring;

  @override
  Widget build(BuildContext context) {
    final initial = Text(
      name.isEmpty ? '?' : name.characters.first.toUpperCase(),
      style: TextStyle(color: const Color(0xFF4A2614), fontWeight: FontWeight.w700, fontSize: size * .4),
    );
    final url = photoUrl;
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFE9B38F),
        shape: BoxShape.circle,
        border: ring ? Border.all(color: context.colors.card, width: 3) : null,
      ),
      child: url == null || url.isEmpty
          ? initial
          : Image.network(
              url,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => initial,
              loadingBuilder: (_, child, progress) => progress == null ? child : initial,
            ),
    );
  }
}
