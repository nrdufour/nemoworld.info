# Nemoworld 2026 Theme - Documentation

## Overview

The 2026 theme is a minimal, clean theme with dark and light mode support, botanical ornaments, and modern accessibility features.

## Theme Switching

### Implementation
- JavaScript-based theme switcher in `/static/js/theme.js`
- Theme preference stored in localStorage with key `theme-preference`
- Automatically detects system color scheme preference
- Toggle button placed in navigation bar (sun/moon icons)

### Color Schemes

**Dark Theme (default)**:
- Primary background: `#0a1929`
- Secondary background: `#132f4c`
- Primary text: `#e3f2fd`
- Accent: `#64b5f6` (light blue)

**Light Theme**:
- Primary background: `#f5f7fa`
- Secondary background: `#ffffff`
- Primary text: `#1a2332`
- Accent: `#2563eb` (blue)

### Usage
The theme automatically applies based on:
1. User's explicit choice (stored in localStorage)
2. System preference (`prefers-color-scheme` media query)
3. Defaults to dark theme if no preference is set

## Ornaments

### Site Title Ornaments

Located at: `/static/images/leaf-left.svg` and `/static/images/leaf-right.svg`

**Design**:
- Simple curly leaf shape with visible ribs (veins)
- Each leaf includes a small stem connecting toward the title
- Mirror-symmetrical design
- Size: 50x30px
- Color: `#64b5f6` (matching accent color)
- Opacity: 0.5 for subtle effect

**Structure**:
- Filled leaf body with 25% opacity for depth
- Outlined stroke for definition
- Central rib (midrib) running through the leaf
- Side veins branching from central rib
- Stroke width: 2px for main outline, 1.5px for ribs, 1px for veins

**CSS Styling** (in `style.css`):
```css
.nav-brand {
  display: flex;
  align-items: center;
  gap: 0.75em;
}

.leaf-ornament {
  width: 50px;
  height: 30px;
  opacity: 0.5;
  flex-shrink: 0;
  align-self: center;
}
```

### Divider Ornaments

Located at: `/static/images/ornament-left.svg` and `/static/images/ornament-right.svg`

**Design**:
- Botanical branch with multiple pairs of leaves
- Realistic leaf shapes with visible veining
- Size: 120x60px
- Color: `#64b5f6`
- Opacity: 0.6

**Structure**:
- Main horizontal stem with subtle wave/curve
- Five pairs of leaves with gradually decreasing sizes
- Filled leaves (30% opacity) with stroke outlines
- Central vein (midrib) with side veins for detail
- Stroke width: 2.5px for outlines, 1.5px for central vein, 1px for side veins

**CSS Styling** (in `style.css`):
```css
.ornament-divider {
  position: relative;
  width: 100%;
  margin: 3em auto 2em;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 2em;
}

.ornament-left,
.ornament-right {
  width: 120px;
  height: 60px;
  opacity: 0.6;
}
```

**Placement**:
- Positioned between main content and footer
- Defined in `layouts/_default/baseof.html` and `layouts/index.html`
- Centered with gap between left and right ornaments

## Typography

### Fonts
- Body text: Inter (with fallbacks to system fonts)
- Headings & code: Fantasque Sans Mono
- Font files located in `/static/fonts/`

### Markdown-Style Headers
All headers include prefix symbols:
- H1: `# ` prefix
- H2: `## ` prefix
- H3: `### ` prefix
- H4: `#### ` prefix
- H5: `##### ` prefix
- H6: `###### ` prefix

Color: Accent color (blue in both themes)

## Navigation

### Structure
Located in `/layouts/partials/nav.html`

**Components**:
1. Brand section with leaf ornaments flanking the site title
2. Navigation links separated by `…` (ellipsis) character
3. RSS feed link (with icon, no separator)
4. Theme toggle button (no separator)

### Navigation Items
Menu items defined in `hugo.toml` under `[menu.nav]`

Current items:
- Blog
- Projects
- Astronomy
- Drawings
- Recipes
- Notes
- Contact

### RSS & Theme Toggle
Both elements are included in the HTML template (not added via JavaScript) for:
- Better SEO
- Accessibility without JavaScript
- Progressive enhancement

