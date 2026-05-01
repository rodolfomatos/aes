# Design

## Overview

AES generates code and documentation. The protocol itself is text-based (markdown, Makefiles, shell scripts). When AES generates frontend code, it follows the rules below.

## When This Applies

This design system applies **only when AES is building user-facing UI** (web apps, mobile apps, dashboards). The core AES protocol (SKILL.md, Makefiles, shell scripts) is exempt — those use the conventions of their native format.

## Visual Theme

**Philosophy:** Clean, minimal, professional. The interface should feel like a precision instrument — purposeful, focused, no decoration for its own sake.

- No emoji in source code (`.tsx`, `.jsx`, `.vue`, `.html`, `.css`, `.scss`)
- Use Lucide, Heroicons, or inline SVG for visual accents
- Dark mode as default for developer tools; light mode acceptable for consumer apps
- High contrast text, subtle borders, no heavy shadows

## Color Palette

| Role | Hex | Usage |
|------|-----|-------|
| Background (dark) | `#0a0a0a` | Main canvas |
| Surface (dark) | `#171717` | Cards, elevated elements |
| Border | `#262626` | Subtle dividers |
| Text primary | `#fafafa` | Main text |
| Text muted | `#737373` | Secondary text, labels |
| Accent | `#22c55e` | Success, primary actions (green) |
| Destructive | `#ef4444` | Errors, danger |
| Warning | `#f59e0b` | Warnings |

*For light mode: invert — `#ffffff` bg, `#f5f5f5` surface, `#171717` text.*

## Typography

**Font stack:**
```css
font-family: Inter, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
```

**Scale:**
| Element | Size | Weight |
|---------|------|--------|
| Display | 32px / 2rem | 700 |
| Heading 1 | 24px / 1.5rem | 600 |
| Heading 2 | 20px / 1.25rem | 600 |
| Body | 14px / 0.875rem | 400 |
| Small | 12px / 0.75rem | 400 |
| Mono | SF Mono, "Fira Code", monospace | 400 |

## Component Patterns

### Buttons

**Primary:** Accent background (#22c55e), white text, rounded-md, px-4 py-2
**Secondary:** Transparent, border border-[#262626], hover bg-[#171717]
**Destructive:** Red background (#ef4444), white text

States: hover (brightness +10%), active (brightness -5%), disabled (opacity 50%)

### Inputs

- Border: 1px solid #262626
- Background: #0a0a0a
- Focus: ring-2 ring-[#22c55e] outline-none
- Placeholder: #737373
- Height: 40px (desktop), 48px (touch)

### Cards

- Background: #171717
- Border: 1px solid #262626
- Border-radius: 8px / 0.5rem
- Padding: 16px / 1rem
- No heavy shadows — use subtle border instead

### Navigation

- Fixed top or left
- Background: #0a0a0a with bottom border #262626
- Active item: accent color indicator (left border or underline)
- Hover: bg-[#171717]

## Spacing

4px base unit:
- `4px` — tight spacing within components
- `8px` / `16px` — component internal padding
- `16px` / `24px` — between elements
- `24px` / `32px` — section separation
- `48px` / `64px` — major section breaks

## Do's and Don'ts

### Do
- Use semantic HTML elements
- Maintain consistent spacing scale
- Use the color palette above, not arbitrary colors
- Prefer system fonts, fallback to Inter
- Use Lucide/Heroicons for icons
- Support both light and dark modes

### Don't
- Use emoji as icons or visual elements in code
- Use bright/neon colors outside the palette
- Use decorative gradients (linear, radial)
- Add shadows for elevation — use borders instead
- Use more than 3 colors in a single component
- Mix serif and sans-serif fonts

## Responsive

| Breakpoint | Target |
|------------|--------|
| < 640px | Mobile — single column, larger touch targets |
| 640-1024px | Tablet — 2-column grids |
| > 1024px | Desktop — full layout |

## Agents

When building UI, read this file and generate code matching these specifications. The goal is professional, clean, predictable interfaces — not creative or playful.

## References

- [Awesome Design MD](https://github.com/voltagent/awesome-design-md) — Collection of design system files
- [Lucide Icons](https://lucide.dev/) — Icon library
- [Heroicons](https://heroicons.com/) — Alternative icon library
- [Inter Font](https://rsms.me/inter/) — Primary typeface