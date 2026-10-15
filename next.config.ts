import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  poweredByHeader: false,
  reactStrictMode: true,
  // Lint is checked separately by the CI workflow; keep build diagnostics focused on compilation.
  eslint: { ignoreDuringBuilds: true },
};

export default nextConfig;
