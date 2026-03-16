---
name: tool-use-vercel-static-deploy
description: Deploy a static site or frontend build to Vercel using the Vercel CLI. Use when asked to publish a static HTML site, Vite/React/Vue app, or other frontend to Vercel quickly via command line, including install/login, setup prompts, build/output selection, and returning the deployment URL.
---

# Vercel Static Deploy

## Overview
Deploy a static or frontend project to Vercel using the fastest CLI workflow.

## Quick Start Workflow
1. Install the Vercel CLI (choose one):
   - `npm i -g vercel`
   - `pnpm add -g vercel`
   - `bun add -g vercel`
2. In the project root, run `vercel`.
3. If prompted, log in (GitHub/GitLab/Email) and select the correct scope.
4. Answer the setup prompts:
   - `Set up and deploy "<project>"?` -> Yes
   - `Link to existing project?` -> No (unless it already exists in Vercel)
   - `Build command?` -> accept default unless the project uses a custom build
   - `Output directory?` -> choose `dist` or `build` (see defaults below)
5. After deployment, copy the provided URL (e.g., `https://<name>.vercel.app`).

## Framework Defaults (CLI Auto-Detect)
- Static HTML: no build; output directory is the project root
- Vite / Vue: build `npm run build`; output `dist`
- React (CRA): build `npm run build`; output `build`
- Next.js: auto-detected; no manual output directory needed

## Notes
- If the project is already on Vercel, choose to link to the existing project instead of creating a new one.
- Keep answers minimal unless a custom build/output is required.
