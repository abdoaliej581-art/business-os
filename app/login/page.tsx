"use client";

import { FormEvent, useState } from "react";
import { createBrowserClient } from "@supabase/ssr";
import Link from "next/link";

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [mode, setMode] = useState<"login" | "signup">("login");
  const [message, setMessage] = useState("");
  const [busy, setBusy] = useState(false);
  const configured = Boolean(process.env.NEXT_PUBLIC_SUPABASE_URL && process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY);

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setMessage("");
    if (!configured) {
      setMessage("تسجيل الدخول غير مفعّل بعد. يلزم إعداد مشروع Supabase مستقل وإضافة متغيرات البيئة في Vercel.");
      return;
    }
    setBusy(true);
    try {
      const supabase = createBrowserClient(
        process.env.NEXT_PUBLIC_SUPABASE_URL!,
        process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
      );
      if (mode === "login") {
        const { error } = await supabase.auth.signInWithPassword({ email: email.trim(), password });
        if (error) throw error;
        window.location.assign("/");
      } else {
        const { data, error } = await supabase.auth.signUp({
          email: email.trim(),
          password,
          options: { emailRedirectTo: `${window.location.origin}/auth/callback` },
        });
        if (error) throw error;
        if (data.session) { window.location.assign("/"); return; }
        setMessage("تم إرسال رسالة تأكيد إذا كان البريد صالحًا. أكّد البريد ثم سجّل الدخول.");
      }
    } catch (error) {
      setMessage(error instanceof Error ? error.message : "تعذر إتمام العملية. حاول مرة أخرى.");
    } finally {
      setBusy(false);
    }
  }

  return (
    <main dir="rtl" className="auth-shell">
      <section className="auth-card">
        <Link href="/" className="auth-brand">MAGIXA <span>Marketing OS</span></Link>
        <p className="auth-kicker">منصة إدارة التسويق والنمو</p>
        <h1>{mode === "login" ? "أهلاً بعودتك" : "أنشئ حسابك"}</h1>
        <p className="auth-subtitle">سجّل الدخول لإدارة المحتوى والعملاء والحملات في مساحة واحدة.</p>
        {!configured && <div className="auth-notice">وضع العرض التجريبي نشط. لن يتم قبول تسجيل الدخول حتى يتم إعداد Supabase.</div>}
        <form onSubmit={submit} className="auth-form">
          <label htmlFor="email">البريد الإلكتروني</label>
          <input id="email" type="email" autoComplete="email" required value={email} onChange={(e) => setEmail(e.target.value)} placeholder="name@example.com" />
          <label htmlFor="password">كلمة المرور</label>
          <input id="password" type="password" autoComplete={mode === "login" ? "current-password" : "new-password"} minLength={8} required value={password} onChange={(e) => setPassword(e.target.value)} placeholder="8 أحرف على الأقل" />
          <button type="submit" disabled={busy}>{busy ? "جارٍ التنفيذ..." : mode === "login" ? "تسجيل الدخول" : "إنشاء حساب"}</button>
        </form>
        {message && <p role="status" className="auth-message">{message}</p>}
        <button className="auth-switch" type="button" onClick={() => { setMode(mode === "login" ? "signup" : "login"); setMessage(""); }}>
          {mode === "login" ? "ليس لديك حساب؟ أنشئ حسابًا" : "لديك حساب بالفعل؟ سجّل الدخول"}
        </button>
        <p className="auth-footnote">لا تستخدم بيانات عملاء حقيقية قبل اكتمال ربط قاعدة البيانات واختبارات الأمان.</p>
      </section>
    </main>
  );
}
