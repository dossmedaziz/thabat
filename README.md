# ثبات · Thabat

**خطوة ثابتة كل يوم** — One steady step every day.

An Arabic-first habit tracker for Android and iOS, built with Flutter. Build good habits, break bad ones, keep your streaks, and get gentle reminders. Full RTL layout in Arabic, plus English and French.

<p align="center">
  <img src="docs/screenshots/ar_02_today.png" width="230" alt="Today screen (Arabic, dark)">
  <img src="docs/screenshots/ar_04_habit_detail.png" width="230" alt="Habit detail with month heatmap">
  <img src="docs/screenshots/ar_light_today.png" width="230" alt="Today screen, light theme">
</p>

## Features

- **Good and bad habits.** Daily, weekly (X times or specific days) or monthly, with an optional goal.
- **One-tap check-in** with a pop animation and haptic feedback. Bad habits have a gentle "تعثرت" (I slipped) button.
- **Swipe actions** on each card: edit, skip, delete (with undo), or swipe the other way to mark done.
- **Streaks and stats:** current and best streak, success rate, days clean, goal progress with milestones.
- **Progress charts** for the last 7 days and the last 6 months, filterable by all / good / bad.
- **9 badges** with a confetti celebration when you unlock one or reach a goal.
- **Reminders** as local notifications, an evening "streak at risk" alert, and quiet hours.
- **Sign in with Google or with email** (a one-time code is emailed; the same flow creates new accounts). Data is stored in **Supabase**, works offline and syncs when the connection returns.
- **Arabic (default), English, French**, switchable instantly. Light, dark or automatic theme.

## Design

Thabat uses the same design system as the **Cashflow** app:

- **Flat surfaces.** No shadows or gradients: a dark-first gray background with cards one step lighter.
- **Color by meaning.** Indigo `#4263EB` for every action, mint for "done" and good habits, rose for bad habits, peach for streaks. Each habit has one of 8 soft pastels.
- **Large radii.** Hero card 24, list cards 22, sheets 28, buttons and chips fully pill-shaped.
- **Type.** Inter for Latin text and every digit, IBM Plex Sans Arabic for Arabic.
- **Motion.** Short ease-out transitions; a press scales to 0.96 instead of an ink ripple, and "Reduce motion" is respected.

Shared components live in `lib/core/widgets/`:

| Component | Use |
|---|---|
| `AppButton` | Pill buttons: primary (indigo), secondary, danger, Google |
| `CircleIconButton` | 44 px round icon buttons |
| `Segmented` | Indigo segmented control |
| `FilterPill`, `PickerPill`, `TintBadge` | Chips and tags |
| `GroupedCard`, `NavRow` | Grouped lists |
| `showAppBottomSheet` + `AppBottomSheet` | Sheets with a handle and a round close button |
| `Pressable` | Press-scale feedback |

Tokens (spacing, radii, sizes, motion) are in `lib/core/theme/app_tokens.dart`, and colors in `app_colors.dart`.

## Screenshots

### Arabic (RTL, dark)

| Sign in | Today: build | Today: avoid |
|:-:|:-:|:-:|
| <img src="docs/screenshots/ar_01_sign_in.png" width="220"> | <img src="docs/screenshots/ar_02_today.png" width="220"> | <img src="docs/screenshots/ar_03_today_avoid.png" width="220"> |

| Habit detail | New habit | Progress |
|:-:|:-:|:-:|
| <img src="docs/screenshots/ar_04_habit_detail.png" width="220"> | <img src="docs/screenshots/ar_05_new_habit.png" width="220"> | <img src="docs/screenshots/ar_06_progress.png" width="220"> |

| Achievements | Profile & settings | Reminders |
|:-:|:-:|:-:|
| <img src="docs/screenshots/ar_07_achievements.png" width="220"> | <img src="docs/screenshots/ar_08_profile.png" width="220"> | <img src="docs/screenshots/ar_09_reminders.png" width="220"> |

### Light theme

| Today | Bad habit detail |
|:-:|:-:|
| <img src="docs/screenshots/ar_light_today.png" width="220"> | <img src="docs/screenshots/ar_light_habit_detail.png" width="220"> |

### English and French (LTR)

| Today (English) | Progress (English) | Today (French) |
|:-:|:-:|:-:|
| <img src="docs/screenshots/en_today.png" width="220"> | <img src="docs/screenshots/en_progress.png" width="220"> | <img src="docs/screenshots/fr_today.png" width="220"> |

