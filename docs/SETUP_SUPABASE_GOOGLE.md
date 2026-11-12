# Thabat — Supabase, Google and email sign-in setup

Back to the [README](../README.md).

Supabase project: **thabat** (`gwmnfbanaimkvckwurcl`, region eu-west-3)
API URL: `https://gwmnfbanaimkvckwurcl.supabase.co` (already set in `lib/core/config/env.dart`)

The database tables (`profiles`, `habits`, `habit_logs`, `achievements`) and their
row-level security are already created — see `supabase/migrations/`.

What is left is connecting Google. You do these steps once.

## 1. Google Cloud Console — OAuth clients

Go to <https://console.cloud.google.com/> → create (or pick) a project.

1. **APIs & Services → OAuth consent screen**: choose *External*, fill in the app
   name (Thabat), support email, and add the scopes `email`, `profile`, `openid`.
   While the app is in *Testing*, add your Google account under *Test users*.
2. **APIs & Services → Credentials → Create credentials → OAuth client ID**, three times:

   | Type | Settings |
   |---|---|
   | **Web application** | Name: `Thabat web`. Authorized redirect URI: `https://gwmnfbanaimkvckwurcl.supabase.co/auth/v1/callback` → copy the **Client ID** and **Client secret** |
   | **Android** | Package name: `com.thabat.thabat` · SHA-1: `F7:98:20:DE:99:D7:17:B8:E0:DC:35:DD:19:3B:D2:28:CF:B0:3C:2C` |
   | **iOS** (only if you build for iPhone) | Bundle ID: `com.thabat.thabat` |

   The SHA-1 above is this machine's debug key, which also signs the current
   release APK. If you later sign with your own release key, add that key's SHA-1
   as a second Android client (get it with `keytool -list -v -keystore <your.jks>`).

## 2. Supabase — enable Google

Supabase dashboard → project **thabat** → **Authentication → Sign In / Providers → Google**:

- Enable **Sign in with Google**
- **Client IDs**: paste the **Web** client ID (and, comma-separated, the Android
  and iOS client IDs)
