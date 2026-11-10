/// App configuration. Every value can be overridden at build time:
///   flutter build apk --dart-define=GOOGLE_WEB_CLIENT_ID=xxx.apps.googleusercontent.com
///
/// The Supabase URL and publishable key are safe to ship in the app: access to
/// data is enforced by row-level security on the server.
abstract final class Env {
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://gwmnfbanaimkvckwurcl.supabase.co',
  );

  static const supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'sb_publishable_9Azu7GXAWFYqwDdrzrw1tg_cvLNcEwN',
  );

  /// TODO(you): OAuth client ID of type "Web application" from Google Cloud Console.
  /// The same ID (and its secret) goes into Supabase → Authentication → Providers → Google.
  static const googleWebClientId = String.fromEnvironment('GOOGLE_WEB_CLIENT_ID', defaultValue: '');

  /// TODO(you, iOS only): OAuth client ID of type "iOS" from Google Cloud Console.
  static const googleIosClientId = String.fromEnvironment('GOOGLE_IOS_CLIENT_ID', defaultValue: '');

  static bool get googleConfigured => googleWebClientId.isNotEmpty;
}
