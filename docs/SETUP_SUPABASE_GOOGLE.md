# Thabat — Supabase + Google sign-in setup

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

```bash
flutter build apk --release --dart-define=GOOGLE_WEB_CLIENT_ID=YOUR_WEB_CLIENT_ID.apps.googleusercontent.com
```

For iOS also pass `--dart-define=GOOGLE_IOS_CLIENT_ID=...` and add the iOS
client's *reversed client ID* as a URL scheme in `ios/Runner/Info.plist`
(`CFBundleURLTypes` → `CFBundleURLSchemes`).

Without `GOOGLE_WEB_CLIENT_ID` the app still builds, but the sign-in button shows
"Google sign-in isn't configured in this build yet".

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
