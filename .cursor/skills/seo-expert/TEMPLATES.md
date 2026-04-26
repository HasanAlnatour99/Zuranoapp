# SEO Templates

Copy-paste ready. Replace values in `[BRACKETS]`.

---

## Meta Tags

### General HTML

```html
<!-- Primary Meta Tags -->
<title>[Primary Keyword] – [Secondary Keyword] | [Brand Name]</title>
<meta name="description" content="[Action verb]. [Primary keyword] in [Location]. [USP or CTA]. [Brand Name].">
<meta name="robots" content="index, follow">
<link rel="canonical" href="https://[domain]/[page-slug]">

<!-- Open Graph -->
<meta property="og:type" content="website">
<meta property="og:url" content="https://[domain]/[page-slug]">
<meta property="og:title" content="[Page Title] | [Brand Name]">
<meta property="og:description" content="[Meta description text]">
<meta property="og:image" content="https://[domain]/images/og-[page-slug].jpg">
<meta property="og:locale" content="en_US">
<meta property="og:locale:alternate" content="ar_SA">

<!-- Twitter Card -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="[Page Title] | [Brand Name]">
<meta name="twitter:description" content="[Meta description text]">
<meta name="twitter:image" content="https://[domain]/images/og-[page-slug].jpg">
```

### Next.js App Router (`layout.tsx` or `page.tsx`)

```typescript
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: '[Primary Keyword] – [Secondary Keyword] | [Brand Name]',
  description: '[Action verb]. [Primary keyword] in [Location]. [USP or CTA].',
  alternates: {
    canonical: 'https://[domain]/[page-slug]',
    languages: {
      'en-US': 'https://[domain]/en/[page-slug]',
      'ar-SA': 'https://[domain]/ar/[page-slug]',
    },
  },
  openGraph: {
    title: '[Page Title] | [Brand Name]',
    description: '[Meta description text]',
    url: 'https://[domain]/[page-slug]',
    siteName: '[Brand Name]',
    images: [{ url: 'https://[domain]/images/og-[page-slug].jpg', width: 1200, height: 630 }],
    locale: 'en_US',
    type: 'website',
  },
  twitter: {
    card: 'summary_large_image',
    title: '[Page Title] | [Brand Name]',
    description: '[Meta description text]',
    images: ['https://[domain]/images/og-[page-slug].jpg'],
  },
};
```

### Next.js Pages Router (`_document.tsx` or page component)

```tsx
import Head from 'next/head';

<Head>
  <title>[Primary Keyword] – [Secondary Keyword] | [Brand Name]</title>
  <meta name="description" content="[Meta description text]" />
  <link rel="canonical" href="https://[domain]/[page-slug]" />
  <meta property="og:title" content="[Page Title] | [Brand Name]" />
  <meta property="og:description" content="[Meta description text]" />
  <meta property="og:image" content="https://[domain]/images/og-[page-slug].jpg" />
  <meta property="og:url" content="https://[domain]/[page-slug]" />
  <meta name="twitter:card" content="summary_large_image" />
</Head>
```

### Flutter Web (`index.html` `<head>` section)

```html
<!-- Place inside <head> in web/index.html -->
<title>[Primary Keyword] | [Brand Name]</title>
<meta name="description" content="[Meta description text]">
<link rel="canonical" href="https://[domain]/">
<meta property="og:title" content="[Page Title] | [Brand Name]">
<meta property="og:description" content="[Meta description text]">
<meta property="og:image" content="https://[domain]/icons/og-image.jpg">
<meta property="og:url" content="https://[domain]/">
<meta name="twitter:card" content="summary_large_image">
```

> **Note**: Flutter web renders a single `index.html`. For per-route meta tags, use a server-side proxy (e.g. Firebase Hosting rewrites + Cloud Functions) or move SEO-critical pages to Next.js.

---

## Structured Data (JSON-LD)

