---
name: seo-expert
description: Comprehensive SEO assistant covering on-page meta tags, technical SEO (sitemaps, robots.txt, structured data / JSON-LD), local SEO (Google Business, NAP, local schema), SEO-optimized content writing, keyword research, link building, and audit checklists. Produces ready-to-use code snippets, meta copy, and structured checklists for Flutter web, Next.js, WordPress, and general web projects. Use when the user asks about SEO, meta tags, structured data, Google rankings, sitemaps, robots.txt, schema markup, local SEO, page speed, content optimization, link strategy, or running an SEO audit.
---

# SEO Expert

## How to Use This Skill

Read this file first, then follow the workflow for the requested task.
For detailed checklists → [SEO-CHECKLIST.md](SEO-CHECKLIST.md)
For ready-made code & copy templates → [TEMPLATES.md](TEMPLATES.md)

---

## Workflows

### 1. On-Page SEO (Meta Tags)

1. Identify the page type (home, service, blog, product, local landing).
2. Craft a **title tag**: `Primary Keyword – Secondary | Brand` — max 60 chars.
3. Craft a **meta description**: action-oriented, includes keyword, max 155 chars.
4. Add **Open Graph** + **Twitter Card** tags.
5. Set canonical URL.
6. See [TEMPLATES.md → Meta Tags](TEMPLATES.md) for copy-paste snippets.

### 2. Technical SEO

| Task | Output |
|---|---|
| Sitemap | XML file with all indexable URLs + `lastmod` |
| Robots.txt | Disallow staging/admin; allow all for production |
| Structured Data | JSON-LD injected in `<head>` |
| Canonical tags | Prevent duplicate content |
| hreflang | For multi-language (en / ar) pages |

For each task, produce the actual file or code block — never just describe it.

**Flutter Web**: Inject meta/JSON-LD via `index.html` or a `usePathUrlStrategy()` + server-side rendering approach. Note: Flutter web has limited SEO; recommend a Next.js landing page for SEO-critical pages.

**Next.js**: Use `<Head>` (Pages Router) or `export const metadata` (App Router). Generate sitemap with `next-sitemap` package.

**WordPress**: Use Yoast SEO or Rank Math plugin. Provide schema shortcodes or `functions.php` snippets when needed.

### 3. Local SEO

1. Confirm NAP (Name, Address, Phone) is identical everywhere.
2. Add `LocalBusiness` JSON-LD (or `BarberShop` sub-type).
3. Embed a Google Map iframe.
4. List citation sources: Google Business Profile, Yelp, Bing Places, Apple Maps.
5. See [TEMPLATES.md → Local SEO Schema](TEMPLATES.md).

### 4. SEO-Optimized Content

- Lead with the primary keyword in the first 100 words.
- Use heading hierarchy: H1 (one only) → H2 → H3.
- Target 1 primary keyword + 2–3 LSI keywords per page.
- Keep sentences short; readability grade ≤ 8.
- Include a clear CTA.
- Add alt text to every image: `[keyword] in [location]`.

### 5. Keyword Research

When asked for keyword research:
1. Identify seed keyword from user's topic.
2. Suggest keyword clusters: informational, navigational, transactional.
3. Estimate intent and competition (high / medium / low) based on context.
4. Provide a prioritized list in a markdown table.

### 6. Link Building & Internal Linking

**Internal linking rules:**
- Every new page should receive ≥ 2 internal links.
- Anchor text must be descriptive (no "click here").
- Link from high-authority pages to new/low-authority ones.

**External link building checklist:**
- [ ] Submit to local directories (NAP consistency required).
- [ ] Guest post on relevant industry blogs.
- [ ] Create linkable assets (free tools, guides, infographics).
- [ ] Reclaim unlinked brand mentions.

### 7. SEO Audit

Run through [SEO-CHECKLIST.md](SEO-CHECKLIST.md) top-to-bottom.
Report findings as: 🔴 Critical | 🟡 Needs improvement | 🟢 Good

---

## Output Format Rules

- **Code** → always inside fenced code blocks with the correct language tag.
- **Copy** → title tag and meta description each on their own clearly labelled line.
- **Audits** → use the 🔴/🟡/🟢 status system.
- **Strategy** → numbered steps, no walls of text.

---

## Platform Quick Reference

| Platform | Meta tags | Sitemap | Schema |
|---|---|---|---|
| Next.js (App Router) | `metadata` export | `next-sitemap` | JSON-LD in `<script>` |
| Next.js (Pages Router) | `<Head>` component | `next-sitemap` | JSON-LD in `<Head>` |
| Flutter Web | `index.html` `<head>` | static `sitemap.xml` | `index.html` `<head>` |
| WordPress | Yoast / Rank Math | Auto-generated | Plugin or `functions.php` |
| General HTML | `<head>` tags | static `sitemap.xml` | `<script type="application/ld+json">` |

---

## Additional Resources

- Detailed audit checklist → [SEO-CHECKLIST.md](SEO-CHECKLIST.md)
- Copy & code templates → [TEMPLATES.md](TEMPLATES.md)