The screenshots are rendered by a test, so they always match the current code (see [Updating the screenshots](#updating-the-screenshots)).

## Tech stack

| Area | Choice |
|---|---|
| UI | Flutter, Material 3, Cashflow design system; Inter + IBM Plex Sans Arabic (bundled) |
| State | Riverpod 3 + riverpod_generator |
| Navigation | go_router with a sign-in redirect |
| Backend | Supabase: Auth (Google), Postgres with row-level security |
| Sign-in | Google: google_sign_in → `signInWithIdToken`. Email: one-time code with `signInWithOtp` / `verifyOTP` |
| Models | freezed + json_serializable |
| Reminders | flutter_local_notifications + timezone |
| Charts and animation | fl_chart, confetti, Lottie |
| Languages | ARB files: `app_ar.arb` (template), `app_en.arb`, `app_fr.arb` |

## Project structure

```
lib/
  core/        config, theme (tokens, colors, text styles), l10n, router, utils, shared widgets
  features/
    auth/          Google and email-code sign-in, sign-in screens
    habits/        models, streak/stat logic, Supabase sync, Today / editor / detail
    progress/      stats and charts
    achievements/  badge rules, badge grid, celebration overlay
    notifications/ scheduling, reminders screen
    settings/      preferences, language, export, delete account
supabase/migrations/   database schema + RLS policies
screenshots/           screenshot generator
test/                  unit + widget tests
docs/                  setup guide and screenshots
```

## Getting started

### 1. One-time setup: Supabase, Google and email sign-in

The database is already created in the Supabase project **thabat**. You need to connect Google (OAuth clients in Google Cloud, then enable Google in Supabase), switch the email template to send a code, and, before real users, connect an email service. Follow the step-by-step guide in **[docs/SETUP_SUPABASE_GOOGLE.md](docs/SETUP_SUPABASE_GOOGLE.md)**.

### 2. Install dependencies and generate code

```bash
flutter pub get
```

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Run or build

Pass your Google **Web** client ID when building. Without it the app runs, but sign-in says it isn't configured.

```bash
flutter run --dart-define=GOOGLE_WEB_CLIENT_ID=YOUR_WEB_CLIENT_ID.apps.googleusercontent.com
```

Release APK (one file for all phones, about 68 MB):

```bash
flutter build apk --release --dart-define=GOOGLE_WEB_CLIENT_ID=YOUR_WEB_CLIENT_ID.apps.googleusercontent.com
```

Smaller APKs, one per CPU type (about 22 MB; install `app-arm64-v8a-release.apk` on most phones):

```bash
flutter build apk --release --split-per-abi --dart-define=GOOGLE_WEB_CLIENT_ID=YOUR_WEB_CLIENT_ID.apps.googleusercontent.com
```

APKs are written to `build/app/outputs/flutter-apk/`. They are signed with the debug key, which is fine for installing on your own phone but not for the Play Store.

## Notifications

Reminders are **local notifications** scheduled on the phone. They don't need a server or internet.

- The app asks for notification permission once, as soon as any reminder (or the streak alert) is on.
- **Profile → التذكيرات** shows whether notifications are allowed, how many are scheduled, and has a **Send a test notification** button.
- Reminders fire on the exact minute when Android allows exact alarms. If it doesn't, they may arrive a few minutes late, and the Reminders screen offers **Turn on exact timing**.
- **Quiet hours** (22:00–07:00 by default) skip any reminder in that window.
- If the test works but scheduled reminders don't arrive, the phone's battery saver is probably stopping the app (common on Xiaomi, Oppo, Huawei, Samsung). Set Android settings → Apps → Thabat → Battery to **Unrestricted**.

## Tests

```bash
flutter analyze
```

```bash
flutter test
```

The tests cover streaks for daily / weekly / monthly habits and every week start, skipped and slipped days, days clean, success rate, goals and all badges. They also cover offline sync, the Supabase row mapping, identical keys in the three languages, and the app flow in Arabic, English and French.

## Updating the screenshots

```bash
flutter test screenshots/take_screenshots_test.dart
```

This renders the screens with the real fonts and the sample habits (offline, with fake sign-in) into `docs/screenshots/`. It isn't part of `flutter test` because the images change every day: they show today's date and streaks.
