# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal blog/portfolio site built with Hugo (v0.141.0+extended), a static site generator written in Go. The site (nemoworld.info) has been active since 1994-2024 and contains blog posts, projects, notes, recipes, drawings, and astronomy content.

## Development Environment

This project uses Nix for dependency management:
- `default.nix` provides a development shell with Hugo and go-task
- Enter the dev environment with `nix-shell` (if direnv is configured, it will activate automatically via `.envrc`)

## Common Commands

### Building and Development
```bash
# Start Hugo development server with live reload
hugo server

# Start server with drafts visible
hugo server -D

# Build the static site (outputs to ./public/)
hugo build

# Build with drafts included
hugo build -D

# Build with future-dated content
hugo build -F
```

### Content Creation
```bash
# Create a new blog post (uses archetypes/posts.md template)
hugo new posts/YYYY-MM-DD-title.md

# Create a new project (uses archetypes/projects.md template)
hugo new projects/project-name.md

# Create generic content
hugo new path/to/content.md
```

### Testing and Validation
```bash
# Check Hugo configuration
hugo config

# List all content
hugo list all

# View Hugo environment info
hugo env
```

## Architecture

### Site Structure
- **Content Types**: The site uses Hugo's content organization with distinct sections:
  - `posts/` - Blog posts with dates in filenames (YYYY-MM-DD-title.md)
  - `projects/` - Project showcases
  - `notes/` - Technical notes organized by topic subdirectories (e.g., `notes/esp32/`, `notes/alfresco4/`)
  - `recipes/` - Recipe content
  - Special pages: `astronomy.md`, `drawings.md`, `contact.md`

- **Custom Theme**: Uses a custom theme called "2022" located in `themes/2022/`
  - Based on hack.css and gruvbox-dark color scheme
  - Custom layouts for each content type (posts, projects, notes, recipes)
  - Includes specialized partials like `image-gallery.html` for photo galleries

### Theme Architecture
- **Layout Hierarchy**:
  - Base template: `themes/2022/layouts/_default/baseof.html`
  - Content-type specific layouts in `themes/2022/layouts/{posts,projects,notes,recipes}/`
  - Each content type has `single.html` (detail view), `list.html` (index), and `short_summary.html` (preview)

- **Shortcodes**: Custom shortcodes available:
  - `image-gallery` - Creates responsive photo galleries from a directory
  - `image` - Single image handling
  - `bspan` - Custom span formatting

### Configuration (hugo.toml)
- **Permalinks**: Posts use `/posts/:year/:month/:day/:slug/` structure
- **Syntax Highlighting**: Configured with Monokai theme, line numbers in tables
- **Taxonomies**: Uses "topics" taxonomy (not tags/categories)
- **Menu**: Six main navigation items (Blog, Projects, Astronomy, Drawings, Recipes, Notes, Contact)
- **Outputs**: HTML-only for all page types (no RSS/JSON feeds)

### Image Gallery System
The `image-gallery` shortcode (at `themes/2022/layouts/partials/image-gallery.html`) generates responsive galleries by:
1. Reading images from a specified directory in `/static`
2. Creating thumbnails (300x300 q50) and full-size versions (1600x1600 q50)
3. Integrating with lightbox.js for modal viewing
4. Usage: `{{< image-gallery gallery_dir="/path/to/images" >}}`

### Content Archetypes
- **Posts archetype** (`archetypes/posts.md`): Includes frontmatter for title, date, author, categories, and tags with placeholder lorem ipsum content
- **Projects archetype** (`archetypes/projects.md`): Minimal frontmatter with placeholder image and "Tech used" section

## Important Notes

### Content Conventions
- Blog post filenames should include date prefix: `YYYY-MM-DD-title.md`
- Use `<!--more-->` comment to define excerpt break points in posts
- Images can be colocated with posts in page bundles (e.g., `posts/2025-03-05-hardware-is-hard-no-matter-what/index.md` with images in same directory)

### Theme Styling
- Site uses hack.css framework with gruvbox-dark theme
- Custom styles in `themes/2022/static/css/style.css`
- Lightbox functionality for image viewing via `lightbox.js` and `lightbox.css`

### Git Workflow
- Main branch: `main`
- Site builds to `public/` directory (not tracked in git per `.gitignore`)