- **Client Secret (for OAuth)**: the Web client secret
- iOS only: turn on **Skip nonce checks** (the iOS Google SDK adds a nonce the app can't read)
- Save

## 3. Build the app with your Web client ID

Your Web client ID is `1070402896429-041nedb5e5368gnvmksq7bpvvn7f7ngh.apps.googleusercontent.com`.
Use the **Web** client ID here, not the Android one.

```bash
flutter build apk --release --dart-define=GOOGLE_WEB_CLIENT_ID=1070402896429-041nedb5e5368gnvmksq7bpvvn7f7ngh.apps.googleusercontent.com
```

Smaller, per-CPU APKs (install `app-arm64-v8a-release.apk` on most phones):

```bash
flutter build apk --release --split-per-abi --dart-define=GOOGLE_WEB_CLIENT_ID=1070402896429-041nedb5e5368gnvmksq7bpvvn7f7ngh.apps.googleusercontent.com
```

The APK is written to `build/app/outputs/flutter-apk/app-release.apk`.

For iOS also pass `--dart-define=GOOGLE_IOS_CLIENT_ID=...` and add the iOS
client's *reversed client ID* as a URL scheme in `ios/Runner/Info.plist`
(`CFBundleURLTypes` → `CFBundleURLSchemes`).

Without `GOOGLE_WEB_CLIENT_ID` the app still builds, but the sign-in button shows
"Google sign-in isn't configured in this build yet".

## 4. Email sign-in (one-time code)

Users can also sign in or create an account with just their email: the app emails
a code, they type it in, and they're in. No password. Two dashboard settings make it work.

**a. Send a code instead of a link.** Supabase dashboard → project **thabat** →
**Authentication → Emails → Templates → Magic link**. Replace the body with something like:

```html
<h2>رمز الدخول إلى ثبات · Your Thabat code</h2>
<p>{{ .Token }}</p>
<p>ينتهي خلال ساعة · Expires in one hour.</p>
```

`{{ .Token }}` is the code. If the template still contains `{{ .ConfirmationURL }}`
instead, users get a link the app can't use. The code length is set under
**Authentication → Sign In / Providers → Email → Email OTP length** (the app accepts 6–10 digits).

**b. Let Supabase email real users.** Supabase's built-in sender only delivers to
members of your Supabase organization (your own address works for testing) and only a
few emails per hour. Anyone else gets "We can't send a code to this address right now".
Before inviting users, connect an email service under **Authentication → Emails → SMTP
Settings**, for example [Resend](https://resend.com/docs/send-with-supabase-smtp) or Brevo
(both have free tiers). Then raise the limit under **Authentication → Rate Limits**.

Nothing needs to change in the app for either step.

## Checklist

- [ ] Google Cloud: OAuth consent screen set up, your Gmail added as a test user
- [ ] Google Cloud: **Web** client with redirect URI `https://gwmnfbanaimkvckwurcl.supabase.co/auth/v1/callback`
- [ ] Google Cloud: **Android** client, package `com.thabat.thabat`, SHA-1 of the key that signs the APK
- [ ] Supabase (project **thabat**, not myapp): Google enabled, Web + Android client IDs and the Web secret saved
- [ ] APK built with `--dart-define=GOOGLE_WEB_CLIENT_ID=...`
- [ ] Email: Magic link template contains `{{ .Token }}`
- [ ] Email: custom SMTP connected before real users sign up (built-in sender only reaches your team)

## Troubleshooting sign-in

| What you see | Likely cause |
|---|---|
| The email contains a link, not a code | The Magic link template doesn't include `{{ .Token }}` (step 4a) |
| "We can't send a code to this address right now" | No custom SMTP yet, and the address isn't a member of your Supabase organization (step 4b) |
| "Too many attempts" | One code per address per 60 s, plus the hourly email limit |
| "That code is wrong or has expired" | Typo, an older code, or the code is past its expiry; tap **Resend code** |
| "Google sign-in isn't configured in this build yet" | The APK was built without `--dart-define=GOOGLE_WEB_CLIENT_ID=...` |
| The Google account picker closes immediately, or "sign-in failed" | The Android client's package name or SHA-1 doesn't match the APK, or your account isn't a test user on the consent screen |
| "sign-in failed" right after picking an account | Google isn't enabled in the Supabase **thabat** project, or the client IDs / secret there are wrong |
| "No internet connection" | Signing in needs a connection; after that the app works offline |

## Notifications

Reminders are local notifications scheduled on the phone, so they need no setup in
Supabase or Google Cloud.

- The app asks for notification permission once, as soon as any reminder or the
  streak-at-risk alert is on. If you tapped "Don't allow", open **Profile → التذكيرات**
  and tap **Allow notifications** (it opens system settings if Android no longer shows the prompt).
- **Profile → التذكيرات → Send a test notification** checks that notifications work at all.
- Reminders fire on the exact minute when Android allows exact alarms; otherwise they
  may be a few minutes late and the screen offers **Turn on exact timing**.
- Quiet hours (22:00–07:00 by default) skip reminders in that window.
- If the test works but scheduled reminders never arrive, set Android settings → Apps →
  Thabat → Battery to **Unrestricted** (Xiaomi, Oppo, Huawei and Samsung often stop apps in the background).

## How data sync works

- Every change (new habit, check-in, slip, badge) shows instantly and is saved on
  the phone first, then sent to Supabase.
- Offline changes wait in a queue (Profile → Your data shows how many) and are sent
  automatically when the connection returns: on the next change, when the app is
  reopened, or every 30 seconds.
- On sign-in the app downloads the user's data, and their language / week start /
  theme are stored in `profiles`.
- **Delete account** calls the `delete_my_account()` function, which deletes the
  Supabase user; all their rows are removed with it (`on delete cascade`).
