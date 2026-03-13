# Project: Personal Portfolio + Blog

## Goal

Build a lean personal site that:

- Presents Xena and their work coherently (bio, CV, contact)
- Hosts a simple blog
- Showcases "vibe-coded" frontend pieces (linked or embedded)
- Is easy to maintain and deploy

---

## Stack (Proposed)

- **Generator:** Hugo or Zola (decide in Phase 1)
  - Leaning **Zola** if minimal tooling and simplicity are the priority
  - Leaning **Hugo** if theme ecosystem and examples are more valuable
- **Repo:** GitHub (public)
- **Host:** Netlify (build on push, HTTPS, previews)

All content lives as Markdown/templates in the repo; Netlify runs the generator and serves static HTML/CSS/JS.

---

## Site Structure

### Home
- Short positioning statement (who you are, what you do)
- Selected project highlights (with links out to live pieces later)

### About
- Longer bio, values, "intellectual friction" stance
- Links to CV, GitHub, Basilica (if desired), etc.

### Blog
- Chronological posts (Markdown)
- Minimal taxonomy (e.g. `systems`, `frontends`, `life/log`)

### Projects
- List of projects (e.g. Neon Life, Zeitgeist, future experiments)
- For each project:
  - Name
  - Short description
  - Role
  - Tech stack
  - Link to live demo and/or repo

### Contact / Links
- Email
- Socials (when/if created)
- Optional: PGP key or other public keys

---

## Aesthetic Direction (for Architect)

- **Base:** Calm, typographically driven site; no JS-heavy UI in the main frame.
- **Palette:** Harmonize with existing apparatus:
  - Ink/paper base
  - Vermilion/bronze accents in small doses
- **Layout:** Responsive, grid-based, sparse but not sterile.
  - Clear hierarchy for headings, body, meta-text
  - Respect for `prefers-reduced-motion` and contrast requirements

ZEITGEIST and Neon Life sit at the "intense" end of your aesthetics; the portfolio frame should be a little quieter so those pieces can stand out as highlights.

---

## Phases

### Phase 1 — Stack Decision & Repo Setup

- Decide Hugo vs Zola based on comfort and ecosystem needs.
- Initialize a new GitHub repo for the site.
- Scaffold the generator starter:
  - Basic content folders (`content/` or equivalent)
  - Minimal config (site title, base URL, etc.).

### Phase 2 — Barebones Theme

- Implement simple layouts for:
  - Home
  - About
  - Blog index + post template
  - Projects index + project detail (if needed)
- Focus on structure and semantic HTML; minimal styling.

### Phase 3 — Netlify Integration

- Connect the GitHub repo to Netlify.
- Configure build command and publish directory.
- Verify that pushes to main trigger clean builds and deploys.

### Phase 4 — Aesthetic Pass (Architect)

- Apply custom typography, palette, and spacing.
- Ensure accessibility:
  - Color contrast
  - Keyboard navigation
  - Reduced motion handling where relevant
- Add basic SEO/meta:
  - `<title>` and description per page
  - OpenGraph/Twitter cards for key pages

### Phase 5 — Content Seeding

- Add initial content:
  - About page
  - 1–2 blog posts (can be adapted from existing Basilica/log material)
  - 1–2 project entries (e.g. Neon Life, Zeitgeist)

### Phase 6 — Project Linking

- As individual static projects are stood up (Netlify or GitHub Pages):
  - Add links/screenshots to the Projects section
  - Optionally embed demos (iframe or similar) where appropriate

---

## Open Questions

- Hugo vs Zola: which generator best matches Xena's tolerance for setup vs ecosystem?
- How much of Basilica (if any) should be linked directly (e.g. selected research posts)?
- Do we want a dedicated "Now" or "Colophon" page to document the apparatus itself?
