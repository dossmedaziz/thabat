import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n_x.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/common.dart';
import '../../habits/application/habits_controller.dart';
import '../domain/achievements.dart';
import 'badge_info.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l = context.l10n;
    if (!ref.watch(appDataControllerProvider).hasValue) return const Scaffold(body: LoadingView());
    final unlocked = ref.watch(unlockedAchievementsProvider);
    final progress = ref.watch(achievementProgressProvider);
    final open = AchievementIds.all.where(unlocked.containsKey).toList();
    final locked = AchievementIds.all.where((id) => !unlocked.containsKey(id)).toList()
      ..sort((a, b) => progress[b]!.ratio.compareTo(progress[a]!.ratio));
    final next = locked.isEmpty ? null : locked.first;
    final total = AchievementIds.all.length;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 32),
          children: [
            Text(l.tabAchievements, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, height: 1.4)),
            const SizedBox(height: 14),
            AppCard(
              padding: const EdgeInsetsDirectional.fromSTEB(18, 16, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text.rich(TextSpan(children: [
                    TextSpan(text: '${open.length}', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: c.goldText)),
                    TextSpan(
                      text: ' ${l.unlockedCount('', '$total').trim()}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ])),
                  Text(next == null ? l.allUnlocked : l.nextBadge(badgeInfo(l, next).name), style: TextStyle(fontSize: 13, color: c.sub)),
                  const SizedBox(height: 12),
                  DirectionalBar(value: open.length / total, color: c.gold, track: c.track),
                ],
              ),
            ),
            if (open.isNotEmpty) ...[
              const SizedBox(height: 18),
              SectionTitle(l.unlockedSection),
              const SizedBox(height: 10),
              _Grid(children: [
                for (final id in open)
                  _BadgeTile(id: id, unlockedAt: unlocked[id], progress: progress[id]!),
              ]),
            ],
            if (locked.isNotEmpty) ...[
              const SizedBox(height: 18),
              SectionTitle(l.lockedSection),
              const SizedBox(height: 10),
              _Grid(children: [
                for (final id in locked) _BadgeTile(id: id, progress: progress[id]!),
              ]),
            ],
          ],
        ),
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, box) {
        const gap = 10.0;
        final w = (box.maxWidth - gap * 2) / 3;
        return Wrap(spacing: gap, runSpacing: gap, children: [for (final c in children) SizedBox(width: w, child: c)]);
      });
}

class BadgeMedal extends StatelessWidget {
  const BadgeMedal({super.key, required this.id, required this.unlocked, this.size = 64});
  final String id;
  final bool unlocked;
  final double size;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final info = badgeInfo(context.l10n, id);
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: unlocked ? c.goldSoft : c.lockBg,
              shape: BoxShape.circle,
              border: Border.all(color: unlocked ? c.gold : Colors.transparent, width: 3),
            ),
            alignment: Alignment.center,
            child: info.number != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppIcon(info.icon, size: size * .32, color: unlocked ? c.goldText : c.lockIcon, strokeWidth: 2),
                      Text('${info.number}',
                          style: TextStyle(fontFamily: kLatinFont, fontSize: size * .2, height: 1.1, fontWeight: FontWeight.w700, color: unlocked ? c.goldText : c.lockIcon)),
                    ],
                  )
                : AppIcon(info.icon, size: size * .44, color: unlocked ? c.goldText : c.lockIcon, strokeWidth: 2),
          ),
          if (!unlocked)
            PositionedDirectional(
              end: -2,
              bottom: -2,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(color: c.card, shape: BoxShape.circle, border: Border.all(color: c.bg, width: 2)),
                alignment: Alignment.center,
                child: AppIcon('lock', size: 12, color: c.lockIcon, strokeWidth: 2.6),
              ),
            ),
        ],
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.id, required this.progress, this.unlockedAt});
  final String id;
  final AchievementProgress progress;
  final DateTime? unlockedAt;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final info = badgeInfo(l, id);
    final unlocked = unlockedAt != null;
    final sub = unlocked
        ? (progress.habitName ?? l.shortDate(unlockedAt!))
        : (progress.target > 1 ? '${progress.current} / ${progress.target}' : info.description);
    return Semantics(
      button: true,
      label: '${info.name}${unlocked ? '' : '، ${l.lockedA11y}'}',
      child: AppCard(
        color: unlocked ? c.card : c.chip,
        padding: const EdgeInsetsDirectional.fromSTEB(8, 14, 8, 12),
        onTap: () => _showDetails(context, info, unlocked),
        child: Column(
          children: [
            BadgeMedal(id: id, unlocked: unlocked, size: 60),
            const SizedBox(height: 8),
            Text(info.name, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: unlocked ? c.text : c.sub)),
            const SizedBox(height: 2),
            Directionality(
              textDirection: !unlocked && progress.target > 1 ? TextDirection.ltr : Directionality.of(context),
              child: Text(sub, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: c.sub)),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, BadgeInfo info, bool unlocked) {
    final c = context.colors;
    final l = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BadgeMedal(id: id, unlocked: unlocked, size: 96),
              const SizedBox(height: 14),
              Text(info.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(info.description, textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: c.sub)),
              const SizedBox(height: 14),
              if (unlocked)
                Text(l.unlockedOn(l.fullDate(unlockedAt!)), style: TextStyle(fontWeight: FontWeight.w600, color: c.goldText))
              else if (progress.target > 1) ...[
                DirectionalBar(value: progress.ratio, color: c.gold, track: c.track),
                const SizedBox(height: 6),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text('${progress.current} / ${progress.target}', style: TextStyle(fontWeight: FontWeight.w700, color: c.sub)),
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.pop(ctx), child: Text(l.close))),
            ],
          ),
        ),
      ),
    );
  }
}
