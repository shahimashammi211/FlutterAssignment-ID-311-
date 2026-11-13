# AQILEXA

Flutter Web-first academic productivity app. Current mode: Local Authentication + browser-persistent local storage. Future Supabase adapter is included but disabled.

## Features
- Email registration and login (local account)
- Local password recovery using the recovery code created at registration
- Notebook
- To-do Calendar
- Focus Timer
- Settings and functional logout

## Run in Chrome / Edge
```bash
flutter config --enable-web
flutter pub get
flutter run -d chrome
# or
flutter run -d edge
```

On Web, Hive persists data using browser IndexedDB. Keep the same browser profile and do not clear site data if you need to retain local accounts and study data. Local accounts are device/browser-profile scoped; they are not cloud accounts and are not email-verified.

## Security and limitations
Passwords are stored as PBKDF2-HMAC-SHA256 hashes with per-user random salts. Local recovery uses a recovery code, not an email reset link. This is a presentation/demo local-auth design, not a replacement for server-side identity verification for a public production service.

## Future Supabase
See `SUPABASE_FUTURE_SETUP.md`. Supabase initialization is disabled and no URL/key is required now. Future cloud use requires explicit account linking, migration, Row Level Security and conflict-aware sync.
