# Environment configuration

The application intentionally works in demo mode without provider credentials. Do not commit real secrets.

## Local development

Create a local `.env.local` file (never commit it) with only the values you actually configured:

```dotenv
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
OPENAI_API_KEY=
```

- `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY`: public project URL and anon/publishable key for a dedicated Supabase project. These do not replace authentication or RLS.
- `OPENAI_API_KEY`: private server-only key for OpenAI content generation. Never prefix it with `NEXT_PUBLIC_`.
- `SUPABASE_SERVICE_ROLE_KEY`: not required by the current application. If a future server-only administrative workflow truly needs it, store it only in the deployment secret manager and never expose it to the browser.

## Vercel

Add variables in the project settings for the correct environment (Development, Preview, Production), then redeploy. Never reuse the clinic demo's database or secrets.

## Verification

`GET /api/health` reports whether configuration variables are present, not whether external services have been successfully contacted. The AI endpoint requires a valid Supabase session and `OPENAI_API_KEY`. The existing CRM and content records are still browser-local; database-backed CRUD is not complete.
