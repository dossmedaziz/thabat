import '../../../core/l10n/gen/app_localizations.dart';
import '../domain/achievements.dart';

class BadgeInfo {
  const BadgeInfo(this.name, this.description, this.icon, {this.number});
  final String name;
  final String description;
  final String icon;

  /// Small number drawn on the badge (e.g. 7, 21, 30, 100).
  final int? number;
}

BadgeInfo badgeInfo(AppLocalizations l, String id) => switch (id) {
      AchievementIds.firstStep => BadgeInfo(l.badgeFirstStep, l.badgeFirstStepDesc, 'check'),
      AchievementIds.weekComplete => BadgeInfo(l.badgeWeekComplete, l.badgeWeekCompleteDesc, 'calendar', number: 7),
      AchievementIds.perfectWeek => BadgeInfo(l.badgePerfectWeek, l.badgePerfectWeekDesc, 'star'),
      AchievementIds.clean21 => BadgeInfo(l.badgeClean21, l.badgeClean21Desc, 'shield', number: 21),
      AchievementIds.comeback => BadgeInfo(l.badgeComeback, l.badgeComebackDesc, 'undo'),
      AchievementIds.earlyBird => BadgeInfo(l.badgeEarlyBird, l.badgeEarlyBirdDesc, 'sun'),
      AchievementIds.streak30 => BadgeInfo(l.badgeStreak30, l.badgeStreak30Desc, 'flame', number: 30),
      AchievementIds.clean100 => BadgeInfo(l.badgeClean100, l.badgeClean100Desc, 'shield', number: 100),
      _ => BadgeInfo(l.badgeGoalReached, l.badgeGoalReachedDesc, 'target'),
    };

String celebrationTitle(AppLocalizations l, String id) => switch (id) {
      AchievementIds.streak30 => l.celebrateStreak30,
      AchievementIds.clean100 => l.celebrateClean100,
      _ => l.celebrateBadge(badgeInfo(l, id).name),
    };
