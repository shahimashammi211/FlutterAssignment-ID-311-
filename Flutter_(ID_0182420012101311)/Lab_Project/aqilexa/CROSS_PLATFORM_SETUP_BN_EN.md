# AQILEXA Cross-platform preparation

This ZIP is a **preparation build**, not a completed production hybrid-auth/sync release.

## Included
- Existing Flutter source and current local authentication/data features retained.
- Existing Android, iOS, Web, and Windows platform folders retained.
- Supabase URL and publishable key are now read from Dart compile-time defines.
- Supabase initialization errors no longer prevent the local app from opening.
- `SUPABASE_STARTER_SCHEMA.sql` provides a starter per-user JSON record table with RLS.
- No Supabase secret/service_role key is embedded.

## Configure Supabase

1. Create a Supabase project.
2. Review `SUPABASE_STARTER_SCHEMA.sql` and run it in the Supabase SQL Editor in a development project.
3. Configure Supabase Auth providers, email confirmation, password reset redirect URLs, and allowed redirect URLs.
4. Build/run with:
   ```bash
   flutter run --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLISHABLE_KEY
   ```
5. For web:
   ```bash
   flutter build web --release --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLISHABLE_KEY
   ```

## Important limitations that remain

- Login and registration screens still use the existing LocalAuthService. SupabaseAuthService is an adapter, not yet wired into the UI as primary authentication.
- Offline account linking and secure cross-device identity migration are not implemented.
- `sync_service.dart` is only a basic upsert adapter. It is not a complete sync queue, retry engine, conflict resolver, or two-way sync implementation.
- The starter SQL table is not a complete migration for the existing Hive data model. A reviewed mapping and migration strategy is required before enabling production sync.
- Local password recovery is local-only; Supabase email recovery flow still needs integration.
- Browser storage can be cleared by the user/browser. Production web needs clear backup/export and session policies.
- Platform folders being present does not prove successful builds on all platforms.

## Validation still required

Run from the project root:
```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --release
flutter build appbundle --release
flutter build web --release
flutter build windows --release
```

iOS release builds require macOS and Xcode:
```bash
flutter build ios --release
```

Windows desktop builds require the Visual Studio C++ desktop workload. Store publication also requires developer accounts, signing, app identifiers, privacy disclosures, icons, screenshots, and store review.


## Validation fixes in this revision
- Fixed `AppConfig.useSupabase` so it is evaluated at runtime rather than as an invalid const expression.
- Updated the optional Supabase service to use runtime configuration.
- Added `LocalDatabase.initializeAt()` for isolated widget tests.
- Updated the startup widget test to initialize Hive and verify the signed-out welcome screen.
