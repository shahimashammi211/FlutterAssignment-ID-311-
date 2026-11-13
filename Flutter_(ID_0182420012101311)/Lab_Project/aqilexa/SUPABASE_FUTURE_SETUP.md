# Future Supabase Integration

AQILEXA currently runs in Local Mode. Supabase is included as an optional future integration and is intentionally not initialized. No Supabase project, URL, or key is needed to run the current app.

When ready to migrate: create a Supabase project, configure Auth and Row Level Security, add URL and publishable key to `lib/core/services/optionalservice.dart`, enable the service, implement explicit local-account linking/migration, then test sync and conflict handling. Do not treat a local account as a verified Supabase identity.
