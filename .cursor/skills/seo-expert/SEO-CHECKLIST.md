# SEO Audit Checklist

Status legend: 🔴 Critical | 🟡 Needs improvement | 🟢 Good

---

## 1. Crawlability & Indexability

- [ ] `robots.txt` exists and is correctly configured
- [ ] XML sitemap exists and is submitted to Google Search Console
- [ ] No important pages are blocked by `noindex` or `disallow`
- [ ] Canonical tags are present and point to the correct URL
- [ ] No redirect chains longer than 2 hops
- [ ] All internal links return HTTP 200 (no 404s or 301s)
- [ ] HTTPS is enabled and HTTP redirects to HTTPS
- [ ] WWW and non-WWW canonicalize to one version

---

## 2. On-Page SEO

- [ ] Every page has a unique `<title>` (≤ 60 chars)
- [ ] Every page has a unique `<meta name="description">` (≤ 155 chars)
- [ ] Every page has exactly one `<h1>` containing the primary keyword
- [ ] Heading hierarchy is logical: H1 → H2 → H3 (no skipped levels)
- [ ] Primary keyword appears in the first 100 words of body content
- [ ] Images have descriptive `alt` attributes (not empty or "image")
- [ ] URL slugs are short, lowercase, hyphen-separated, and include the keyword
- [ ] No keyword stuffing (natural keyword density, roughly 1–2%)
- [ ] Internal links use descriptive anchor text (no "click here")
- [ ] Outbound links to authoritative sources where appropriate

---

## 3. Technical SEO

- [ ] Page speed score ≥ 90 on mobile (Google PageSpeed Insights)
- [ ] Core Web Vitals pass: LCP < 2.5s, FID < 100ms, CLS < 0.1
- [ ] Site is mobile-friendly (Google Mobile-Friendly Test passes)
- [ ] No mixed content (HTTP assets on HTTPS pages)
- [ ] Structured data (JSON-LD) present where relevant
- [ ] Structured data validated with Google Rich Results Test
- [ ] hreflang tags set for multilingual pages (en / ar)
- [ ] Lazy loading implemented for below-the-fold images
- [ ] No render-blocking resources in `<head>` (defer JS where possible)
- [ ] Favicon is present

---

## 4. Local SEO

- [ ] `LocalBusiness` (or `BarberShop`) JSON-LD on homepage and contact page
- [ ] NAP (Name, Address, Phone) is identical across all citations
- [ ] Google Business Profile is claimed, verified, and fully completed
- [ ] Business listed on: Yelp, Bing Places, Apple Maps, local directories
- [ ] Google Map embed is present on the contact/location page
- [ ] Customer reviews are being actively collected
- [ ] Service area pages created for each city/neighborhood targeted
- [ ] `openingHours` schema is accurate and up to date

---

## 5. Content

- [ ] Each key page targets one primary keyword + 2–3 LSI keywords
- [ ] Content answers the user's search intent (informational / transactional / navigational)
- [ ] No duplicate content across pages (use canonical if needed)
- [ ] Blog / news section is regularly updated
- [ ] Thin pages (< 300 words on content pages) are improved or consolidated
- [ ] Every page has a clear CTA (Book Now, Call Us, etc.)

---

## 6. Link Profile

- [ ] No manual Google penalties (check Search Console)
- [ ] No toxic backlinks (disavow if necessary)
- [ ] Every page receives at least 2 internal links
- [ ] Homepage links to the most important service/landing pages
- [ ] High-quality external backlinks from relevant domains

---

## 7. Social & Open Graph

- [ ] `og:title`, `og:description`, `og:image`, `og:url` on every page
- [ ] `twitter:card`, `twitter:title`, `twitter:description`, `twitter:image` present
- [ ] OG image is 1200×630px and under 8MB
- [ ] Social profiles are linked from the website footer

---

## 8. Analytics & Monitoring

- [ ] Google Analytics (GA4) is installed and tracking
- [ ] Google Search Console is verified and sitemap submitted
- [ ] 404 error monitoring is set up
- [ ] Core Web Vitals are monitored in Search Console
- [ ] Conversion goals / events are configured in GA4
