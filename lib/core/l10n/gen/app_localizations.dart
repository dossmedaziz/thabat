import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In ar, this message translates to:
  /// **'ثبات'**
  String get appName;

  /// No description provided for @appNameLatin.
  ///
  /// In ar, this message translates to:
  /// **'Thabat'**
  String get appNameLatin;

  /// No description provided for @tagline.
  ///
  /// In ar, this message translates to:
  /// **'خطوة ثابتة كل يوم'**
  String get tagline;

  /// No description provided for @continueWithGoogle.
  ///
  /// In ar, this message translates to:
  /// **'المتابعة باستخدام Google'**
  String get continueWithGoogle;

  /// No description provided for @signInNewHint.
  ///
  /// In ar, this message translates to:
  /// **'جديد هنا؟ الزر نفسه ينشئ حسابك.'**
  String get signInNewHint;

  /// No description provided for @signInPrivacy.
  ///
  /// In ar, this message translates to:
  /// **'بالمتابعة، أنت توافق على الشروط وسياسة الخصوصية.\nنستخدم فقط اسمك وبريدك الإلكتروني وصورتك.'**
  String get signInPrivacy;

  /// No description provided for @langArabic.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get langArabic;

  /// No description provided for @langEnglish.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langFrench.
  ///
  /// In ar, this message translates to:
  /// **'Français'**
  String get langFrench;

  /// No description provided for @tabToday.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get tabToday;

  /// No description provided for @tabProgress.
  ///
  /// In ar, this message translates to:
  /// **'التقدم'**
  String get tabProgress;

  /// No description provided for @tabAchievements.
  ///
  /// In ar, this message translates to:
  /// **'الإنجازات'**
  String get tabAchievements;

  /// No description provided for @tabProfile.
  ///
  /// In ar, this message translates to:
  /// **'حسابي'**
  String get tabProfile;

  /// No description provided for @addHabit.
  ///
  /// In ar, this message translates to:
  /// **'إضافة عادة'**
  String get addHabit;

  /// No description provided for @greetingMorning.
  ///
  /// In ar, this message translates to:
  /// **'صباح الخير، {name}'**
  String greetingMorning(String name);

  /// No description provided for @greetingAfternoon.
  ///
  /// In ar, this message translates to:
  /// **'مساء الخير، {name}'**
  String greetingAfternoon(String name);

  /// No description provided for @greetingEvening.
  ///
  /// In ar, this message translates to:
  /// **'مساء الخير، {name}'**
  String greetingEvening(String name);

  /// No description provided for @welcomeName.
  ///
  /// In ar, this message translates to:
  /// **'أهلًا بك، {name}'**
  String welcomeName(String name);

  /// No description provided for @build.
  ///
  /// In ar, this message translates to:
  /// **'أبني'**
  String get build;

  /// No description provided for @avoid.
  ///
  /// In ar, this message translates to:
  /// **'أتجنب'**
  String get avoid;

  /// No description provided for @habitTypeFilter.
  ///
  /// In ar, this message translates to:
  /// **'نوع العادات'**
  String get habitTypeFilter;

  /// No description provided for @buildHead.
  ///
  /// In ar, this message translates to:
  /// **'عادات أبنيها'**
  String get buildHead;

  /// No description provided for @avoidHead.
  ///
  /// In ar, this message translates to:
  /// **'عادات أتجنبها'**
  String get avoidHead;

  /// No description provided for @ringTitle.
  ///
  /// In ar, this message translates to:
  /// **'{done} من {total} مكتملة اليوم'**
  String ringTitle(String done, String total);

  /// No description provided for @ringLeft.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{يوم مثالي. أنجزت كل عاداتك.} =1{عادة واحدة متبقية. نقرة واحدة تكفي.} =2{عادتان متبقيتان. نقرة واحدة لكل منهما.} few{{count} عادات متبقية. نقرة واحدة لكل منها.} other{{count} عادة متبقية. نقرة واحدة لكل منها.}}'**
  String ringLeft(int count);

  /// No description provided for @ringNothingDue.
  ///
  /// In ar, this message translates to:
  /// **'لا عادات مستحقة اليوم. استمتع بيومك.'**
  String get ringNothingDue;

  /// No description provided for @doneOf.
  ///
  /// In ar, this message translates to:
  /// **'{done} من {total} مكتملة'**
  String doneOf(String done, String total);

  /// No description provided for @cleanOf.
  ///
  /// In ar, this message translates to:
  /// **'{done} من {total} بدون تعثر'**
  String cleanOf(String done, String total);

  /// No description provided for @freqDaily.
  ///
  /// In ar, this message translates to:
  /// **'يومي'**
  String get freqDaily;

  /// No description provided for @freqWeekly.
  ///
  /// In ar, this message translates to:
  /// **'أسبوعي'**
  String get freqWeekly;

  /// No description provided for @freqMonthly.
  ///
  /// In ar, this message translates to:
  /// **'شهري'**
  String get freqMonthly;

  /// No description provided for @daysCount.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{0 يوم} =1{يوم واحد} =2{يومان} few{{count} أيام} other{{count} يوم}}'**
  String daysCount(int count);

  /// No description provided for @weeksCount.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{0 أسبوع} =1{أسبوع واحد} =2{أسبوعان} few{{count} أسابيع} other{{count} أسبوع}}'**
  String weeksCount(int count);

  /// No description provided for @monthsCount.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{0 شهر} =1{شهر واحد} =2{شهران} few{{count} أشهر} other{{count} شهر}}'**
  String monthsCount(int count);

  /// No description provided for @timesCount.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{مرة واحدة} =2{مرتان} few{{count} مرات} other{{count} مرة}}'**
  String timesCount(int count);

  /// No description provided for @daysClean.
  ///
  /// In ar, this message translates to:
  /// **'{days} بدون'**
  String daysClean(String days);

  /// No description provided for @freshStart.
  ///
  /// In ar, this message translates to:
  /// **'اليوم 0 · بداية جديدة'**
  String get freshStart;

  /// No description provided for @done.
  ///
  /// In ar, this message translates to:
  /// **'تم'**
  String get done;

  /// No description provided for @slip.
  ///
  /// In ar, this message translates to:
  /// **'تعثرت'**
  String get slip;

  /// No description provided for @undo.
  ///
  /// In ar, this message translates to:
  /// **'تراجع'**
  String get undo;

  /// No description provided for @skip.
  ///
  /// In ar, this message translates to:
  /// **'تخطي'**
  String get skip;

  /// No description provided for @edit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق'**
  String get close;

  /// No description provided for @weekProgress.
  ///
  /// In ar, this message translates to:
  /// **'{done} من {target} هذا الأسبوع'**
  String weekProgress(String done, String target);

  /// No description provided for @monthProgress.
  ///
  /// In ar, this message translates to:
  /// **'{done} من {target} هذا الشهر'**
  String monthProgress(String done, String target);

  /// No description provided for @markDoneA11y.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل: {name}'**
  String markDoneA11y(String name);

  /// No description provided for @undoA11y.
  ///
  /// In ar, this message translates to:
  /// **'تراجع: {name}'**
  String undoA11y(String name);

  /// No description provided for @slipConfirmTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعثرت في «{name}»؟'**
  String slipConfirmTitle(String name);

  /// No description provided for @slipConfirmBody.
  ///
  /// In ar, this message translates to:
  /// **'لا بأس، هذا يحدث. سيبدأ العد من جديد، وتبقى أيامك السابقة في سجلك.'**
  String get slipConfirmBody;

  /// No description provided for @slipConfirmYes.
  ///
  /// In ar, this message translates to:
  /// **'نعم، سجّل التعثر'**
  String get slipConfirmYes;

  /// No description provided for @slippedSnack.
  ///
  /// In ar, this message translates to:
  /// **'سُجّل. أيامك الـ{count} السابقة ما زالت تُحسب. اليوم 1 يبدأ الآن.'**
  String slippedSnack(String count);

  /// No description provided for @skippedSnack.
  ///
  /// In ar, this message translates to:
  /// **'تخطيت اليوم. سلسلتك محفوظة.'**
  String get skippedSnack;

  /// No description provided for @deletedSnack.
  ///
  /// In ar, this message translates to:
  /// **'حُذفت «{name}»'**
  String deletedSnack(String name);

  /// No description provided for @emptyTitle.
  ///
  /// In ar, this message translates to:
  /// **'خطوتك الأولى تبدأ هنا'**
  String get emptyTitle;

  /// No description provided for @emptyBody.
  ///
  /// In ar, this message translates to:
  /// **'اختر شيئًا صغيرًا تبنيه، أو عادة تريد تركها. يمكنك إضافة المزيد لاحقًا.'**
  String get emptyBody;

  /// No description provided for @emptyCta.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ عادتك الأولى'**
  String get emptyCta;

  /// No description provided for @emptyOr.
  ///
  /// In ar, this message translates to:
  /// **'أو ابدأ بعادة شائعة'**
  String get emptyOr;

  /// No description provided for @emptyTabBuild.
  ///
  /// In ar, this message translates to:
  /// **'لا عادات تبنيها بعد.'**
  String get emptyTabBuild;

  /// No description provided for @emptyTabAvoid.
  ///
  /// In ar, this message translates to:
  /// **'لا عادات تتجنبها بعد.'**
  String get emptyTabAvoid;

  /// No description provided for @newHabit.
  ///
  /// In ar, this message translates to:
  /// **'عادة جديدة'**
  String get newHabit;

  /// No description provided for @editHabit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل العادة'**
  String get editHabit;

  /// No description provided for @typeGoodTitle.
  ///
  /// In ar, this message translates to:
  /// **'عادة أبنيها'**
  String get typeGoodTitle;

  /// No description provided for @typeGoodSub.
  ///
  /// In ar, this message translates to:
  /// **'شيء أريد فعله بانتظام'**
  String get typeGoodSub;

  /// No description provided for @typeBadTitle.
  ///
  /// In ar, this message translates to:
  /// **'عادة أتجنبها'**
  String get typeBadTitle;

  /// No description provided for @typeBadSub.
  ///
  /// In ar, this message translates to:
  /// **'شيء أريد التوقف عنه'**
  String get typeBadSub;

  /// No description provided for @nameLabel.
  ///
  /// In ar, this message translates to:
  /// **'الاسم'**
  String get nameLabel;

  /// No description provided for @nameHintGood.
  ///
  /// In ar, this message translates to:
  /// **'مثال: قراءة 20 دقيقة'**
  String get nameHintGood;

  /// No description provided for @nameHintBad.
  ///
  /// In ar, this message translates to:
  /// **'مثال: المشروبات الغازية'**
  String get nameHintBad;

  /// No description provided for @nameRequired.
  ///
  /// In ar, this message translates to:
  /// **'اكتب اسمًا للعادة'**
  String get nameRequired;

  /// No description provided for @nameTooLong.
  ///
  /// In ar, this message translates to:
  /// **'الاسم طويل جدًا (40 حرفًا كحد أقصى)'**
  String get nameTooLong;

  /// No description provided for @iconLabel.
  ///
  /// In ar, this message translates to:
  /// **'الأيقونة'**
  String get iconLabel;

  /// No description provided for @iconsTab.
  ///
  /// In ar, this message translates to:
  /// **'أيقونات'**
  String get iconsTab;

  /// No description provided for @emojiTab.
  ///
  /// In ar, this message translates to:
  /// **'إيموجي'**
  String get emojiTab;

  /// No description provided for @colorLabel.
  ///
  /// In ar, this message translates to:
  /// **'اللون'**
  String get colorLabel;

  /// No description provided for @colorTeal.
  ///
  /// In ar, this message translates to:
  /// **'أخضر مزرق'**
  String get colorTeal;

  /// No description provided for @colorBlue.
  ///
  /// In ar, this message translates to:
  /// **'أزرق'**
  String get colorBlue;

  /// No description provided for @colorPurple.
  ///
  /// In ar, this message translates to:
  /// **'بنفسجي'**
  String get colorPurple;

  /// No description provided for @colorCoral.
  ///
  /// In ar, this message translates to:
  /// **'مرجاني'**
  String get colorCoral;

  /// No description provided for @colorAmber.
  ///
  /// In ar, this message translates to:
  /// **'كهرماني'**
  String get colorAmber;

  /// No description provided for @colorPink.
  ///
  /// In ar, this message translates to:
  /// **'وردي'**
  String get colorPink;

  /// No description provided for @frequencyLabel.
  ///
  /// In ar, this message translates to:
  /// **'التكرار'**
  String get frequencyLabel;

  /// No description provided for @weeklyTimes.
  ///
  /// In ar, this message translates to:
  /// **'عدد مرات في الأسبوع'**
  String get weeklyTimes;

  /// No description provided for @weeklyDays.
  ///
  /// In ar, this message translates to:
  /// **'أيام محددة'**
  String get weeklyDays;

  /// No description provided for @perWeek.
  ///
  /// In ar, this message translates to:
  /// **'في الأسبوع'**
  String get perWeek;

  /// No description provided for @perMonth.
  ///
  /// In ar, this message translates to:
  /// **'في الشهر'**
  String get perMonth;

  /// No description provided for @pickDaysError.
  ///
  /// In ar, this message translates to:
  /// **'اختر يومًا واحدًا على الأقل'**
  String get pickDaysError;

  /// No description provided for @more.
  ///
  /// In ar, this message translates to:
  /// **'أكثر'**
  String get more;

  /// No description provided for @less.
  ///
  /// In ar, this message translates to:
  /// **'أقل'**
  String get less;

  /// No description provided for @goalLabel.
  ///
  /// In ar, this message translates to:
  /// **'الهدف'**
  String get goalLabel;

  /// No description provided for @goalNone.
  ///
  /// In ar, this message translates to:
  /// **'بدون'**
  String get goalNone;

  /// No description provided for @goalHelpGood.
  ///
  /// In ar, this message translates to:
  /// **'سلسلة تريد الوصول إليها'**
  String get goalHelpGood;

  /// No description provided for @goalHelpBad.
  ///
  /// In ar, this message translates to:
  /// **'مدة تريد البقاء فيها بدون تعثر'**
  String get goalHelpBad;

  /// No description provided for @reminderLabel.
  ///
  /// In ar, this message translates to:
  /// **'تذكير'**
  String get reminderLabel;

  /// No description provided for @reminderTime.
  ///
  /// In ar, this message translates to:
  /// **'الوقت'**
  String get reminderTime;

  /// No description provided for @reminderDays.
  ///
  /// In ar, this message translates to:
  /// **'الأيام'**
  String get reminderDays;

  /// No description provided for @reminderMessage.
  ///
  /// In ar, this message translates to:
  /// **'نص التذكير'**
  String get reminderMessage;

  /// No description provided for @reminderPreview.
  ///
  /// In ar, this message translates to:
  /// **'معاينة الإشعار'**
  String get reminderPreview;

  /// No description provided for @reminderDefaultGood.
  ///
  /// In ar, this message translates to:
  /// **'حان وقت «{name}». نقرة واحدة تكفي.'**
  String reminderDefaultGood(String name);

  /// No description provided for @reminderDefaultBad.
  ///
  /// In ar, this message translates to:
  /// **'كيف حالك مع «{name}» اليوم؟ أنت أقوى مما تظن.'**
  String reminderDefaultBad(String name);

  /// No description provided for @reminderQuietWarning.
  ///
  /// In ar, this message translates to:
  /// **'هذا الوقت ضمن ساعات الهدوء، لن يُرسل التذكير.'**
  String get reminderQuietWarning;

  /// No description provided for @noteLabel.
  ///
  /// In ar, this message translates to:
  /// **'لماذا هذه العادة مهمة لي'**
  String get noteLabel;

  /// No description provided for @optional.
  ///
  /// In ar, this message translates to:
  /// **'(اختياري)'**
  String get optional;

  /// No description provided for @createHabit.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء العادة'**
  String get createHabit;

  /// No description provided for @saveChanges.
  ///
  /// In ar, this message translates to:
  /// **'حفظ التغييرات'**
  String get saveChanges;

  /// No description provided for @deleteHabit.
  ///
  /// In ar, this message translates to:
  /// **'حذف العادة'**
  String get deleteHabit;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف «{name}»؟'**
  String deleteConfirmTitle(String name);

  /// No description provided for @deleteConfirmBody.
  ///
  /// In ar, this message translates to:
  /// **'سيتم حذف العادة وكل سجلها.'**
  String get deleteConfirmBody;

  /// No description provided for @permissionDenied.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات معطّلة. فعّلها من إعدادات الجهاز لتصلك التذكيرات.'**
  String get permissionDenied;

  /// No description provided for @everyDay.
  ///
  /// In ar, this message translates to:
  /// **'كل يوم'**
  String get everyDay;

  /// No description provided for @wd1.
  ///
  /// In ar, this message translates to:
  /// **'ن'**
  String get wd1;

  /// No description provided for @wd2.
  ///
  /// In ar, this message translates to:
  /// **'ث'**
  String get wd2;

  /// No description provided for @wd3.
  ///
  /// In ar, this message translates to:
  /// **'ر'**
  String get wd3;

  /// No description provided for @wd4.
  ///
  /// In ar, this message translates to:
  /// **'خ'**
  String get wd4;

  /// No description provided for @wd5.
  ///
  /// In ar, this message translates to:
  /// **'ج'**
  String get wd5;

  /// No description provided for @wd6.
  ///
  /// In ar, this message translates to:
  /// **'س'**
  String get wd6;

  /// No description provided for @wd7.
  ///
  /// In ar, this message translates to:
  /// **'ح'**
  String get wd7;

  /// No description provided for @back.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get back;

  /// No description provided for @reminderSettingsA11y.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات التذكير'**
  String get reminderSettingsA11y;

  /// No description provided for @streakLabelDays.
  ///
  /// In ar, this message translates to:
  /// **'أيام متتالية'**
  String get streakLabelDays;

  /// No description provided for @streakLabelWeeks.
  ///
  /// In ar, this message translates to:
  /// **'أسابيع متتالية'**
  String get streakLabelWeeks;

  /// No description provided for @streakLabelMonths.
  ///
  /// In ar, this message translates to:
  /// **'أشهر متتالية'**
  String get streakLabelMonths;

  /// No description provided for @streakLabelClean.
  ///
  /// In ar, this message translates to:
  /// **'أيام بدون'**
  String get streakLabelClean;

  /// No description provided for @bestStreak.
  ///
  /// In ar, this message translates to:
  /// **'أفضل سلسلة'**
  String get bestStreak;

  /// No description provided for @successRate.
  ///
  /// In ar, this message translates to:
  /// **'نسبة النجاح'**
  String get successRate;

  /// No description provided for @totalCheckins.
  ///
  /// In ar, this message translates to:
  /// **'تسجيلات'**
  String get totalCheckins;

  /// No description provided for @totalCleanDays.
  ///
  /// In ar, this message translates to:
  /// **'يوم بدون'**
  String get totalCleanDays;

  /// No description provided for @prevMonth.
  ///
  /// In ar, this message translates to:
  /// **'الشهر السابق'**
  String get prevMonth;

  /// No description provided for @nextMonth.
  ///
  /// In ar, this message translates to:
  /// **'الشهر التالي'**
  String get nextMonth;

  /// No description provided for @legendDone.
  ///
  /// In ar, this message translates to:
  /// **'تم'**
  String get legendDone;

  /// No description provided for @legendClean.
  ///
  /// In ar, this message translates to:
  /// **'بدون'**
  String get legendClean;

  /// No description provided for @legendMissed.
  ///
  /// In ar, this message translates to:
  /// **'فائت'**
  String get legendMissed;

  /// No description provided for @legendSlipped.
  ///
  /// In ar, this message translates to:
  /// **'تعثر'**
  String get legendSlipped;

  /// No description provided for @legendSkipped.
  ///
  /// In ar, this message translates to:
  /// **'تخطي'**
  String get legendSkipped;

  /// No description provided for @todayLabel.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get todayLabel;

  /// No description provided for @goalTitleStreak.
  ///
  /// In ar, this message translates to:
  /// **'الهدف: سلسلة {x}'**
  String goalTitleStreak(String x);

  /// No description provided for @goalTitleAvoid.
  ///
  /// In ar, this message translates to:
  /// **'الهدف: التجنب لمدة {x}'**
  String goalTitleAvoid(String x);

  /// No description provided for @goalTitleTotal.
  ///
  /// In ar, this message translates to:
  /// **'الهدف: {x} إجمالًا'**
  String goalTitleTotal(String x);

  /// No description provided for @goalRemaining.
  ///
  /// In ar, this message translates to:
  /// **'بقي {x} للوصول إلى هدفك. الليلة تُحسب.'**
  String goalRemaining(String x);

  /// No description provided for @goalReachedMsg.
  ///
  /// In ar, this message translates to:
  /// **'وصلت إلى هدفك! خطوة ثابتة بعد خطوة.'**
  String get goalReachedMsg;

  /// No description provided for @noGoal.
  ///
  /// In ar, this message translates to:
  /// **'لا هدف بعد. أضف هدفًا لتتابع تقدمك.'**
  String get noGoal;

  /// No description provided for @addGoal.
  ///
  /// In ar, this message translates to:
  /// **'أضف هدفًا'**
  String get addGoal;

  /// No description provided for @recentActivity.
  ///
  /// In ar, this message translates to:
  /// **'النشاط الأخير'**
  String get recentActivity;

  /// No description provided for @historyClean.
  ///
  /// In ar, this message translates to:
  /// **'يوم بدون'**
  String get historyClean;

  /// No description provided for @historyLoggedAt.
  ///
  /// In ar, this message translates to:
  /// **'سُجّل الساعة {time}'**
  String historyLoggedAt(String time);

  /// No description provided for @historySlipNote.
  ///
  /// In ar, this message translates to:
  /// **'بداية جديدة في الصباح التالي.'**
  String get historySlipNote;

  /// No description provided for @historyMissNote.
  ///
  /// In ar, this message translates to:
  /// **'يحدث ذلك. ابدأ من جديد اليوم.'**
  String get historyMissNote;

  /// No description provided for @noHistory.
  ///
  /// In ar, this message translates to:
  /// **'لا نشاط بعد.'**
  String get noHistory;

  /// No description provided for @filterLabel.
  ///
  /// In ar, this message translates to:
  /// **'تصفية'**
  String get filterLabel;

  /// No description provided for @filterAll.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get filterAll;

  /// No description provided for @filterGood.
  ///
  /// In ar, this message translates to:
  /// **'جيدة'**
  String get filterGood;

  /// No description provided for @filterBad.
  ///
  /// In ar, this message translates to:
  /// **'سيئة'**
  String get filterBad;

  /// No description provided for @cardTotalHabits.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي العادات'**
  String get cardTotalHabits;

  /// No description provided for @cardGoodHabits.
  ///
  /// In ar, this message translates to:
  /// **'عادات أبنيها'**
  String get cardGoodHabits;

  /// No description provided for @cardBadHabits.
  ///
  /// In ar, this message translates to:
  /// **'عادات أتجنبها'**
  String get cardBadHabits;

  /// No description provided for @cardLongestStreak.
  ///
  /// In ar, this message translates to:
  /// **'أطول سلسلة'**
  String get cardLongestStreak;

  /// No description provided for @cardLongestClean.
  ///
  /// In ar, this message translates to:
  /// **'أطول فترة بدون'**
  String get cardLongestClean;

  /// No description provided for @cardDaysClean.
  ///
  /// In ar, this message translates to:
  /// **'أيام بدون'**
  String get cardDaysClean;

  /// No description provided for @cardCheckins.
  ///
  /// In ar, this message translates to:
  /// **'تسجيلات'**
  String get cardCheckins;

  /// No description provided for @cardCompletion.
  ///
  /// In ar, this message translates to:
  /// **'نسبة الإنجاز'**
  String get cardCompletion;

  /// No description provided for @cardCommitment.
  ///
  /// In ar, this message translates to:
  /// **'نسبة الالتزام'**
  String get cardCommitment;

  /// No description provided for @noteSplit.
  ///
  /// In ar, this message translates to:
  /// **'{good} أبنيها · {bad} أتجنبها'**
  String noteSplit(String good, String bad);

  /// No description provided for @noteCurrentRuns.
  ///
  /// In ar, this message translates to:
  /// **'مجموع الفترات الحالية'**
  String get noteCurrentRuns;

  /// No description provided for @noteThisMonth.
  ///
  /// In ar, this message translates to:
  /// **'هذا الشهر'**
  String get noteThisMonth;

  /// No description provided for @noteLast30.
  ///
  /// In ar, this message translates to:
  /// **'آخر 30 يومًا'**
  String get noteLast30;

  /// No description provided for @last7Days.
  ///
  /// In ar, this message translates to:
  /// **'آخر 7 أيام'**
  String get last7Days;

  /// No description provided for @average.
  ///
  /// In ar, this message translates to:
  /// **'المتوسط'**
  String get average;

  /// No description provided for @monthlyCompletion.
  ///
  /// In ar, this message translates to:
  /// **'الإنجاز الشهري'**
  String get monthlyCompletion;

  /// No description provided for @trendPoints.
  ///
  /// In ar, this message translates to:
  /// **'{delta} نقطة منذ {month}'**
  String trendPoints(String delta, String month);

  /// No description provided for @noData.
  ///
  /// In ar, this message translates to:
  /// **'لا بيانات بعد. سجّل عاداتك وسيظهر تقدمك هنا.'**
  String get noData;

  /// No description provided for @unlockedCount.
  ///
  /// In ar, this message translates to:
  /// **'{n} من {total} مفتوحة'**
  String unlockedCount(String n, String total);

  /// No description provided for @nextBadge.
  ///
  /// In ar, this message translates to:
  /// **'التالي: {name}'**
  String nextBadge(String name);

  /// No description provided for @allUnlocked.
  ///
  /// In ar, this message translates to:
  /// **'فتحت كل الشارات! 🎉'**
  String get allUnlocked;

  /// No description provided for @unlockedSection.
  ///
  /// In ar, this message translates to:
  /// **'مفتوحة'**
  String get unlockedSection;

  /// No description provided for @lockedSection.
  ///
  /// In ar, this message translates to:
  /// **'مقفلة'**
  String get lockedSection;

  /// No description provided for @unlockedOn.
  ///
  /// In ar, this message translates to:
  /// **'فُتحت في {date}'**
  String unlockedOn(String date);

  /// No description provided for @lockedA11y.
  ///
  /// In ar, this message translates to:
  /// **'مقفلة'**
  String get lockedA11y;

  /// No description provided for @badgeFirstStep.
  ///
  /// In ar, this message translates to:
  /// **'أول خطوة'**
  String get badgeFirstStep;

  /// No description provided for @badgeFirstStepDesc.
  ///
  /// In ar, this message translates to:
  /// **'سجّل أول عادة لك.'**
  String get badgeFirstStepDesc;

  /// No description provided for @badgeWeekComplete.
  ///
  /// In ar, this message translates to:
  /// **'أسبوع كامل'**
  String get badgeWeekComplete;

  /// No description provided for @badgeWeekCompleteDesc.
  ///
  /// In ar, this message translates to:
  /// **'7 أيام متتالية لعادة يومية.'**
  String get badgeWeekCompleteDesc;

  /// No description provided for @badgePerfectWeek.
  ///
  /// In ar, this message translates to:
  /// **'أسبوع مثالي'**
  String get badgePerfectWeek;

  /// No description provided for @badgePerfectWeekDesc.
  ///
  /// In ar, this message translates to:
  /// **'أنجز كل عاداتك المستحقة لأسبوع كامل.'**
  String get badgePerfectWeekDesc;

  /// No description provided for @badgeClean21.
  ///
  /// In ar, this message translates to:
  /// **'3 أسابيع بدون'**
  String get badgeClean21;

  /// No description provided for @badgeClean21Desc.
  ///
  /// In ar, this message translates to:
  /// **'21 يومًا دون تعثر في عادة تتجنبها.'**
  String get badgeClean21Desc;

  /// No description provided for @badgeComeback.
  ///
  /// In ar, this message translates to:
  /// **'العودة بقوة'**
  String get badgeComeback;

  /// No description provided for @badgeComebackDesc.
  ///
  /// In ar, this message translates to:
  /// **'7 أيام بدون مجددًا بعد تعثر.'**
  String get badgeComebackDesc;

  /// No description provided for @badgeEarlyBird.
  ///
  /// In ar, this message translates to:
  /// **'صباح مبكر'**
  String get badgeEarlyBird;

  /// No description provided for @badgeEarlyBirdDesc.
  ///
  /// In ar, this message translates to:
  /// **'5 تسجيلات قبل 8 ص.'**
  String get badgeEarlyBirdDesc;

  /// No description provided for @badgeStreak30.
  ///
  /// In ar, this message translates to:
  /// **'30 يوم ثبات'**
  String get badgeStreak30;

  /// No description provided for @badgeStreak30Desc.
  ///
  /// In ar, this message translates to:
  /// **'سلسلة 30 يومًا لعادة يومية.'**
  String get badgeStreak30Desc;

  /// No description provided for @badgeClean100.
  ///
  /// In ar, this message translates to:
  /// **'100 يوم بدون'**
  String get badgeClean100;

  /// No description provided for @badgeClean100Desc.
  ///
  /// In ar, this message translates to:
  /// **'100 يوم دون تعثر في عادة تتجنبها.'**
  String get badgeClean100Desc;

  /// No description provided for @badgeGoalReached.
  ///
  /// In ar, this message translates to:
  /// **'الهدف تحقق'**
  String get badgeGoalReached;

  /// No description provided for @badgeGoalReachedDesc.
  ///
  /// In ar, this message translates to:
  /// **'حقق أي هدف وضعته لعادة.'**
  String get badgeGoalReachedDesc;

  /// No description provided for @celebrateStreak30.
  ///
  /// In ar, this message translates to:
  /// **'مبروك! 30 يوم من الثبات 🎉'**
  String get celebrateStreak30;

  /// No description provided for @celebrateClean100.
  ///
  /// In ar, this message translates to:
  /// **'مبروك! 100 يوم بدون 🎉'**
  String get celebrateClean100;

  /// No description provided for @celebrateBadge.
  ///
  /// In ar, this message translates to:
  /// **'مبروك! شارة «{name}» 🎉'**
  String celebrateBadge(String name);

  /// No description provided for @celebrateGoal.
  ///
  /// In ar, this message translates to:
  /// **'مبروك! حققت هدف «{name}» 🎉'**
  String celebrateGoal(String name);

  /// No description provided for @celebrateBody.
  ///
  /// In ar, this message translates to:
  /// **'هذه عادة حقيقية تتكوّن، خطوة ثابتة بعد خطوة.'**
  String get celebrateBody;

  /// No description provided for @share.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة'**
  String get share;

  /// No description provided for @continueBtn.
  ///
  /// In ar, this message translates to:
  /// **'متابعة'**
  String get continueBtn;

  /// No description provided for @shareText.
  ///
  /// In ar, this message translates to:
  /// **'حققت «{badge}» في ثبات. خطوة ثابتة كل يوم.'**
  String shareText(String badge);

  /// No description provided for @remindersTitle.
  ///
  /// In ar, this message translates to:
  /// **'التذكيرات'**
  String get remindersTitle;

  /// No description provided for @remindersActive.
  ///
  /// In ar, this message translates to:
  /// **'{on} من {total} مفعّلة'**
  String remindersActive(String on, String total);

  /// No description provided for @streakRiskTitle.
  ///
  /// In ar, this message translates to:
  /// **'تنبيه السلسلة في خطر'**
  String get streakRiskTitle;

  /// No description provided for @streakRiskSub.
  ///
  /// In ar, this message translates to:
  /// **'{time} إذا بقيت عادة يومية دون تسجيل'**
  String streakRiskSub(String time);

  /// No description provided for @quietHours.
  ///
  /// In ar, this message translates to:
  /// **'ساعات الهدوء'**
  String get quietHours;

  /// No description provided for @quietSub.
  ///
  /// In ar, this message translates to:
  /// **'{start} – {end} · لا يُرسل أي إشعار'**
  String quietSub(String start, String end);

  /// No description provided for @quietOff.
  ///
  /// In ar, this message translates to:
  /// **'متوقفة'**
  String get quietOff;

  /// No description provided for @scheduledReminders.
  ///
  /// In ar, this message translates to:
  /// **'التذكيرات المجدولة'**
  String get scheduledReminders;

  /// No description provided for @noReminders.
  ///
  /// In ar, this message translates to:
  /// **'لا تذكيرات بعد. فعّل تذكيرًا من شاشة تعديل العادة.'**
  String get noReminders;

  /// No description provided for @notificationsOffBanner.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات متوقفة من الإعدادات.'**
  String get notificationsOffBanner;

  /// No description provided for @toggleReminderA11y.
  ///
  /// In ar, this message translates to:
  /// **'تذكير {name}'**
  String toggleReminderA11y(String name);

  /// No description provided for @streakRiskNotifTitle.
  ///
  /// In ar, this message translates to:
  /// **'سلسلتك في خطر 🔥'**
  String get streakRiskNotifTitle;

  /// No description provided for @streakRiskNotifBody.
  ///
  /// In ar, this message translates to:
  /// **'لم تسجّل «{name}» اليوم بعد. نقرة واحدة تحفظ سلسلتك.'**
  String streakRiskNotifBody(String name);

  /// No description provided for @channelReminders.
  ///
  /// In ar, this message translates to:
  /// **'تذكيرات العادات'**
  String get channelReminders;

  /// No description provided for @channelStreak.
  ///
  /// In ar, this message translates to:
  /// **'تنبيهات السلسلة'**
  String get channelStreak;

  /// No description provided for @profileTitle.
  ///
  /// In ar, this message translates to:
  /// **'حسابي'**
  String get profileTitle;

  /// No description provided for @daysWithUs.
  ///
  /// In ar, this message translates to:
  /// **'{days} معنا'**
  String daysWithUs(String days);

  /// No description provided for @habitsCount.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{0 عادات} =1{عادة واحدة} =2{عادتان} few{{count} عادات} other{{count} عادة}}'**
  String habitsCount(int count);

  /// No description provided for @badgesCount.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{0 شارات} =1{شارة واحدة} =2{شارتان} few{{count} شارات} other{{count} شارة}}'**
  String badgesCount(int count);

  /// No description provided for @sectionLanguage.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get sectionLanguage;

  /// No description provided for @appLanguage.
  ///
  /// In ar, this message translates to:
  /// **'لغة التطبيق'**
  String get appLanguage;

  /// No description provided for @sectionNotifications.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get sectionNotifications;

  /// No description provided for @notifications.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notifications;

  /// No description provided for @activeCount.
  ///
  /// In ar, this message translates to:
  /// **'{n} مفعّلة'**
  String activeCount(String n);

  /// No description provided for @sectionPreferences.
  ///
  /// In ar, this message translates to:
  /// **'التفضيلات'**
  String get sectionPreferences;

  /// No description provided for @weekStart.
  ///
  /// In ar, this message translates to:
  /// **'بداية الأسبوع'**
  String get weekStart;

  /// No description provided for @monday.
  ///
  /// In ar, this message translates to:
  /// **'الاثنين'**
  String get monday;

  /// No description provided for @saturday.
  ///
  /// In ar, this message translates to:
  /// **'السبت'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In ar, this message translates to:
  /// **'الأحد'**
  String get sunday;

  /// No description provided for @appearance.
  ///
  /// In ar, this message translates to:
  /// **'المظهر'**
  String get appearance;

  /// No description provided for @themeLight.
  ///
  /// In ar, this message translates to:
  /// **'فاتح'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In ar, this message translates to:
  /// **'داكن'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In ar, this message translates to:
  /// **'تلقائي'**
  String get themeSystem;

  /// No description provided for @sectionData.
  ///
  /// In ar, this message translates to:
  /// **'بياناتك'**
  String get sectionData;

  /// No description provided for @exportData.
  ///
  /// In ar, this message translates to:
  /// **'تصدير البيانات JSON'**
  String get exportData;

  /// No description provided for @exportSubject.
  ///
  /// In ar, this message translates to:
  /// **'بيانات ثبات'**
  String get exportSubject;

  /// No description provided for @exportFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر التصدير.'**
  String get exportFailed;

  /// No description provided for @seedData.
  ///
  /// In ar, this message translates to:
  /// **'إضافة بيانات تجريبية'**
  String get seedData;

  /// No description provided for @seedDone.
  ///
  /// In ar, this message translates to:
  /// **'أُضيفت العادات التجريبية.'**
  String get seedDone;

  /// No description provided for @signOut.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get signOut;

  /// No description provided for @deleteAccount.
  ///
  /// In ar, this message translates to:
  /// **'حذف الحساب'**
  String get deleteAccount;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف الحساب؟'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountBody.
  ///
  /// In ar, this message translates to:
  /// **'سيتم حذف حسابك وكل عاداتك وسجلاتك وشاراتك نهائيًا. لا يمكن التراجع عن ذلك.'**
  String get deleteAccountBody;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In ar, this message translates to:
  /// **'احذف نهائيًا'**
  String get deleteAccountConfirm;

  /// No description provided for @versionLine.
  ///
  /// In ar, this message translates to:
  /// **'ثبات {version} · الشروط · الخصوصية'**
  String versionLine(String version);

  /// No description provided for @quietStart.
  ///
  /// In ar, this message translates to:
  /// **'من'**
  String get quietStart;

  /// No description provided for @quietEnd.
  ///
  /// In ar, this message translates to:
  /// **'إلى'**
  String get quietEnd;

  /// No description provided for @languageTitle.
  ///
  /// In ar, this message translates to:
  /// **'اختيار اللغة'**
  String get languageTitle;

  /// No description provided for @languageHint.
  ///
  /// In ar, this message translates to:
  /// **'يتغير اتجاه التطبيق تلقائيًا حسب اللغة.'**
  String get languageHint;

  /// No description provided for @streakRiskTime.
  ///
  /// In ar, this message translates to:
  /// **'وقت التنبيه'**
  String get streakRiskTime;

  /// No description provided for @loading.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ التحميل…'**
  String get loading;

  /// No description provided for @errorGeneric.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ. حاول مرة أخرى.'**
  String get errorGeneric;

  /// No description provided for @retry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get retry;

  /// No description provided for @habitNotFound.
  ///
  /// In ar, this message translates to:
  /// **'لم نجد هذه العادة.'**
  String get habitNotFound;

  /// No description provided for @am.
  ///
  /// In ar, this message translates to:
  /// **'ص'**
  String get am;

  /// No description provided for @pm.
  ///
  /// In ar, this message translates to:
  /// **'م'**
  String get pm;

  /// No description provided for @seedWater.
  ///
  /// In ar, this message translates to:
  /// **'شرب الماء'**
  String get seedWater;

  /// No description provided for @seedRead.
  ///
  /// In ar, this message translates to:
  /// **'قراءة 20 دقيقة'**
  String get seedRead;

  /// No description provided for @seedGym.
  ///
  /// In ar, this message translates to:
  /// **'الرياضة'**
  String get seedGym;

  /// No description provided for @seedFamily.
  ///
  /// In ar, this message translates to:
  /// **'زيارة العائلة'**
  String get seedFamily;

  /// No description provided for @seedSmoke.
  ///
  /// In ar, this message translates to:
  /// **'التدخين'**
  String get seedSmoke;

  /// No description provided for @seedSocial.
  ///
  /// In ar, this message translates to:
  /// **'الإفراط في وسائل التواصل'**
  String get seedSocial;

  /// No description provided for @seedFastFood.
  ///
  /// In ar, this message translates to:
  /// **'الوجبات السريعة'**
  String get seedFastFood;

  /// No description provided for @seedSoda.
  ///
  /// In ar, this message translates to:
  /// **'المشروبات الغازية'**
  String get seedSoda;

  /// No description provided for @seedWaterMsg.
  ///
  /// In ar, this message translates to:
  /// **'كوب ماء؟ جسمك يشكرك.'**
  String get seedWaterMsg;

  /// No description provided for @seedReadMsg.
  ///
  /// In ar, this message translates to:
  /// **'استرخِ مع 20 دقيقة من القراءة.'**
  String get seedReadMsg;

  /// No description provided for @seedGymMsg.
  ///
  /// In ar, this message translates to:
  /// **'يوم الرياضة! جسمك جاهز.'**
  String get seedGymMsg;

  /// No description provided for @seedSocialMsg.
  ///
  /// In ar, this message translates to:
  /// **'كيف كان وقت الشاشة اليوم؟'**
  String get seedSocialMsg;

  /// No description provided for @seedReadNote.
  ///
  /// In ar, this message translates to:
  /// **'القراءة تهدئ ذهني قبل النوم.'**
  String get seedReadNote;

  /// No description provided for @deleteAccountFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر حذف الحساب. تحقق من اتصالك بالإنترنت وحاول مجددًا.'**
  String get deleteAccountFailed;

  /// No description provided for @signedInWithGoogle.
  ///
  /// In ar, this message translates to:
  /// **'مسجّل الدخول عبر Google'**
  String get signedInWithGoogle;

  /// No description provided for @signInFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تسجيل الدخول. حاول مرة أخرى.'**
  String get signInFailed;

  /// No description provided for @signInNetwork.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد اتصال بالإنترنت. تسجيل الدخول يحتاج إلى اتصال.'**
  String get signInNetwork;

  /// No description provided for @signInNotConfigured.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول عبر Google غير مُعدّ بعد في هذه النسخة.'**
  String get signInNotConfigured;

  /// No description provided for @pendingSync.
  ///
  /// In ar, this message translates to:
  /// **'{count} تغييرات بانتظار المزامنة'**
  String pendingSync(String count);

  /// No description provided for @syncedAll.
  ///
  /// In ar, this message translates to:
  /// **'كل بياناتك محفوظة في السحابة'**
  String get syncedAll;

  /// No description provided for @notifAllowed.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات مسموحة'**
  String get notifAllowed;

  /// No description provided for @notifBlocked.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات محظورة لتطبيق ثبات، لذلك لن تصلك التذكيرات.'**
  String get notifBlocked;

  /// No description provided for @allowNotifications.
  ///
  /// In ar, this message translates to:
  /// **'السماح بالإشعارات'**
  String get allowNotifications;

  /// No description provided for @openSettings.
  ///
  /// In ar, this message translates to:
  /// **'فتح الإعدادات'**
  String get openSettings;

  /// No description provided for @exactAlarmsOff.
  ///
  /// In ar, this message translates to:
  /// **'قد تتأخر التذكيرات بضع دقائق. فعّل التوقيت الدقيق لتصلك في الدقيقة نفسها.'**
  String get exactAlarmsOff;

  /// No description provided for @exactAlarmsAllow.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل التوقيت الدقيق'**
  String get exactAlarmsAllow;

  /// No description provided for @testNotification.
  ///
  /// In ar, this message translates to:
  /// **'إرسال إشعار تجريبي'**
  String get testNotification;

  /// No description provided for @testNotificationTitle.
  ///
  /// In ar, this message translates to:
  /// **'ثبات 🔔'**
  String get testNotificationTitle;

  /// No description provided for @testNotificationBody.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات تعمل. ستصلك تذكيراتك في وقتها.'**
  String get testNotificationBody;

  /// No description provided for @scheduledCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} إشعارات مجدولة على هذا الجهاز'**
  String scheduledCount(String count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
