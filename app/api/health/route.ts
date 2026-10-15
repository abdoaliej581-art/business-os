import { NextResponse } from "next/server";
export function GET() { return NextResponse.json({ status: "ok", application: "MAGIXA Marketing OS", version: "0.1.0", mode: "demo", integrations: { ai: false, database: false, socialPublishing: false } }); }
