import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "MAGIXA Marketing OS | منصة إدارة التسويق",
  description: "منصة موحدة لتخطيط المحتوى وإدارة العملاء والحملات التسويقية في Magixa.",
  applicationName: "MAGIXA Marketing OS",
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="ar" dir="rtl"><body>{children}</body></html>;
}