### BarberShop / LocalBusiness

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BarberShop",
  "name": "[Salon Name]",
  "image": "https://[domain]/images/salon-photo.jpg",
  "url": "https://[domain]",
  "telephone": "+[CountryCode][PhoneNumber]",
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "[Street Address]",
    "addressLocality": "[City]",
    "addressRegion": "[State/Region]",
    "postalCode": "[ZIP]",
    "addressCountry": "[ISO 2-letter country code, e.g. SA]"
  },
  "geo": {
    "@type": "GeoCoordinates",
    "latitude": [LATITUDE],
    "longitude": [LONGITUDE]
  },
  "openingHoursSpecification": [
    {
      "@type": "OpeningHoursSpecification",
      "dayOfWeek": ["Saturday","Sunday","Monday","Tuesday","Wednesday","Thursday"],
      "opens": "09:00",
      "closes": "22:00"
    }
  ],
  "priceRange": "$$",
  "servesCuisine": null,
  "sameAs": [
    "https://www.instagram.com/[handle]",
    "https://www.facebook.com/[handle]",
    "https://g.page/[google-business-slug]"
  ]
}
</script>
```

### Service Schema

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Service",
  "serviceType": "[Service Name, e.g. Haircut & Styling]",
  "provider": {
    "@type": "BarberShop",
    "name": "[Salon Name]",
    "url": "https://[domain]"
  },
  "areaServed": {
    "@type": "City",
    "name": "[City Name]"
  },
  "offers": {
    "@type": "Offer",
    "price": "[Price]",
    "priceCurrency": "[ISO currency, e.g. SAR]"
  }
}
</script>
```

### FAQ Schema

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "[Question 1?]",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "[Answer 1.]"
      }
    },
    {
      "@type": "Question",
      "name": "[Question 2?]",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "[Answer 2.]"
      }
    }
  ]
}
</script>
```

---

## Sitemap (`sitemap.xml`)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
        xmlns:xhtml="http://www.w3.org/1999/xhtml">

  <url>
    <loc>https://[domain]/</loc>
    <lastmod>[YYYY-MM-DD]</lastmod>
    <changefreq>weekly</changefreq>
    <priority>1.0</priority>
    <xhtml:link rel="alternate" hreflang="en" href="https://[domain]/en/"/>
    <xhtml:link rel="alternate" hreflang="ar" href="https://[domain]/ar/"/>
  </url>

  <url>
    <loc>https://[domain]/services</loc>
    <lastmod>[YYYY-MM-DD]</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://[domain]/book</loc>
    <lastmod>[YYYY-MM-DD]</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.9</priority>
  </url>

  <url>
    <loc>https://[domain]/contact</loc>
    <lastmod>[YYYY-MM-DD]</lastmod>
    <changefreq>yearly</changefreq>
    <priority>0.5</priority>
  </url>

</urlset>
```

---

## robots.txt

```
User-agent: *
Allow: /

Disallow: /admin/
Disallow: /dashboard/
Disallow: /api/
Disallow: /*.json$

Sitemap: https://[domain]/sitemap.xml
```

---

## hreflang Tags (EN / AR)

```html
<link rel="alternate" hreflang="en" href="https://[domain]/en/[page-slug]">
<link rel="alternate" hreflang="ar" href="https://[domain]/ar/[page-slug]">
<link rel="alternate" hreflang="x-default" href="https://[domain]/[page-slug]">
```

---

## SEO Copy Templates

### Homepage Title & Description

```
Title:    [City]'s Best Barber Shop – Haircuts & Grooming | [Salon Name]
Desc:     Book a professional haircut or beard trim at [Salon Name] in [City]. Expert barbers, premium grooming services. Walk-ins welcome. Book online today!
```

### Service Page

```
Title:    [Service Name] in [City] – [Salon Name] Barber Shop
Desc:     Get a professional [Service Name] at [Salon Name] in [City]. Experienced barbers, affordable prices. Book your appointment now.
```

### Local Landing Page

```
Title:    Barber Shop in [Neighborhood/District], [City] | [Salon Name]
Desc:     Looking for a barber in [Neighborhood], [City]? [Salon Name] offers expert cuts, beard trims & styling. Conveniently located. Book online or call us.
```

### Blog Post (Informational)

```
Title:    [Number] Tips for [Topic] – [Salon Name] Blog
Desc:     Discover [Number] expert tips on [Topic] from the professionals at [Salon Name]. Read now and level up your grooming routine.
```
