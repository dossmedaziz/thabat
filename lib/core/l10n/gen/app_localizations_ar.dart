// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'ثبات';

  @override
  String get appNameLatin => 'Thabat';

  @override
  String get tagline => 'خطوة ثابتة كل يوم';

  @override
  String get continueWithGoogle => 'المتابعة باستخدام Google';

  @override
  String get signInNewHint => 'جديد هنا؟ الزر نفسه ينشئ حسابك.';

  @override
  String get signInPrivacy =>
      'بالمتابعة، أنت توافق على الشروط وسياسة الخصوصية.\nنستخدم فقط اسمك وبريدك الإلكتروني وصورتك.';

  @override
  String get langArabic => 'العربية';

  @override
  String get langEnglish => 'English';

  @override
  String get langFrench => 'Français';

  @override
  String get tabToday => 'اليوم';

  @override
  String get tabProgress => 'التقدم';

  @override
  String get tabAchievements => 'الإنجازات';

  @override
  String get tabProfile => 'حسابي';

  @override
  String get addHabit => 'إضافة عادة';

  @override
  String greetingMorning(String name) {
    return 'صباح الخير، $name';
  }

  @override
  String greetingAfternoon(String name) {
    return 'مساء الخير، $name';
  }

  @override
  String greetingEvening(String name) {
    return 'مساء الخير، $name';
  }

  @override
  String welcomeName(String name) {
    return 'أهلًا بك، $name';
  }

  @override
  String get build => 'أبني';

  @override
  String get avoid => 'أتجنب';

  @override
  String get habitTypeFilter => 'نوع العادات';

  @override
  String get buildHead => 'عادات أبنيها';

  @override
  String get avoidHead => 'عادات أتجنبها';

  @override
  String ringTitle(String done, String total) {
    return '$done من $total مكتملة اليوم';
  }

  @override
  String ringLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عادة متبقية. نقرة واحدة لكل منها.',
      few: '$count عادات متبقية. نقرة واحدة لكل منها.',
      two: 'عادتان متبقيتان. نقرة واحدة لكل منهما.',
      one: 'عادة واحدة متبقية. نقرة واحدة تكفي.',
      zero: 'يوم مثالي. أنجزت كل عاداتك.',
    );
    return '$_temp0';
  }

  @override
  String get ringNothingDue => 'لا عادات مستحقة اليوم. استمتع بيومك.';

  @override
  String doneOf(String done, String total) {
    return '$done من $total مكتملة';
  }

  @override
  String cleanOf(String done, String total) {
    return '$done من $total بدون تعثر';
  }

  @override
  String get freqDaily => 'يومي';

  @override
  String get freqWeekly => 'أسبوعي';

  @override
  String get freqMonthly => 'شهري';

  @override
  String daysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count يوم',
      few: '$count أيام',
      two: 'يومان',
      one: 'يوم واحد',
      zero: '0 يوم',
    );
    return '$_temp0';
  }

  @override
  String weeksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أسبوع',
      few: '$count أسابيع',
      two: 'أسبوعان',
      one: 'أسبوع واحد',
      zero: '0 أسبوع',
    );
    return '$_temp0';
  }

  @override
  String monthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count شهر',
      few: '$count أشهر',
      two: 'شهران',
      one: 'شهر واحد',
      zero: '0 شهر',
    );
    return '$_temp0';
  }

  @override
  String timesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرة',
      few: '$count مرات',
      two: 'مرتان',
      one: 'مرة واحدة',
    );
    return '$_temp0';
  }

  @override
  String daysClean(String days) {
    return '$days بدون';
  }

  @override
  String get freshStart => 'اليوم 0 · بداية جديدة';

  @override
  String get done => 'تم';

  @override
  String get slip => 'تعثرت';

  @override
  String get undo => 'تراجع';

  @override
  String get skip => 'تخطي';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get cancel => 'إلغاء';

  @override
  String get close => 'إغلاق';

  @override
  String weekProgress(String done, String target) {
    return '$done من $target هذا الأسبوع';
  }

  @override
  String monthProgress(String done, String target) {
    return '$done من $target هذا الشهر';
  }

  @override
  String markDoneA11y(String name) {
    return 'تسجيل: $name';
  }

  @override
  String undoA11y(String name) {
    return 'تراجع: $name';
  }

  @override
  String slipConfirmTitle(String name) {
    return 'تعثرت في «$name»؟';
  }

  @override
  String get slipConfirmBody =>
      'لا بأس، هذا يحدث. سيبدأ العد من جديد، وتبقى أيامك السابقة في سجلك.';

  @override
  String get slipConfirmYes => 'نعم، سجّل التعثر';

  @override
  String slippedSnack(String count) {
    return 'سُجّل. أيامك الـ$count السابقة ما زالت تُحسب. اليوم 1 يبدأ الآن.';
  }

  @override
  String get skippedSnack => 'تخطيت اليوم. سلسلتك محفوظة.';

  @override
  String deletedSnack(String name) {
    return 'حُذفت «$name»';
  }

  @override
  String get emptyTitle => 'خطوتك الأولى تبدأ هنا';

  @override
  String get emptyBody =>
      'اختر شيئًا صغيرًا تبنيه، أو عادة تريد تركها. يمكنك إضافة المزيد لاحقًا.';

  @override
  String get emptyCta => 'أنشئ عادتك الأولى';

  @override
  String get emptyOr => 'أو ابدأ بعادة شائعة';

  @override
  String get emptyTabBuild => 'لا عادات تبنيها بعد.';

  @override
  String get emptyTabAvoid => 'لا عادات تتجنبها بعد.';

  @override
  String get newHabit => 'عادة جديدة';

  @override
  String get editHabit => 'تعديل العادة';

  @override
  String get typeGoodTitle => 'عادة أبنيها';

  @override
  String get typeGoodSub => 'شيء أريد فعله بانتظام';

  @override
  String get typeBadTitle => 'عادة أتجنبها';

  @override
  String get typeBadSub => 'شيء أريد التوقف عنه';

  @override
  String get nameLabel => 'الاسم';

  @override
  String get nameHintGood => 'مثال: قراءة 20 دقيقة';

  @override
  String get nameHintBad => 'مثال: المشروبات الغازية';

  @override
  String get nameRequired => 'اكتب اسمًا للعادة';

  @override
  String get nameTooLong => 'الاسم طويل جدًا (40 حرفًا كحد أقصى)';

  @override
  String get iconLabel => 'الأيقونة';

  @override
  String get iconsTab => 'أيقونات';

  @override
  String get emojiTab => 'إيموجي';

  @override
  String get colorLabel => 'اللون';

  @override
  String get colorTeal => 'أخضر مزرق';

  @override
  String get colorBlue => 'أزرق';

  @override
  String get colorPurple => 'بنفسجي';

  @override
  String get colorCoral => 'مرجاني';

  @override
  String get colorAmber => 'كهرماني';

  @override
  String get colorPink => 'وردي';

  @override
  String get frequencyLabel => 'التكرار';

  @override
  String get weeklyTimes => 'عدد مرات في الأسبوع';

  @override
  String get weeklyDays => 'أيام محددة';

  @override
  String get perWeek => 'في الأسبوع';

  @override
  String get perMonth => 'في الشهر';

  @override
  String get pickDaysError => 'اختر يومًا واحدًا على الأقل';

  @override
  String get more => 'أكثر';

  @override
  String get less => 'أقل';

  @override
  String get goalLabel => 'الهدف';

  @override
  String get goalNone => 'بدون';

  @override
  String get goalHelpGood => 'سلسلة تريد الوصول إليها';

  @override
  String get goalHelpBad => 'مدة تريد البقاء فيها بدون تعثر';

  @override
  String get reminderLabel => 'تذكير';

  @override
  String get reminderTime => 'الوقت';

  @override
  String get reminderDays => 'الأيام';

  @override
  String get reminderMessage => 'نص التذكير';

  @override
  String get reminderPreview => 'معاينة الإشعار';

  @override
  String reminderDefaultGood(String name) {
    return 'حان وقت «$name». نقرة واحدة تكفي.';
  }

  @override
  String reminderDefaultBad(String name) {
    return 'كيف حالك مع «$name» اليوم؟ أنت أقوى مما تظن.';
  }

  @override
  String get reminderQuietWarning =>
      'هذا الوقت ضمن ساعات الهدوء، لن يُرسل التذكير.';

  @override
  String get noteLabel => 'لماذا هذه العادة مهمة لي';

  @override
  String get optional => '(اختياري)';

  @override
  String get createHabit => 'إنشاء العادة';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get deleteHabit => 'حذف العادة';

  @override
  String deleteConfirmTitle(String name) {
    return 'حذف «$name»؟';
  }

  @override
  String get deleteConfirmBody => 'سيتم حذف العادة وكل سجلها.';

  @override
  String get permissionDenied =>
      'الإشعارات معطّلة. فعّلها من إعدادات الجهاز لتصلك التذكيرات.';

  @override
  String get everyDay => 'كل يوم';

  @override
  String get wd1 => 'ن';

  @override
  String get wd2 => 'ث';

  @override
  String get wd3 => 'ر';

  @override
  String get wd4 => 'خ';

  @override
  String get wd5 => 'ج';

  @override
  String get wd6 => 'س';

  @override
  String get wd7 => 'ح';

  @override
  String get back => 'رجوع';

  @override
  String get reminderSettingsA11y => 'إعدادات التذكير';

  @override
  String get streakLabelDays => 'أيام متتالية';

  @override
  String get streakLabelWeeks => 'أسابيع متتالية';

  @override
  String get streakLabelMonths => 'أشهر متتالية';

  @override
  String get streakLabelClean => 'أيام بدون';

  @override
  String get bestStreak => 'أفضل سلسلة';

  @override
  String get successRate => 'نسبة النجاح';

  @override
  String get totalCheckins => 'تسجيلات';

  @override
  String get totalCleanDays => 'يوم بدون';

  @override
  String get prevMonth => 'الشهر السابق';

  @override
  String get nextMonth => 'الشهر التالي';

  @override
  String get legendDone => 'تم';

  @override
  String get legendClean => 'بدون';

  @override
  String get legendMissed => 'فائت';

  @override
  String get legendSlipped => 'تعثر';

  @override
  String get legendSkipped => 'تخطي';

  @override
  String get todayLabel => 'اليوم';

  @override
  String goalTitleStreak(String x) {
    return 'الهدف: سلسلة $x';
  }

  @override
  String goalTitleAvoid(String x) {
    return 'الهدف: التجنب لمدة $x';
  }

  @override
  String goalTitleTotal(String x) {
    return 'الهدف: $x إجمالًا';
  }

  @override
  String goalRemaining(String x) {
    return 'بقي $x للوصول إلى هدفك. الليلة تُحسب.';
  }

  @override
  String get goalReachedMsg => 'وصلت إلى هدفك! خطوة ثابتة بعد خطوة.';

  @override
  String get noGoal => 'لا هدف بعد. أضف هدفًا لتتابع تقدمك.';

  @override
  String get addGoal => 'أضف هدفًا';

  @override
  String get recentActivity => 'النشاط الأخير';

  @override
  String get historyClean => 'يوم بدون';

  @override
  String historyLoggedAt(String time) {
    return 'سُجّل الساعة $time';
  }

  @override
  String get historySlipNote => 'بداية جديدة في الصباح التالي.';

  @override
  String get historyMissNote => 'يحدث ذلك. ابدأ من جديد اليوم.';

  @override
  String get noHistory => 'لا نشاط بعد.';

  @override
  String get filterLabel => 'تصفية';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterGood => 'جيدة';

  @override
  String get filterBad => 'سيئة';

  @override
  String get cardTotalHabits => 'إجمالي العادات';

  @override
  String get cardGoodHabits => 'عادات أبنيها';

  @override
  String get cardBadHabits => 'عادات أتجنبها';

  @override
  String get cardLongestStreak => 'أطول سلسلة';

  @override
  String get cardLongestClean => 'أطول فترة بدون';

  @override
  String get cardDaysClean => 'أيام بدون';

  @override
  String get cardCheckins => 'تسجيلات';

  @override
  String get cardCompletion => 'نسبة الإنجاز';

  @override
  String get cardCommitment => 'نسبة الالتزام';

  @override
  String noteSplit(String good, String bad) {
    return '$good أبنيها · $bad أتجنبها';
  }

  @override
  String get noteCurrentRuns => 'مجموع الفترات الحالية';

  @override
  String get noteThisMonth => 'هذا الشهر';

  @override
  String get noteLast30 => 'آخر 30 يومًا';

  @override
  String get last7Days => 'آخر 7 أيام';

  @override
  String get average => 'المتوسط';

  @override
  String get monthlyCompletion => 'الإنجاز الشهري';

  @override
  String trendPoints(String delta, String month) {
    return '$delta نقطة منذ $month';
  }

  @override
  String get noData => 'لا بيانات بعد. سجّل عاداتك وسيظهر تقدمك هنا.';

  @override
  String unlockedCount(String n, String total) {
    return '$n من $total مفتوحة';
  }

  @override
  String nextBadge(String name) {
    return 'التالي: $name';
  }

  @override
  String get allUnlocked => 'فتحت كل الشارات! 🎉';

  @override
  String get unlockedSection => 'مفتوحة';

  @override
  String get lockedSection => 'مقفلة';

  @override
  String unlockedOn(String date) {
    return 'فُتحت في $date';
  }

  @override
  String get lockedA11y => 'مقفلة';

  @override
  String get badgeFirstStep => 'أول خطوة';

  @override
  String get badgeFirstStepDesc => 'سجّل أول عادة لك.';

  @override
  String get badgeWeekComplete => 'أسبوع كامل';

  @override
  String get badgeWeekCompleteDesc => '7 أيام متتالية لعادة يومية.';

  @override
  String get badgePerfectWeek => 'أسبوع مثالي';

  @override
  String get badgePerfectWeekDesc => 'أنجز كل عاداتك المستحقة لأسبوع كامل.';

  @override
  String get badgeClean21 => '3 أسابيع بدون';

  @override
  String get badgeClean21Desc => '21 يومًا دون تعثر في عادة تتجنبها.';

  @override
  String get badgeComeback => 'العودة بقوة';

  @override
  String get badgeComebackDesc => '7 أيام بدون مجددًا بعد تعثر.';

  @override
  String get badgeEarlyBird => 'صباح مبكر';

  @override
  String get badgeEarlyBirdDesc => '5 تسجيلات قبل 8 ص.';

  @override
  String get badgeStreak30 => '30 يوم ثبات';

  @override
  String get badgeStreak30Desc => 'سلسلة 30 يومًا لعادة يومية.';

  @override
  String get badgeClean100 => '100 يوم بدون';

  @override
  String get badgeClean100Desc => '100 يوم دون تعثر في عادة تتجنبها.';

  @override
  String get badgeGoalReached => 'الهدف تحقق';

  @override
  String get badgeGoalReachedDesc => 'حقق أي هدف وضعته لعادة.';

  @override
  String get celebrateStreak30 => 'مبروك! 30 يوم من الثبات 🎉';

  @override
  String get celebrateClean100 => 'مبروك! 100 يوم بدون 🎉';

  @override
  String celebrateBadge(String name) {
    return 'مبروك! شارة «$name» 🎉';
  }

  @override
  String celebrateGoal(String name) {
    return 'مبروك! حققت هدف «$name» 🎉';
  }

  @override
  String get celebrateBody => 'هذه عادة حقيقية تتكوّن، خطوة ثابتة بعد خطوة.';

  @override
  String get share => 'مشاركة';

  @override
  String get continueBtn => 'متابعة';

  @override
  String shareText(String badge) {
    return 'حققت «$badge» في ثبات. خطوة ثابتة كل يوم.';
  }

  @override
  String get remindersTitle => 'التذكيرات';

  @override
  String remindersActive(String on, String total) {
    return '$on من $total مفعّلة';
  }

  @override
  String get streakRiskTitle => 'تنبيه السلسلة في خطر';

  @override
  String streakRiskSub(String time) {
    return '$time إذا بقيت عادة يومية دون تسجيل';
  }

  @override
  String get quietHours => 'ساعات الهدوء';

  @override
  String quietSub(String start, String end) {
    return '$start – $end · لا يُرسل أي إشعار';
  }

  @override
  String get quietOff => 'متوقفة';

  @override
  String get scheduledReminders => 'التذكيرات المجدولة';

  @override
  String get noReminders =>
      'لا تذكيرات بعد. فعّل تذكيرًا من شاشة تعديل العادة.';

  @override
  String get notificationsOffBanner => 'الإشعارات متوقفة من الإعدادات.';

  @override
  String toggleReminderA11y(String name) {
    return 'تذكير $name';
  }

  @override
  String get streakRiskNotifTitle => 'سلسلتك في خطر 🔥';

  @override
  String streakRiskNotifBody(String name) {
    return 'لم تسجّل «$name» اليوم بعد. نقرة واحدة تحفظ سلسلتك.';
  }

  @override
  String get channelReminders => 'تذكيرات العادات';

  @override
  String get channelStreak => 'تنبيهات السلسلة';

  @override
  String get profileTitle => 'حسابي';

  @override
  String daysWithUs(String days) {
    return '$days معنا';
  }

  @override
  String habitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عادة',
      few: '$count عادات',
      two: 'عادتان',
      one: 'عادة واحدة',
      zero: '0 عادات',
    );
    return '$_temp0';
  }

  @override
  String badgesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count شارة',
      few: '$count شارات',
      two: 'شارتان',
      one: 'شارة واحدة',
      zero: '0 شارات',
    );
    return '$_temp0';
  }

  @override
  String get sectionLanguage => 'اللغة';

  @override
  String get appLanguage => 'لغة التطبيق';

  @override
  String get sectionNotifications => 'الإشعارات';

  @override
  String get notifications => 'الإشعارات';

  @override
  String activeCount(String n) {
    return '$n مفعّلة';
  }

  @override
  String get sectionPreferences => 'التفضيلات';

  @override
  String get weekStart => 'بداية الأسبوع';

  @override
  String get monday => 'الاثنين';

  @override
  String get saturday => 'السبت';

  @override
  String get sunday => 'الأحد';

  @override
  String get appearance => 'المظهر';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeSystem => 'تلقائي';

  @override
  String get sectionData => 'بياناتك';

  @override
  String get exportData => 'تصدير البيانات JSON';

  @override
  String get exportSubject => 'بيانات ثبات';

  @override
  String get exportFailed => 'تعذّر التصدير.';

  @override
  String get seedData => 'إضافة بيانات تجريبية';

  @override
  String get seedDone => 'أُضيفت العادات التجريبية.';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get deleteAccountTitle => 'حذف الحساب؟';

  @override
  String get deleteAccountBody =>
      'سيتم حذف حسابك وكل عاداتك وسجلاتك وشاراتك نهائيًا. لا يمكن التراجع عن ذلك.';

  @override
  String get deleteAccountConfirm => 'احذف نهائيًا';

  @override
  String versionLine(String version) {
    return 'ثبات $version · الشروط · الخصوصية';
  }

  @override
  String get quietStart => 'من';

  @override
  String get quietEnd => 'إلى';

  @override
  String get languageTitle => 'اختيار اللغة';

  @override
  String get languageHint => 'يتغير اتجاه التطبيق تلقائيًا حسب اللغة.';

  @override
  String get streakRiskTime => 'وقت التنبيه';

  @override
  String get loading => 'جارٍ التحميل…';

  @override
  String get errorGeneric => 'حدث خطأ. حاول مرة أخرى.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get habitNotFound => 'لم نجد هذه العادة.';

  @override
  String get am => 'ص';

  @override
  String get pm => 'م';

  @override
  String get seedWater => 'شرب الماء';

  @override
  String get seedRead => 'قراءة 20 دقيقة';

  @override
  String get seedGym => 'الرياضة';

  @override
  String get seedFamily => 'زيارة العائلة';

  @override
  String get seedSmoke => 'التدخين';

  @override
  String get seedSocial => 'الإفراط في وسائل التواصل';

  @override
  String get seedFastFood => 'الوجبات السريعة';

  @override
  String get seedSoda => 'المشروبات الغازية';

  @override
  String get seedWaterMsg => 'كوب ماء؟ جسمك يشكرك.';

  @override
  String get seedReadMsg => 'استرخِ مع 20 دقيقة من القراءة.';

  @override
  String get seedGymMsg => 'يوم الرياضة! جسمك جاهز.';

  @override
  String get seedSocialMsg => 'كيف كان وقت الشاشة اليوم؟';

  @override
  String get seedReadNote => 'القراءة تهدئ ذهني قبل النوم.';

  @override
  String get deleteAccountFailed =>
      'تعذّر حذف الحساب. تحقق من اتصالك بالإنترنت وحاول مجددًا.';

  @override
  String get signedInWithGoogle => 'مسجّل الدخول عبر Google';

  @override
  String get signInFailed => 'تعذّر تسجيل الدخول. حاول مرة أخرى.';

  @override
  String get signInNetwork =>
      'لا يوجد اتصال بالإنترنت. تسجيل الدخول يحتاج إلى اتصال.';

  @override
  String get signInNotConfigured =>
      'تسجيل الدخول عبر Google غير مُعدّ بعد في هذه النسخة.';

  @override
  String pendingSync(String count) {
    return '$count تغييرات بانتظار المزامنة';
  }

  @override
  String get syncedAll => 'كل بياناتك محفوظة في السحابة';

  @override
  String get notifAllowed => 'الإشعارات مسموحة';

  @override
  String get notifBlocked =>
      'الإشعارات محظورة لتطبيق ثبات، لذلك لن تصلك التذكيرات.';

  @override
  String get allowNotifications => 'السماح بالإشعارات';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String get exactAlarmsOff =>
      'قد تتأخر التذكيرات بضع دقائق. فعّل التوقيت الدقيق لتصلك في الدقيقة نفسها.';

  @override
  String get exactAlarmsAllow => 'تفعيل التوقيت الدقيق';

  @override
  String get testNotification => 'إرسال إشعار تجريبي';

  @override
  String get testNotificationTitle => 'ثبات 🔔';

  @override
  String get testNotificationBody => 'الإشعارات تعمل. ستصلك تذكيراتك في وقتها.';

  @override
  String scheduledCount(String count) {
    return '$count إشعارات مجدولة على هذا الجهاز';
  }

  @override
  String get continueWithEmail => 'المتابعة بالبريد الإلكتروني';

  @override
  String get orDivider => 'أو';

  @override
  String get emailTitle => 'الدخول بالبريد الإلكتروني';

  @override
  String get emailSubtitle =>
      'سنرسل لك رمز تحقق. إن لم يكن لديك حساب، سننشئه لك تلقائيًا.';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get emailInvalid => 'اكتب بريدًا إلكترونيًا صحيحًا';

  @override
  String get sendCode => 'إرسال الرمز';

  @override
  String get codeTitle => 'أدخل رمز التحقق';

  @override
  String codeSentTo(String email) {
    return 'أرسلنا رمزًا إلى $email. إن لم تجده، تحقق من مجلد الرسائل غير المرغوب فيها.';
  }

  @override
  String get codeLabel => 'رمز التحقق';

  @override
  String get codeRequired => 'اكتب الرمز الذي وصلك';

  @override
  String get verifyCode => 'تأكيد والدخول';

  @override
  String get resendCode => 'إعادة إرسال الرمز';

  @override
  String resendIn(String seconds) {
    return 'إعادة الإرسال بعد $seconds ث';
  }

  @override
  String get changeEmail => 'تغيير البريد';

  @override
  String get codeResent => 'أرسلنا رمزًا جديدًا.';

  @override
  String get codeInvalid => 'الرمز غير صحيح أو انتهت صلاحيته.';

  @override
  String get codeRateLimited => 'طلبات كثيرة. انتظر قليلًا ثم حاول مجددًا.';

  @override
  String get emailNotAuthorized =>
      'تعذّر إرسال الرمز إلى هذا البريد حاليًا. جرّب لاحقًا أو استخدم Google.';

  @override
  String get signedInWithEmail => 'مسجّل الدخول بالبريد الإلكتروني';

  @override
  String get todayProgress => 'تقدّم اليوم';

  @override
  String ofTotal(String total) {
    return 'من $total';
  }

  @override
  String get allDoneToday => 'أنجزت كل عادات اليوم';

  @override
  String get colorGreen => 'أخضر';

  @override
  String get colorOrange => 'برتقالي';

  @override
  String get colorRed => 'أحمر';

  @override
  String get colorYellow => 'أصفر';
}
