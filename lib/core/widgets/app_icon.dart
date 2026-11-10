import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Line icons taken from the Thabat design (24×24, stroke = currentColor).
abstract final class AppIcons {
  static const _paths = <String, String>{
    // habit icons
    'water': '<path d="M12 3.5c3 3.6 6 7.1 6 10.5a6 6 0 0 1-12 0c0-3.4 3-6.9 6-10.5z"/>',
    'read': '<path d="M12 6.5C10 5 7 4.5 4 5v13c3-.5 6 0 8 1.5 2-1.5 5-2 8-1.5V5c-3-.5-6 0-8 1.5zM12 6.5v13"/>',
    'gym': '<path d="M6.5 7v10M3.5 9.5v5M17.5 7v10M20.5 9.5v5M6.5 12h11"/>',
    'run': '<circle cx="13" cy="4.5" r="1.8"/><path d="M9 21l2.5-6.5 3 3V21M7.5 12l2.5-4 4 .5 2 3.5 2.5 1M11.5 14.5l1-5.5"/>',
    'family': '<circle cx="9" cy="8" r="3"/><circle cx="17" cy="9.5" r="2.3"/><path d="M3.5 19c.8-3.2 3-4.8 5.5-4.8s4.7 1.6 5.5 4.8M15 14.6c2.6 0 4.6 1.4 5.3 4.4"/>',
    'sleep': '<path d="M19.5 14.5A8 8 0 0 1 9.5 4.5a8 8 0 1 0 10 10z"/>',
    'coffee': '<path d="M4 9h12v5a5 5 0 0 1-5 5H9a5 5 0 0 1-5-5zM16 10h1.5a2.5 2.5 0 0 1 0 5H16M8 3.5v2M12 3.5v2"/>',
    'sun': '<circle cx="12" cy="12" r="4"/><path d="M12 2.5v2M12 19.5v2M2.5 12h2M19.5 12h2M5.3 5.3l1.4 1.4M17.3 17.3l1.4 1.4M5.3 18.7l1.4-1.4M17.3 6.7l1.4-1.4"/>',
    'heart': '<path d="M12 20s-7.5-4.6-7.5-10.2A4.2 4.2 0 0 1 12 7.2a4.2 4.2 0 0 1 7.5 2.6C19.5 15.4 12 20 12 20z"/>',
    'star': '<path d="M12 3l2 6.5L20.5 12 14 14l-2 6.5-2-6.5L3.5 12 10 9.5z"/>',
    'calendar': '<rect x="4" y="5.5" width="16" height="15" rx="2.5"/><path d="M4 10h16M8.5 3.5v4M15.5 3.5v4"/>',
    'target': '<circle cx="12" cy="12" r="8.5"/><circle cx="12" cy="12" r="4.5"/><circle cx="12" cy="12" r="1"/>',
    'smoke': '<rect x="2.5" y="12.5" width="13" height="4" rx="1"/><path d="M18.5 12.5v4M21.5 12.5v4M18.5 9c0-1.8 3-1.8 3-4.5M3 4l18 17"/>',
    'social': '<rect x="6.5" y="2.5" width="11" height="19" rx="2.5"/><path d="M11 18.5h2"/>',
    'food': '<path d="M4 11a8 6 0 0 1 16 0zM3.5 14h17M5 14v1.5A3 3 0 0 0 8 18.5h8a3 3 0 0 0 3-3V14"/>',
    'soda': '<path d="M6 8h12M7 8l1.2 12.2a1.5 1.5 0 0 0 1.5 1.3h4.6a1.5 1.5 0 0 0 1.5-1.3L17 8M12.5 8l1.5-5h3"/>',
    'shield': '<path d="M12 3 5 6v5.5c0 4.5 3 8 7 9.5 4-1.5 7-5 7-9.5V6z"/>',
    'ban': '<circle cx="12" cy="12" r="7.5"/><path d="M6.8 6.8 17.2 17.2"/>',
    // ui icons
    'flame': '<path d="M12 2.5c1 3.2 5 5.5 5 10.5a5 5 0 0 1-10 0c0-2.3 1-3.8 2.3-5 .2 1.8 1 3 2.2 3.4C11 8.6 11 5.2 12 2.5z"/>',
    'check': '<path d="M5 12.5l4.5 4.5L19 7.5"/>',
    'home': '<path d="M4 10.5 12 4l8 6.5V20H4z"/><path d="M10 20v-5h4v5"/>',
    'chart': '<path d="M5 20V11M12 20V5M19 20v-7"/>',
    'plus': '<path d="M12 5v14M5 12h14"/>',
    'minus': '<path d="M5 12h14"/>',
    'award': '<circle cx="12" cy="9" r="5.5"/><path d="M8.5 13.5 7 21l5-2.5 5 2.5-1.5-7.5"/>',
    'profile': '<circle cx="12" cy="8.5" r="3.8"/><path d="M4.5 20c1.2-3.6 4-5.3 7.5-5.3s6.3 1.7 7.5 5.3"/>',
    'skip': '<path d="M5 5.5v13l9-6.5zM18 5.5v13"/>',
    'edit': '<path d="M4 20h4L19 9l-4-4L4 16zM13.5 6.5l4 4"/>',
    'trash': '<path d="M4.5 7h15M9.5 7V4.5h5V7M6.5 7l1 13h9l1-13"/>',
    'undo': '<path d="M4 12a8 8 0 1 0 2.5-5.8M4 4.5v4h4"/>',
    'bell': '<path d="M6 16.5V11a6 6 0 0 1 12 0v5.5l1.5 2H4.5zM10 21h4"/>',
    'moonQuiet': '<path d="M4.5 14.5A8 8 0 0 0 14.5 4.5a8 8 0 1 1-10 10z"/>',
    'back': '<path d="M15 5l-7 7 7 7"/>',
    'forward': '<path d="M9 5l7 7-7 7"/>',
    'share': '<path d="M12 3.5v12M7.5 8 12 3.5 16.5 8M5 13v6.5h14V13"/>',
    'globe': '<circle cx="12" cy="12" r="8.5"/><path d="M3.5 12h17M12 3.5c2.5 2.5 3.5 5.5 3.5 8.5s-1 6-3.5 8.5c-2.5-2.5-3.5-5.5-3.5-8.5s1-6 3.5-8.5z"/>',
    'download': '<path d="M12 4v11M7.5 10.5 12 15l4.5-4.5M5 19.5h14"/>',
    'logout': '<path d="M10 4.5h7.5v15H10M13.5 12H4M7.5 8.5 4 12l3.5 3.5"/>',
    'lock': '<rect x="5" y="10.5" width="14" height="10" rx="2.5"/><path d="M8 10.5V8a4 4 0 0 1 8 0v2.5"/>',
    'clock': '<circle cx="12" cy="12" r="8.5"/><path d="M12 7.5V12l3 2"/>',
    'logo': '<path d="M4.5 19.5h15" stroke-width="2.6"/><path d="M6 15.5l3.5-3 3 2 5-6" stroke-width="2"/><circle cx="17.5" cy="8.5" r="0.8" stroke-width="2.2"/>',
  };

