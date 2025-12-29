# Content with Inline HTML

This document lists all markdown content files that contain inline HTML tags.
These files require `unsafe = true` in Hugo's goldmark renderer config.

Generated: 2025-12-29

## Posts

| File | HTML Tags | Notes |
|------|-----------|-------|
| `2009-06-21-eee-pc-1000he.md` | `<a>` `<img>` | Images with float styles |
| `2010-06-28-back-to-the-basics.md` | `<img>` `<p>` | Images with float/alignment styles |
| `2010-09-02-2-feral-cats-visiting-us.md` | `<object>` `<param>` `<embed>` | Flash video - non-functional |
| `2010-10-06-diy-and-opensource.md` | `<a>` | Link with title attribute |
| `2010-11-15-a-new-way.md` | `<img>` | Image with float style |
| `2011-03-21-spring-is-here.md` | `<style>` `<p>` `<a>` `<img>` `<br>` | Photo gallery with custom CSS |
| `2011-03-27-successfully_trapped.md` | `<style>` `<p>` `<a>` `<img>` | Photo gallery with custom CSS |
| `2014-08-22-its-time-to-start-archiving.md` | `<strong>` `<a>` `<p>` | Text formatting and links |
| `2015-01-19-first-step-gathering.md` | `<a>` | Link with title attribute |
| `2016-02-22-adding_recipes.md` | `<a>` | Link |
| `2016-06-26-first-saturn-astropic.md` | `<img>` | Image |

## Summary

- **11 posts** with inline HTML
- Date range: 2009-2016 (legacy content)
- Most common usage: `<img>` with inline styles for float layouts
- 1 post contains dead Flash embed (`2010-09-02-2-feral-cats-visiting-us.md`)

## Recommendations

1. **Low priority**: These are old posts and the HTML works fine with `unsafe = true`
2. **Optional cleanup**: Could convert `<img>` tags to Hugo shortcodes or markdown images
3. **Dead content**: The Flash embed in `2010-09-02` could be removed or replaced with a note
