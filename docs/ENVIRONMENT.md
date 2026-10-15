# Environment configuration

The application intentionally works in demo mode without provider credentials. Do not commit real secrets.

## Local development

Create a local `.env.local` file (never commit it) with only the values you actually configured:

```dotenv
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
AI_PROVIDER_API_KEY=
```

- `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY`: public project URL and anon/publishable key for a dedicated Supabase project. These do not replace authentication or RLS.
- `AI_PROVIDER_API_KEY`: private server-only key for the selected AI provider. Never prefix it with `NEXT_PUBLIC_`.
- `SUPABASE_SERVICE_ROLE_KEY`: not required by the current application. If a future server-only administrative workflow truly needs it, store it only in the deployment secret manager and never expose it to the browser.

## Vercel

Add variables in the project settings for the correct environment (Development, Preview, Production), then redeploy. Never reuse the clinic demo's database or secrets.

## Verification

`GET /api/health` reports whether configuration variables are present, not whether external services have been successfully contacted. It intentionally never returns secret values. Database and AI remain marked not connected until real server-side adapters and authenticated integration tests exist.
