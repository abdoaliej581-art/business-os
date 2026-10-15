import { NextResponse } from "next/server";

export const dynamic = "force-dynamic";

export function GET() {
  const databaseConfigured = Boolean(
    process.env.NEXT_PUBLIC_SUPABASE_URL &&
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
  );
  const aiConfigured = Boolean(process.env.AI_PROVIDER_API_KEY);

  return NextResponse.json({
    status: "ok",
    application: "MAGIXA Marketing OS",
    version: "0.1.0",
    mode: databaseConfigured ? "configuration-present" : "demo",
    integrations: {
      ai: { configured: aiConfigured, connected: false },
      database: { configured: databaseConfigured, connected: false },
      socialPublishing: { configured: false, connected: false },
      email: { configured: false, connected: false },
      analyticsImport: { configured: false, connected: false },
    },
    note: "Configuration presence is not a live connectivity check.",
  });
}