  /// Icons that should mirror in RTL.
  static const directional = {'back', 'forward', 'undo', 'logout'};

  /// Icons offered in the habit editor.
  static const habitIcons = [
    'water', 'read', 'gym', 'run', 'family', 'sleep', 'coffee', 'sun', 'heart', 'star', 'calendar', 'target',
    'smoke', 'social', 'food', 'soda', 'shield', 'ban',
  ];

  static String? path(String name) => _paths[name];
}

String _hex(Color c) => '#${c.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';

class AppIcon extends StatelessWidget {
  const AppIcon(this.name, {super.key, this.size = 24, this.color, this.strokeWidth = 1.8, this.fill});

  final String name;
  final double size;
  final Color? color;
  final double strokeWidth;
  final Color? fill;

  @override
  Widget build(BuildContext context) {
    final c = color ?? IconTheme.of(context).color ?? DefaultTextStyle.of(context).style.color ?? Colors.black;
    final inner = AppIcons.path(name) ?? AppIcons.path('star')!;
    final svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" '
        'fill="${fill == null ? 'none' : _hex(fill!)}" stroke="${_hex(c)}" stroke-width="$strokeWidth" '
        'stroke-linecap="round" stroke-linejoin="round">$inner</svg>';
    Widget w = SvgPicture.string(svg, width: size, height: size, excludeFromSemantics: true);
    if (AppIcons.directional.contains(name) && Directionality.of(context) == TextDirection.rtl) {
      w = Transform.flip(flipX: true, child: w);
    }
    return SizedBox(width: size, height: size, child: w);
  }
}

class GoogleLogo extends StatelessWidget {
  const GoogleLogo({super.key, this.size = 22});
  final double size;
  static const _svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">'
      '<path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"/>'
      '<path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"/>'
      '<path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"/>'
      '<path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"/></svg>';
  @override
  Widget build(BuildContext context) => SvgPicture.string(_svg, width: size, height: size, excludeFromSemantics: true);
}

/// Habit glyph: an `icon:name` line icon or a plain emoji.
class HabitGlyph extends StatelessWidget {
  const HabitGlyph(this.value, {super.key, this.size = 24, this.color});
  final String value;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (value.startsWith('icon:')) {
      return AppIcon(value.substring(5), size: size, color: color);
    }
    return Text(value, style: TextStyle(fontSize: size * .92, height: 1.1), textScaler: TextScaler.noScaling);
  }
}
