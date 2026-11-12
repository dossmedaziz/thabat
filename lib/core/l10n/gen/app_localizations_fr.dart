// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Thabat';

  @override
  String get appNameLatin => 'ثبات';

  @override
  String get tagline => 'Un pas régulier chaque jour';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get signInNewHint => 'Nouveau ? Le même bouton crée votre compte.';

  @override
  String get signInPrivacy =>
      'En continuant, vous acceptez les Conditions et la Politique de confidentialité.\nNous utilisons seulement votre nom, e-mail et photo.';

  @override
  String get langArabic => 'العربية';

  @override
  String get langEnglish => 'English';

  @override
  String get langFrench => 'Français';

  @override
  String get tabToday => 'Aujourd\'hui';

  @override
  String get tabProgress => 'Progrès';

  @override
  String get tabAchievements => 'Badges';

  @override
  String get tabProfile => 'Profil';

  @override
  String get addHabit => 'Ajouter une habitude';

  @override
  String greetingMorning(String name) {
    return 'Bonjour, $name';
  }

  @override
  String greetingAfternoon(String name) {
    return 'Bon après-midi, $name';
  }

  @override
  String greetingEvening(String name) {
    return 'Bonsoir, $name';
  }

  @override
  String welcomeName(String name) {
    return 'Bienvenue, $name';
  }

  @override
  String get build => 'Construire';

  @override
  String get avoid => 'Éviter';

  @override
  String get habitTypeFilter => 'Type d\'habitude';

  @override
  String get buildHead => 'Habitudes à construire';

  @override
  String get avoidHead => 'Habitudes à éviter';

  @override
  String ringTitle(String done, String total) {
    return '$done sur $total faites aujourd\'hui';
  }

  @override
  String ringLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Encore $count habitudes. Un geste chacune.',
      one: 'Plus qu’une habitude. Un seul geste.',
      zero: 'Journée parfaite. Tout est coché.',
    );
    return '$_temp0';
  }

  @override
  String get ringNothingDue => 'Rien de prévu aujourd\'hui. Profitez-en.';

  @override
  String doneOf(String done, String total) {
    return '$done sur $total faites';
  }

  @override
  String cleanOf(String done, String total) {
    return '$done sur $total sans écart';
  }

  @override
  String get freqDaily => 'Quotidien';

  @override
  String get freqWeekly => 'Hebdo';

  @override
  String get freqMonthly => 'Mensuel';

  @override
  String daysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '1 jour',
      zero: '0 jour',
    );
    return '$_temp0';
  }

  @override
  String weeksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count semaines',
      one: '1 semaine',
      zero: '0 semaine',
    );
    return '$_temp0';
  }

  @override
  String monthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mois',
      one: '1 mois',
      zero: '0 mois',
    );
    return '$_temp0';
  }

  @override
  String timesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fois',
      one: '1 fois',
    );
    return '$_temp0';
  }

  @override
  String daysClean(String days) {
    return '$days sans';
  }

  @override
  String get freshStart => 'Jour 0 · nouveau départ';

  @override
  String get done => 'Fait';

  @override
  String get slip => 'J\'ai craqué';

  @override
  String get undo => 'Annuler';

  @override
  String get skip => 'Passer';

  @override
  String get edit => 'Modifier';

  @override
  String get delete => 'Supprimer';

  @override
  String get cancel => 'Annuler';

  @override
  String get close => 'Fermer';

  @override
  String weekProgress(String done, String target) {
    return '$done sur $target cette semaine';
  }

  @override
  String monthProgress(String done, String target) {
    return '$done sur $target ce mois-ci';
  }

  @override
  String markDoneA11y(String name) {
    return 'Marquer fait : $name';
  }

  @override
  String undoA11y(String name) {
    return 'Annuler : $name';
  }

  @override
  String slipConfirmTitle(String name) {
    return 'Un écart sur « $name » ?';
  }

  @override
  String get slipConfirmBody =>
      'Ce n\'est pas grave. Le compteur repart à zéro et vos jours passés restent dans l\'historique.';

  @override
  String get slipConfirmYes => 'Oui, l\'enregistrer';

  @override
  String slippedSnack(String count) {
    return 'Enregistré. Vos $count jours comptent toujours. Le jour 1 commence.';
  }

  @override
  String get skippedSnack => 'Journée passée. Votre série est préservée.';

  @override
  String deletedSnack(String name) {
    return '« $name » supprimée';
  }

  @override
  String get emptyTitle => 'Votre premier pas commence ici';

  @override
  String get emptyBody =>
      'Choisissez une petite habitude à construire, ou une à arrêter. Vous pourrez en ajouter plus tard.';

  @override
  String get emptyCta => 'Créer ma première habitude';

  @override
  String get emptyOr => 'Ou commencez par une habitude courante';

  @override
  String get emptyTabBuild => 'Aucune habitude à construire.';

  @override
  String get emptyTabAvoid => 'Aucune habitude à éviter.';

  @override
  String get newHabit => 'Nouvelle habitude';

  @override
  String get editHabit => 'Modifier l\'habitude';

  @override
  String get typeGoodTitle => 'Construire';

  @override
  String get typeGoodSub => 'Une chose à faire régulièrement';

  @override
  String get typeBadTitle => 'Éviter';

  @override
  String get typeBadSub => 'Une chose à arrêter';

  @override
  String get nameLabel => 'Nom';

  @override
  String get nameHintGood => 'ex. Lire 20 minutes';

  @override
  String get nameHintBad => 'ex. Sodas';

  @override
  String get nameRequired => 'Donnez un nom à votre habitude';

  @override
  String get nameTooLong => 'Nom trop long (40 caractères max)';

  @override
  String get iconLabel => 'Icône';

  @override
  String get iconsTab => 'Icônes';

  @override
  String get emojiTab => 'Émoji';

  @override
  String get colorLabel => 'Couleur';

  @override
  String get colorTeal => 'Sarcelle';

  @override
  String get colorBlue => 'Bleu';

  @override
  String get colorPurple => 'Violet';

  @override
  String get colorCoral => 'Corail';

  @override
  String get colorAmber => 'Ambre';

  @override
  String get colorPink => 'Rose';

  @override
  String get frequencyLabel => 'Fréquence';

  @override
  String get weeklyTimes => 'Fois par semaine';

  @override
  String get weeklyDays => 'Jours précis';

  @override
  String get perWeek => 'par semaine';

  @override
  String get perMonth => 'par mois';

  @override
  String get pickDaysError => 'Choisissez au moins un jour';

  @override
  String get more => 'Plus';

  @override
  String get less => 'Moins';

  @override
  String get goalLabel => 'Objectif';

  @override
  String get goalNone => 'Aucun';

  @override
  String get goalHelpGood => 'Une série à atteindre';

  @override
  String get goalHelpBad => 'Combien de temps rester sans écart';

  @override
  String get reminderLabel => 'Rappel';

  @override
  String get reminderTime => 'Heure';

  @override
  String get reminderDays => 'Jours';

  @override
  String get reminderMessage => 'Message du rappel';

  @override
  String get reminderPreview => 'Aperçu de la notification';

  @override
  String reminderDefaultGood(String name) {
    return 'C’est l’heure de « $name ». Un geste suffit.';
  }

  @override
  String reminderDefaultBad(String name) {
    return 'Comment ça va avec « $name » ? Vous êtes plus fort que vous ne le pensez.';
  }

  @override
  String get reminderQuietWarning =>
      'Cette heure est dans les heures calmes ; le rappel ne sera pas envoyé.';

  @override
  String get noteLabel => 'Pourquoi cette habitude compte';

  @override
  String get optional => '(facultatif)';

  @override
  String get createHabit => 'Créer l\'habitude';

  @override
  String get saveChanges => 'Enregistrer';

  @override
  String get deleteHabit => 'Supprimer l\'habitude';

  @override
  String deleteConfirmTitle(String name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String get deleteConfirmBody =>
      'L\'habitude et tout son historique seront supprimés.';

  @override
  String get permissionDenied =>
      'Les notifications sont désactivées. Activez-les dans les réglages.';

  @override
  String get everyDay => 'Tous les jours';

  @override
  String get wd1 => 'L';

  @override
  String get wd2 => 'M';

  @override
  String get wd3 => 'M';

  @override
  String get wd4 => 'J';

  @override
  String get wd5 => 'V';

  @override
  String get wd6 => 'S';

  @override
  String get wd7 => 'D';

  @override
  String get back => 'Retour';

  @override
  String get reminderSettingsA11y => 'Réglages du rappel';

  @override
  String get streakLabelDays => 'jours d\'affilée';

  @override
  String get streakLabelWeeks => 'semaines d\'affilée';

  @override
  String get streakLabelMonths => 'mois d\'affilée';

  @override
  String get streakLabelClean => 'jours sans';

  @override
  String get bestStreak => 'Meilleure série';

  @override
  String get successRate => 'Taux de réussite';

  @override
  String get totalCheckins => 'Validations';

  @override
  String get totalCleanDays => 'jours sans';

  @override
  String get prevMonth => 'Mois précédent';

  @override
  String get nextMonth => 'Mois suivant';

  @override
  String get legendDone => 'Fait';

  @override
  String get legendClean => 'Sans';

  @override
  String get legendMissed => 'Manqué';

  @override
  String get legendSlipped => 'Écart';

  @override
  String get legendSkipped => 'Passé';

  @override
  String get todayLabel => 'Aujourd\'hui';

  @override
  String goalTitleStreak(String x) {
    return 'Objectif : série de $x';
  }

  @override
  String goalTitleAvoid(String x) {
    return 'Objectif : éviter pendant $x';
  }

  @override
  String goalTitleTotal(String x) {
    return 'Objectif : $x au total';
  }

  @override
  String goalRemaining(String x) {
    return 'Encore $x. Ce soir compte.';
  }

  @override
  String get goalReachedMsg => 'Objectif atteint ! Pas à pas.';

  @override
  String get noGoal => 'Pas encore d’objectif. Ajoutez-en un.';

  @override
  String get addGoal => 'Ajouter un objectif';

  @override
  String get recentActivity => 'Activité récente';

  @override
  String get historyClean => 'Journée sans';

  @override
  String historyLoggedAt(String time) {
    return 'Enregistré à $time';
  }

  @override
  String get historySlipNote => 'Nouveau départ le lendemain.';

  @override
  String get historyMissNote => 'Ça arrive. Recommencez aujourd’hui.';

  @override
  String get noHistory => 'Aucune activité.';

  @override
  String get filterLabel => 'Filtrer';

  @override
  String get filterAll => 'Tout';

  @override
  String get filterGood => 'Bonnes';

  @override
  String get filterBad => 'Mauvaises';

  @override
  String get cardTotalHabits => 'Habitudes';

  @override
  String get cardGoodHabits => 'À construire';

  @override
  String get cardBadHabits => 'À éviter';

  @override
  String get cardLongestStreak => 'Plus longue série';

  @override
  String get cardLongestClean => 'Plus longue période sans';

  @override
  String get cardDaysClean => 'Jours sans';

  @override
  String get cardCheckins => 'Validations';

  @override
  String get cardCompletion => 'Réussite';

  @override
  String get cardCommitment => 'Engagement';

  @override
  String noteSplit(String good, String bad) {
    return '$good à construire · $bad à éviter';
  }

  @override
  String get noteCurrentRuns => 'Somme des séries actuelles';

  @override
  String get noteThisMonth => 'Ce mois-ci';

  @override
  String get noteLast30 => '30 derniers jours';

  @override
  String get last7Days => '7 derniers jours';

  @override
  String get average => 'Moyenne';

  @override
  String get monthlyCompletion => 'Réussite mensuelle';

  @override
  String trendPoints(String delta, String month) {
    return '$delta pts depuis $month';
  }

  @override
  String get noData => 'Pas encore de données. Vos progrès apparaîtront ici.';

  @override
  String unlockedCount(String n, String total) {
    return '$n sur $total débloqués';
  }

  @override
  String nextBadge(String name) {
    return 'Prochain : $name';
  }

  @override
  String get allUnlocked => 'Tous les badges débloqués ! 🎉';

  @override
  String get unlockedSection => 'Débloqués';

  @override
  String get lockedSection => 'Verrouillés';

  @override
  String unlockedOn(String date) {
    return 'Débloqué le $date';
  }

  @override
  String get lockedA11y => 'verrouillé';

  @override
  String get badgeFirstStep => 'Premier pas';

  @override
  String get badgeFirstStepDesc => 'Validez votre première habitude.';

  @override
  String get badgeWeekComplete => 'Semaine complète';

  @override
  String get badgeWeekCompleteDesc =>
      '7 jours d\'affilée sur une habitude quotidienne.';

  @override
  String get badgePerfectWeek => 'Semaine parfaite';

  @override
  String get badgePerfectWeekDesc =>
      'Toutes vos habitudes prévues pendant une semaine.';

  @override
  String get badgeClean21 => '3 semaines sans';

  @override
  String get badgeClean21Desc =>
      '21 jours sans écart sur une habitude à éviter.';

  @override
  String get badgeComeback => 'Retour en force';

  @override
  String get badgeComebackDesc => '7 jours sans après un écart.';

  @override
  String get badgeEarlyBird => 'Lève-tôt';

  @override
  String get badgeEarlyBirdDesc => '5 validations avant 8 h.';

  @override
  String get badgeStreak30 => 'Série de 30 jours';

  @override
  String get badgeStreak30Desc =>
      'Une série de 30 jours sur une habitude quotidienne.';

  @override
  String get badgeClean100 => '100 jours sans';

  @override
  String get badgeClean100Desc =>
      '100 jours sans écart sur une habitude à éviter.';

  @override
  String get badgeGoalReached => 'Objectif atteint';

  @override
  String get badgeGoalReachedDesc => 'Atteignez n\'importe quel objectif fixé.';

  @override
  String get celebrateStreak30 => 'Bravo ! 30 jours de constance 🎉';

  @override
  String get celebrateClean100 => 'Bravo ! 100 jours sans 🎉';

  @override
  String celebrateBadge(String name) {
    return 'Bravo ! « $name » débloqué 🎉';
  }

  @override
  String celebrateGoal(String name) {
    return 'Bravo ! Objectif atteint pour « $name » 🎉';
  }

  @override
  String get celebrateBody => 'Une vraie habitude se forme, pas à pas.';

  @override
  String get share => 'Partager';

  @override
  String get continueBtn => 'Continuer';

  @override
  String shareText(String badge) {
    return 'J\'ai obtenu « $badge » sur Thabat. Un pas régulier chaque jour.';
  }

  @override
  String get remindersTitle => 'Rappels';

  @override
  String remindersActive(String on, String total) {
    return '$on sur $total activés';
  }

  @override
  String get streakRiskTitle => 'Alerte série en danger';

  @override
  String streakRiskSub(String time) {
    return '$time si une habitude quotidienne n\'est pas faite';
  }

  @override
  String get quietHours => 'Heures calmes';

  @override
  String quietSub(String start, String end) {
    return '$start – $end · aucune notification';
  }

  @override
  String get quietOff => 'Désactivées';

  @override
  String get scheduledReminders => 'Rappels programmés';

  @override
  String get noReminders =>
      'Aucun rappel. Activez-en un depuis l\'écran de modification.';

  @override
  String get notificationsOffBanner =>
      'Les notifications sont désactivées dans les Réglages.';

  @override
  String toggleReminderA11y(String name) {
    return 'Rappel pour $name';
  }

  @override
  String get streakRiskNotifTitle => 'Votre série est en danger 🔥';

  @override
  String streakRiskNotifBody(String name) {
    return '« $name » n\'est pas encore fait. Un geste garde votre série.';
  }

  @override
  String get channelReminders => 'Rappels d’habitudes';

  @override
  String get channelStreak => 'Alertes de série';

  @override
  String get profileTitle => 'Profil';

  @override
  String daysWithUs(String days) {
    return '$days avec nous';
  }

  @override
  String habitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count habitudes',
      one: '1 habitude',
      zero: '0 habitude',
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
      zero: '0 badge',
    );
    return '$_temp0';
  }

  @override
  String get sectionLanguage => 'Langue';

  @override
  String get appLanguage => 'Langue de l\'app';

  @override
  String get sectionNotifications => 'Notifications';

  @override
  String get notifications => 'Notifications';

  @override
  String activeCount(String n) {
    return '$n activés';
  }

  @override
  String get sectionPreferences => 'Préférences';

  @override
  String get weekStart => 'Début de semaine';

  @override
  String get monday => 'Lundi';

  @override
  String get saturday => 'Samedi';

  @override
  String get sunday => 'Dimanche';

  @override
  String get appearance => 'Apparence';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeSystem => 'Auto';

  @override
  String get sectionData => 'Vos données';

  @override
  String get exportData => 'Exporter les données (JSON)';

  @override
  String get exportSubject => 'Données Thabat';

  @override
  String get exportFailed => 'Échec de l\'export.';

  @override
  String get seedData => 'Ajouter des données démo';

  @override
  String get seedDone => 'Habitudes démo ajoutées.';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get deleteAccountTitle => 'Supprimer le compte ?';

  @override
  String get deleteAccountBody =>
      'Votre compte et toutes vos habitudes, historique et badges seront définitivement supprimés. Action irréversible.';

  @override
  String get deleteAccountConfirm => 'Supprimer définitivement';

  @override
  String versionLine(String version) {
    return 'Thabat $version · Conditions · Confidentialité';
  }

  @override
  String get quietStart => 'De';

  @override
  String get quietEnd => 'À';

  @override
  String get languageTitle => 'Choisir la langue';

  @override
  String get languageHint => 'Le sens de lecture suit la langue.';

  @override
  String get streakRiskTime => 'Heure de l\'alerte';

  @override
  String get loading => 'Chargement…';

  @override
  String get errorGeneric => 'Une erreur est survenue. Réessayez.';

  @override
  String get retry => 'Réessayer';

  @override
  String get habitNotFound => 'Habitude introuvable.';

  @override
  String get am => 'AM';

  @override
  String get pm => 'PM';

  @override
  String get seedWater => 'Boire de l\'eau';

  @override
  String get seedRead => 'Lire 20 min';

  @override
  String get seedGym => 'Sport';

  @override
  String get seedFamily => 'Voir la famille';

  @override
  String get seedSmoke => 'Tabac';

  @override
  String get seedSocial => 'Trop de réseaux sociaux';

  @override
  String get seedFastFood => 'Fast-food';

  @override
  String get seedSoda => 'Sodas';

  @override
  String get seedWaterMsg => 'Un verre d\'eau ? Votre corps vous remercie.';

  @override
  String get seedReadMsg => 'Détendez-vous avec 20 minutes de lecture.';

  @override
  String get seedGymMsg => 'Jour de sport ! Vous êtes prêt.';

  @override
  String get seedSocialMsg => 'Comment s\'est passé le temps d\'écran ?';

  @override
  String get seedReadNote => 'La lecture calme mon esprit avant de dormir.';

  @override
  String get deleteAccountFailed =>
      'Impossible de supprimer le compte. Vérifiez votre connexion et réessayez.';

  @override
  String get signedInWithGoogle => 'Connecté avec Google';

  @override
  String get signInFailed => 'Échec de la connexion. Réessayez.';

  @override
  String get signInNetwork =>
      'Pas de connexion Internet. La connexion nécessite Internet.';

  @override
  String get signInNotConfigured =>
      'La connexion Google n’est pas encore configurée dans cette version.';

  @override
  String pendingSync(String count) {
    return '$count modifications en attente de synchronisation';
  }

  @override
  String get syncedAll => 'Toutes vos données sont enregistrées dans le cloud';

  @override
  String get notifAllowed => 'Notifications autorisées';

  @override
  String get notifBlocked =>
      'Les notifications sont bloquées pour Thabat : les rappels ne peuvent pas vous parvenir.';

  @override
  String get allowNotifications => 'Autoriser les notifications';

  @override
  String get openSettings => 'Ouvrir les réglages';

  @override
  String get exactAlarmsOff =>
      'Les rappels peuvent arriver avec quelques minutes de retard. Activez l’heure exacte.';

  @override
  String get exactAlarmsAllow => 'Activer l’heure exacte';

  @override
  String get testNotification => 'Envoyer une notification test';

  @override
  String get testNotificationTitle => 'Thabat 🔔';

  @override
  String get testNotificationBody =>
      'Les notifications fonctionnent. Vos rappels arriveront à l’heure.';

  @override
  String scheduledCount(String count) {
    return '$count notifications programmées sur cet appareil';
  }

  @override
  String get continueWithEmail => 'Continuer avec l’e-mail';

  @override
  String get orDivider => 'ou';

  @override
  String get emailTitle => 'Connexion par e-mail';

  @override
  String get emailSubtitle =>
      'Nous vous enverrons un code de vérification. Si vous n’avez pas de compte, il sera créé.';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get emailInvalid => 'Saisissez une adresse e-mail valide';

  @override
  String get sendCode => 'Envoyer le code';

  @override
  String get codeTitle => 'Saisissez le code';

  @override
  String codeSentTo(String email) {
    return 'Nous avons envoyé un code à $email. Vérifiez aussi vos spams.';
  }

  @override
  String get codeLabel => 'Code de vérification';

  @override
  String get codeRequired => 'Saisissez le code reçu';

  @override
  String get verifyCode => 'Vérifier et se connecter';

  @override
  String get resendCode => 'Renvoyer le code';

  @override
  String resendIn(String seconds) {
    return 'Renvoyer dans $seconds s';
  }

  @override
  String get changeEmail => 'Changer d’e-mail';

  @override
  String get codeResent => 'Nouveau code envoyé.';

  @override
  String get codeInvalid => 'Code incorrect ou expiré.';

  @override
  String get codeRateLimited =>
      'Trop de tentatives. Patientez un peu et réessayez.';

  @override
  String get emailNotAuthorized =>
      'Impossible d’envoyer un code à cette adresse pour le moment. Réessayez plus tard ou utilisez Google.';

  @override
  String get signedInWithEmail => 'Connecté par e-mail';

  @override
  String get todayProgress => 'Progrès du jour';

  @override
  String ofTotal(String total) {
    return 'sur $total';
  }

  @override
  String get allDoneToday => 'Tout est fait aujourd’hui';

  @override
  String get colorGreen => 'Vert';

  @override
  String get colorOrange => 'Orange';

  @override
  String get colorRed => 'Rouge';

  @override
  String get colorYellow => 'Jaune';
}