JavaScript in `/static/js/theme.js` initializes the theme toggle button with:
- Correct icon based on current theme
- Click handler for theme switching
- ARIA labels for accessibility

## Social Media Icons

### Implementation
JavaScript in `/static/js/social-icons.js` automatically adds icons to social media links.

**Supported platforms**:
- GitHub
- Mastodon (with auto-detection)
- LinkedIn
- Flickr
- Twitter/X
- YouTube
- Instagram

**CSS Styling**:
Lists containing social media links have bullets removed:
```css
ul:has(.social-link-wrapper) {
  list-style: none;
  margin-left: 0;
}
```

## Accessibility Features

### Keyboard Navigation
- Skip to main content link (appears on focus)
- Proper focus states for all interactive elements
- Tab-friendly navigation

### ARIA Labels
- Theme toggle button
- RSS link
- Ornament images marked as `aria-hidden="true"`

### Focus States
- Visible focus outlines using `:focus-visible`
- Accent-colored outlines for consistency
- Skip link keyboard accessible

### Responsive Design
Mobile breakpoint: 768px
- Navigation becomes touch-friendly with larger tap targets
- Images and grids adapt to smaller screens
- Flexible typography with `clamp()`

## File Structure

```
themes/2026/
├── layouts/
│   ├── _default/
│   │   ├── baseof.html       # Base template with ornaments
│   │   ├── list.html          # List pages
│   │   └── single.html        # Single pages
│   ├── partials/
│   │   ├── head.html          # Meta tags and scripts
│   │   ├── nav.html           # Navigation with leaf ornaments
│   │   └── footer.html        # Footer content
│   ├── index.html             # Home page (separate layout with ornaments)
│   └── [content-types]/       # Specific layouts for posts, projects, etc.
├── static/
│   ├── css/
│   │   └── style.css          # Main stylesheet
│   ├── js/
│   │   ├── theme.js           # Theme switcher
│   │   ├── social-icons.js    # Social media icon injection
│   │   └── gallery.js         # Image gallery functionality
│   ├── images/
│   │   ├── leaf-left.svg      # Title ornament (left)
│   │   ├── leaf-right.svg     # Title ornament (right)
│   │   ├── ornament-left.svg  # Divider ornament (left)
│   │   └── ornament-right.svg # Divider ornament (right)
│   └── fonts/
│       ├── inter.woff2
│       ├── inter-bold.woff2
│       └── fantasque-sans-mono.woff2
└── THEME_NOTES.md             # This file
```

## Design Principles

1. **Minimalism**: Clean, focused design without unnecessary elements
2. **Botanical Touch**: Subtle ornamental elements add visual interest without overwhelming
3. **Accessibility First**: Keyboard navigation, screen reader support, proper contrast
4. **Progressive Enhancement**: Core functionality works without JavaScript
5. **Responsive**: Mobile-friendly with touch-optimized controls
6. **Performance**: Minimal JavaScript, optimized assets

## Customization Notes

### Changing Ornament Colors
Edit the SVG files and change the `stroke` and `fill` attributes:
- Current color: `#64b5f6` (light blue)
- Should match the accent color in CSS variables

### Adjusting Ornament Size
Update both the SVG viewBox and CSS:
- SVG `width` and `height` attributes
- CSS `.leaf-ornament` or `.ornament-left/.ornament-right` dimensions

### Modifying Theme Colors
Edit CSS variables in `/static/css/style.css`:
- `:root` for dark theme
- `:root[data-theme="light"]` for light theme
- `@media (prefers-color-scheme: light)` for auto-detection

### Navigation Separators
Currently using `…` (ellipsis) character in `/layouts/partials/nav.html`
Change the separator by editing the Hugo template:
```html
{{- if ne $index 0 }} … {{ end -}}
```

## Browser Compatibility

- Modern browsers (Chrome, Firefox, Safari, Edge)
- CSS `:has()` selector used for social links (requires recent browser)
- Fallback to default list styling if `:has()` not supported
- JavaScript theme switcher works in all modern browsers
- System preference detection via `prefers-color-scheme`

## Credits

- Design: Nicolas Dufour
- Font: Inter (Rasmus Andersson)
- Font: Fantasque Sans Mono
- Built with: Hugo static site generator
