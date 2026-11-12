// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Thabat';

  @override
  String get appNameLatin => 'ثبات';

  @override
  String get tagline => 'One steady step every day';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get signInNewHint => 'New here? The same button creates your account.';

  @override
  String get signInPrivacy =>
      'By continuing you agree to the Terms and Privacy Policy.\nWe only use your name, email and photo.';

  @override
  String get langArabic => 'العربية';

  @override
  String get langEnglish => 'English';

  @override
  String get langFrench => 'Français';

  @override
  String get tabToday => 'Today';

  @override
  String get tabProgress => 'Progress';

  @override
  String get tabAchievements => 'Awards';

  @override
  String get tabProfile => 'Profile';

  @override
  String get addHabit => 'Add habit';

  @override
  String greetingMorning(String name) {
    return 'Good morning, $name';
  }

  @override
  String greetingAfternoon(String name) {
    return 'Good afternoon, $name';
  }

  @override
  String greetingEvening(String name) {
    return 'Good evening, $name';
  }

  @override
  String welcomeName(String name) {
    return 'Welcome, $name';
  }

  @override
  String get build => 'Build';

  @override
  String get avoid => 'Avoid';

  @override
  String get habitTypeFilter => 'Habit type';

  @override
  String get buildHead => 'Habits I’m building';

  @override
  String get avoidHead => 'Habits I’m avoiding';

  @override
  String ringTitle(String done, String total) {
    return '$done of $total done today';
  }

  @override
  String ringLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count habits left. One tap each.',
      one: '1 habit left. One tap is enough.',
      zero: 'Perfect day. Every habit checked.',
    );
    return '$_temp0';
  }

  @override
  String get ringNothingDue => 'Nothing due today. Enjoy your day.';

  @override
  String doneOf(String done, String total) {
    return '$done of $total done';
  }

  @override
  String cleanOf(String done, String total) {
    return '$done of $total on track';
  }

  @override
  String get freqDaily => 'Daily';

  @override
  String get freqWeekly => 'Weekly';

  @override
  String get freqMonthly => 'Monthly';

  @override
  String daysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String weeksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks',
      one: '1 week',
    );
    return '$_temp0';
  }

  @override
  String monthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months',
      one: '1 month',
    );
    return '$_temp0';
  }

  @override
  String timesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count times',
      two: 'twice',
      one: 'once',
    );
    return '$_temp0';
  }

  @override
  String daysClean(String days) {
    return '$days clean';
  }

  @override
  String get freshStart => 'Day 0 · fresh start';

  @override
  String get done => 'Done';

  @override
  String get slip => 'I slipped';

  @override
  String get undo => 'Undo';

  @override
  String get skip => 'Skip';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String weekProgress(String done, String target) {
    return '$done of $target this week';
  }

  @override
  String monthProgress(String done, String target) {
    return '$done of $target this month';
  }

  @override
  String markDoneA11y(String name) {
    return 'Mark done: $name';
  }

  @override
  String undoA11y(String name) {
    return 'Undo: $name';
  }

  @override
  String slipConfirmTitle(String name) {
    return 'Slipped on “$name”?';
  }

  @override
  String get slipConfirmBody =>
      'That’s okay, it happens. The counter restarts and your past days stay in your history.';

  @override
  String get slipConfirmYes => 'Yes, log it';

  @override
  String slippedSnack(String count) {
    return 'Logged. Your $count days still count. Day 1 starts now.';
  }

  @override
  String get skippedSnack => 'Skipped today. Your streak is safe.';

  @override
  String deletedSnack(String name) {
    return 'Deleted “$name”';
  }

  @override
  String get emptyTitle => 'Your first step starts here';

  @override
  String get emptyBody =>
      'Pick something small to build, or a habit to quit. You can add more later.';

  @override
  String get emptyCta => 'Create your first habit';

  @override
  String get emptyOr => 'Or start with a popular one';

  @override
  String get emptyTabBuild => 'No habits to build yet.';

  @override
  String get emptyTabAvoid => 'No habits to avoid yet.';

  @override
  String get newHabit => 'New habit';

  @override
  String get editHabit => 'Edit habit';

  @override
  String get typeGoodTitle => 'Build a habit';

  @override
  String get typeGoodSub => 'Something I want to do regularly';

  @override
  String get typeBadTitle => 'Avoid a habit';

  @override
  String get typeBadSub => 'Something I want to stop';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameHintGood => 'e.g. Read 20 minutes';

  @override
  String get nameHintBad => 'e.g. Soft drinks';

  @override
  String get nameRequired => 'Give your habit a name';

  @override
  String get nameTooLong => 'Name is too long (max 40 characters)';

  @override
  String get iconLabel => 'Icon';

  @override
  String get iconsTab => 'Icons';

  @override
  String get emojiTab => 'Emoji';

  @override
  String get colorLabel => 'Color';

  @override
  String get colorTeal => 'Teal';

  @override
  String get colorBlue => 'Blue';

  @override
  String get colorPurple => 'Purple';

  @override
  String get colorCoral => 'Coral';

  @override
  String get colorAmber => 'Amber';

  @override
  String get colorPink => 'Pink';

  @override
  String get frequencyLabel => 'Frequency';

  @override
  String get weeklyTimes => 'Times per week';

  @override
  String get weeklyDays => 'Specific days';

  @override
  String get perWeek => 'per week';

  @override
  String get perMonth => 'per month';

  @override
  String get pickDaysError => 'Pick at least one day';

  @override
  String get more => 'More';

  @override
  String get less => 'Less';

  @override
  String get goalLabel => 'Goal';

  @override
  String get goalNone => 'None';

  @override
  String get goalHelpGood => 'A streak you want to reach';

  @override
  String get goalHelpBad => 'How long you want to stay clean';

  @override
  String get reminderLabel => 'Reminder';

  @override
  String get reminderTime => 'Time';

  @override
  String get reminderDays => 'Days';

  @override
  String get reminderMessage => 'Reminder message';

  @override
  String get reminderPreview => 'Notification preview';

  @override
  String reminderDefaultGood(String name) {
    return 'Time for “$name”. One tap is enough.';
  }

  @override
  String reminderDefaultBad(String name) {
    return 'How is “$name” going today? You’re stronger than you think.';
  }

  @override
  String get reminderQuietWarning =>
      'This time is within quiet hours; it won’t be sent.';

  @override
  String get noteLabel => 'Why this habit matters to me';

  @override
  String get optional => '(optional)';

  @override
  String get createHabit => 'Create habit';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get deleteHabit => 'Delete habit';

  @override
  String deleteConfirmTitle(String name) {
    return 'Delete “$name”?';
  }

  @override
  String get deleteConfirmBody =>
      'The habit and its whole history will be deleted.';

  @override
  String get permissionDenied =>
      'Notifications are off. Enable them in system settings to get reminders.';

  @override
  String get everyDay => 'Every day';

  @override
  String get wd1 => 'M';

  @override
  String get wd2 => 'T';

  @override
  String get wd3 => 'W';

  @override
  String get wd4 => 'T';

  @override
  String get wd5 => 'F';

  @override
  String get wd6 => 'S';

  @override
  String get wd7 => 'S';

  @override
  String get back => 'Back';

  @override
  String get reminderSettingsA11y => 'Reminder settings';

  @override
  String get streakLabelDays => 'days in a row';

  @override
  String get streakLabelWeeks => 'weeks in a row';

  @override
  String get streakLabelMonths => 'months in a row';

  @override
  String get streakLabelClean => 'days clean';

  @override
  String get bestStreak => 'Best streak';

  @override
  String get successRate => 'Success rate';

  @override
  String get totalCheckins => 'Check-ins';

  @override
  String get totalCleanDays => 'clean days';

  @override
  String get prevMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get legendDone => 'Done';

  @override
  String get legendClean => 'Clean';

  @override
  String get legendMissed => 'Missed';

  @override
  String get legendSlipped => 'Slipped';

  @override
  String get legendSkipped => 'Skipped';

  @override
  String get todayLabel => 'Today';

  @override
  String goalTitleStreak(String x) {
    return 'Goal: $x streak';
  }

  @override
  String goalTitleAvoid(String x) {
    return 'Goal: avoid for $x';
  }

  @override
  String goalTitleTotal(String x) {
    return 'Goal: $x in total';
  }

  @override
  String goalRemaining(String x) {
    return '$x to go. Tonight counts.';
  }

  @override
  String get goalReachedMsg => 'Goal reached! One steady step after another.';

  @override
  String get noGoal => 'No goal yet. Add one to track your progress.';

  @override
  String get addGoal => 'Add a goal';

  @override
  String get recentActivity => 'Recent activity';

  @override
  String get historyClean => 'Clean day';

  @override
  String historyLoggedAt(String time) {
    return 'Logged at $time';
  }

  @override
  String get historySlipNote => 'A fresh start the next morning.';

  @override
  String get historyMissNote => 'It happens. Start again today.';

  @override
  String get noHistory => 'No activity yet.';

  @override
  String get filterLabel => 'Filter';

  @override
  String get filterAll => 'All';

  @override
  String get filterGood => 'Good';

  @override
  String get filterBad => 'Bad';

  @override
  String get cardTotalHabits => 'Total habits';

  @override
  String get cardGoodHabits => 'Habits I build';

  @override
  String get cardBadHabits => 'Habits I avoid';

  @override
  String get cardLongestStreak => 'Longest streak';

  @override
  String get cardLongestClean => 'Longest clean run';

  @override
  String get cardDaysClean => 'Days clean';

  @override
  String get cardCheckins => 'Check-ins';

  @override
  String get cardCompletion => 'Completion';

  @override
  String get cardCommitment => 'Commitment';

  @override
  String noteSplit(String good, String bad) {
    return '$good build · $bad avoid';
  }

  @override
  String get noteCurrentRuns => 'Sum of current runs';

  @override
  String get noteThisMonth => 'This month';

  @override
  String get noteLast30 => 'Last 30 days';

  @override
  String get last7Days => 'Last 7 days';

  @override
  String get average => 'Average';

  @override
  String get monthlyCompletion => 'Monthly completion';

  @override
  String trendPoints(String delta, String month) {
    return '$delta pts since $month';
  }

  @override
  String get noData => 'No data yet. Check in and your progress shows here.';

  @override
  String unlockedCount(String n, String total) {
    return '$n of $total unlocked';
  }

  @override
  String nextBadge(String name) {
    return 'Next: $name';
  }

  @override
  String get allUnlocked => 'Every badge unlocked! 🎉';

  @override
  String get unlockedSection => 'Unlocked';

  @override
  String get lockedSection => 'Locked';

  @override
  String unlockedOn(String date) {
    return 'Unlocked on $date';
  }

  @override
  String get lockedA11y => 'locked';

  @override
  String get badgeFirstStep => 'First step';

  @override
  String get badgeFirstStepDesc => 'Log your very first check-in.';

  @override
  String get badgeWeekComplete => 'Full week';

  @override
  String get badgeWeekCompleteDesc => '7 days in a row on a daily habit.';

  @override
  String get badgePerfectWeek => 'Perfect week';

  @override
  String get badgePerfectWeekDesc =>
      'Complete every due habit for a whole week.';

  @override
  String get badgeClean21 => '3 weeks clean';

  @override
  String get badgeClean21Desc =>
      '21 days without slipping on a habit you avoid.';

  @override
  String get badgeComeback => 'Comeback';

  @override
  String get badgeComebackDesc => '7 clean days again after a slip.';

  @override
  String get badgeEarlyBird => 'Early bird';

  @override
  String get badgeEarlyBirdDesc => '5 check-ins before 8 AM.';

  @override
  String get badgeStreak30 => '30-day streak';

  @override
  String get badgeStreak30Desc => 'A 30-day streak on a daily habit.';

  @override
  String get badgeClean100 => '100 days clean';

  @override
  String get badgeClean100Desc =>
      '100 days without slipping on a habit you avoid.';

  @override
  String get badgeGoalReached => 'Goal reached';

  @override
  String get badgeGoalReachedDesc => 'Reach any goal you set for a habit.';

  @override
  String get celebrateStreak30 => 'Congrats! 30 days of steadiness 🎉';

  @override
  String get celebrateClean100 => 'Congrats! 100 days clean 🎉';

  @override
  String celebrateBadge(String name) {
    return 'Congrats! “$name” unlocked 🎉';
  }

  @override
  String celebrateGoal(String name) {
    return 'Congrats! Goal reached for “$name” 🎉';
  }

  @override
  String get celebrateBody =>
      'A real habit is forming, one steady step after another.';

  @override
  String get share => 'Share';

  @override
  String get continueBtn => 'Continue';

  @override
  String shareText(String badge) {
    return 'I just earned “$badge” on Thabat. One steady step every day.';
  }

  @override
  String get remindersTitle => 'Reminders';

  @override
  String remindersActive(String on, String total) {
    return '$on of $total on';
  }

  @override
  String get streakRiskTitle => 'Streak-at-risk alert';

  @override
  String streakRiskSub(String time) {
    return '$time if a daily habit is still unchecked';
  }

  @override
  String get quietHours => 'Quiet hours';

  @override
  String quietSub(String start, String end) {
    return '$start – $end · no notifications';
  }

  @override
  String get quietOff => 'Off';

  @override
  String get scheduledReminders => 'Scheduled reminders';

  @override
  String get noReminders =>
      'No reminders yet. Turn one on from a habit’s edit screen.';

  @override
  String get notificationsOffBanner =>
      'Notifications are turned off in Settings.';

  @override
  String toggleReminderA11y(String name) {
    return 'Reminder for $name';
  }

  @override
  String get streakRiskNotifTitle => 'Your streak is at risk 🔥';

  @override
  String streakRiskNotifBody(String name) {
    return 'You haven’t checked “$name” today. One tap keeps your streak.';
  }

  @override
  String get channelReminders => 'Habit reminders';

  @override
  String get channelStreak => 'Streak alerts';

  @override
  String get profileTitle => 'Profile';

  @override
  String daysWithUs(String days) {
    return '$days with us';
  }

  @override
  String habitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count habits',
      one: '1 habit',
    );
    return '$_temp0';
  }

  @override
  String badgesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count badges',
      one: '1 badge',
    );
    return '$_temp0';
  }

  @override
  String get sectionLanguage => 'Language';

  @override
  String get appLanguage => 'App language';

  @override
  String get sectionNotifications => 'Notifications';

  @override
  String get notifications => 'Notifications';

  @override
  String activeCount(String n) {
    return '$n on';
  }

  @override
  String get sectionPreferences => 'Preferences';

  @override
  String get weekStart => 'Week starts on';

  @override
  String get monday => 'Monday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'Auto';

  @override
  String get sectionData => 'Your data';

  @override
  String get exportData => 'Export data (JSON)';

  @override
  String get exportSubject => 'Thabat data';

  @override
  String get exportFailed => 'Export failed.';

  @override
  String get seedData => 'Add sample data';

  @override
  String get seedDone => 'Sample habits added.';

  @override
  String get signOut => 'Sign out';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountTitle => 'Delete account?';

  @override
  String get deleteAccountBody =>
      'Your account and all your habits, history and badges will be permanently deleted. This cannot be undone.';

  @override
  String get deleteAccountConfirm => 'Delete permanently';

  @override
  String versionLine(String version) {
    return 'Thabat $version · Terms · Privacy';
  }

  @override
  String get quietStart => 'From';

  @override
  String get quietEnd => 'To';

  @override
  String get languageTitle => 'Choose language';

  @override
  String get languageHint => 'The layout direction follows the language.';

  @override
  String get streakRiskTime => 'Alert time';

  @override
  String get loading => 'Loading…';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get retry => 'Retry';

  @override
  String get habitNotFound => 'Habit not found.';

  @override
  String get am => 'AM';

  @override
  String get pm => 'PM';

  @override
  String get seedWater => 'Drink water';

  @override
  String get seedRead => 'Read 20 min';

  @override
  String get seedGym => 'Exercise';

  @override
  String get seedFamily => 'Visit family';

  @override
  String get seedSmoke => 'Smoking';

  @override
  String get seedSocial => 'Too much social media';

  @override
  String get seedFastFood => 'Fast food';

  @override
  String get seedSoda => 'Soft drinks';

  @override
  String get seedWaterMsg => 'A glass of water? Your body thanks you.';

  @override
  String get seedReadMsg => 'Unwind with 20 minutes of reading.';

  @override
  String get seedGymMsg => 'Workout day! You’ve got this.';

  @override
  String get seedSocialMsg => 'How was screen time today?';

  @override
  String get seedReadNote => 'Reading calms my mind before sleep.';

  @override
  String get deleteAccountFailed =>
      'Couldn’t delete the account. Check your connection and try again.';

  @override
  String get signedInWithGoogle => 'Signed in with Google';

  @override
  String get signInFailed => 'Sign-in failed. Please try again.';

  @override
  String get signInNetwork =>
      'No internet connection. Signing in needs a connection.';

  @override
  String get signInNotConfigured =>
      'Google sign-in isn’t configured in this build yet.';

  @override
  String pendingSync(String count) {
    return '$count changes waiting to sync';
  }

  @override
  String get syncedAll => 'All your data is saved to the cloud';

  @override
  String get notifAllowed => 'Notifications are allowed';

  @override
  String get notifBlocked =>
      'Notifications are blocked for Thabat, so reminders can’t reach you.';

  @override
  String get allowNotifications => 'Allow notifications';

  @override
  String get openSettings => 'Open settings';

  @override
  String get exactAlarmsOff =>
      'Reminders may arrive a few minutes late. Turn on exact timing to get them on the minute.';

  @override
  String get exactAlarmsAllow => 'Turn on exact timing';

  @override
  String get testNotification => 'Send a test notification';

  @override
  String get testNotificationTitle => 'Thabat 🔔';

  @override
  String get testNotificationBody =>
      'Notifications work. Your reminders will arrive on time.';

  @override
  String scheduledCount(String count) {
    return '$count notifications scheduled on this device';
  }

  @override
  String get continueWithEmail => 'Continue with email';

  @override
  String get orDivider => 'or';

  @override
  String get emailTitle => 'Sign in with email';

  @override
  String get emailSubtitle =>
      'We’ll email you a verification code. If you don’t have an account yet, we’ll create one.';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailInvalid => 'Enter a valid email address';

  @override
  String get sendCode => 'Send code';

  @override
  String get codeTitle => 'Enter the code';

  @override
  String codeSentTo(String email) {
    return 'We sent a code to $email. If you can’t find it, check your spam folder.';
  }

  @override
  String get codeLabel => '6-digit code';

  @override
  String get codeRequired => 'Enter the 6-digit code';

  @override
  String get verifyCode => 'Verify and sign in';

  @override
  String get resendCode => 'Resend code';

  @override
  String resendIn(String seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get changeEmail => 'Change email';

  @override
  String get codeResent => 'We sent a new code.';

  @override
  String get codeInvalid => 'That code is wrong or has expired.';

  @override
  String get codeRateLimited =>
      'Too many attempts. Wait a little and try again.';

  @override
  String get emailNotAuthorized =>
      'We can’t send a code to this address right now. Try later or use Google.';

  @override
  String get signedInWithEmail => 'Signed in with email';

  @override
  String get todayProgress => 'Today’s progress';

  @override
  String ofTotal(String total) {
    return 'of $total';
  }

  @override
  String get allDoneToday => 'Every habit done today';

  @override
  String get colorGreen => 'Green';

  @override
  String get colorOrange => 'Orange';

  @override
  String get colorRed => 'Red';

  @override
  String get colorYellow => 'Yellow';
}
