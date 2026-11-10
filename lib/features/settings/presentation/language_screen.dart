import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_x.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/common.dart';
import '../application/settings_controller.dart';
import 'settings_screen.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l = context.l10n;
    final cur = ref.watch(settingsControllerProvider).locale;
    const samples = {'ar': 'خطوة ثابتة كل يوم', 'en': 'One steady step every day', 'fr': 'Un pas régulier chaque jour'};
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 32),
          children: [
            Row(children: [
              RoundIconButton(icon: 'back', tooltip: l.back, onTap: () => context.canPop() ? context.pop() : context.go(Routes.profile)),
            ]),
            const SizedBox(height: 12),
            Text(l.languageTitle, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, height: 1.4)),
            Text(l.languageHint, style: TextStyle(fontSize: 14, color: c.sub)),
            const SizedBox(height: 16),
            for (final code in supportedLanguages)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Semantics(
                  selected: code == cur,
                  child: AppCard(
                    onTap: () => ref.read(settingsControllerProvider.notifier).setLocale(code),
                    padding: const EdgeInsetsDirectional.fromSTEB(18, 14, 18, 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(languageName(context, code), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                              Directionality(
                                textDirection: code == 'ar' ? TextDirection.rtl : TextDirection.ltr,
                                child: Text(samples[code]!, style: TextStyle(fontSize: 13, color: c.sub)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: code == cur ? c.good : Colors.transparent,
                            border: Border.all(color: code == cur ? c.good : c.line, width: 2),
                          ),
                          child: code == cur ? Center(child: AppIcon('check', size: 14, color: c.onGood, strokeWidth: 3)) : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
