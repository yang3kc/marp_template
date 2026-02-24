# Marp Slide Template

A reusable slide template with custom themes and a Make-based build system for [Marp](https://marp.app/) (Markdown Presentation Ecosystem).

## Quick Start

### Prerequisites

- **Node.js** (for Marp CLI via npx)
- **Chrome/Chromium/Firefox** (for PDF export)
- Recommended: [Marp for VS Code](https://marketplace.visualstudio.com/items?itemName=marp-team.marp-vscode) extension for in-editor preview

### Create Slides

1. Copy `example.md` as a starting point
2. Edit your slides in Markdown — use `---` to separate slides
3. Build to PDF:
   ```bash
   make all                    # Build all slides
   make PDFs/example.pdf       # Build a single file
   ```

### Preview & Development

```bash
# Live preview in browser
npx @marp-team/marp-cli@latest -p example.md

# Watch mode (auto-rebuild on save)
npx @marp-team/marp-cli@latest -w example.md
```

## Custom Themes

Three themes are available: `am_crimson`, `am_blue`, `am_template`. Set the theme in your front matter:

```yaml
---
marp: true
theme: am_crimson
paginate: true
headingDivider: [2,3]
---
```

### Slide Classes

Apply with `<!-- _class: classname -->`:

| Category | Classes |
|----------|---------|
| **Cover** | `cover_a`, `cover_b`, `cover_c`, `cover_d`, `cover_e` |
| **Table of contents** | `toc_a`, `toc_b` |
| **Columns** | `cols-2`, `cols-3`, `cols-2-64`, `cols-2-46`, `cols-2-73`, `cols-2-37` |
| **Rows** | `rows-2`, `pin-3` |
| **Lists** | `col1_ol_sq`, `col1_ol_ci`, `cols2_ol_sq`, `cols2_ol_ci`, `cols2_ul_sq`, `cols2_ul_ci` |
| **Special** | `trans`, `caption`, `navbar`, `lastpage`, `footnote` |
| **Text size** | `tinytext`, `smalltext`, `largetext`, `hugetext` |
| **Blockquote** | `bq-blue`, `bq-red`, `bq-green`, `bq-purple`, `bq-black` |

### Column Layouts

```markdown
<!-- _class: cols-2 -->
## Slide Title

<div class="ldiv">
Left content
</div>

<div class="rdiv">
Right content
</div>
```

Use `ldiv`/`rdiv` for text, `limg`/`rimg` for images.

### Image Modifiers

Images have drop shadows by default. Control with alt text modifiers:

- `#noshadow` or `#ns` — remove shadow
- `#l` — float left
- `#r` — float right
- `#c` — center

Example: `![Diagram #c #ns](images/diagram.png)`

## Build System

```bash
make all       # Build all slides to PDFs/
make list      # Show available markdown files
make clean     # Remove all generated PDFs
make help      # Show all targets
```

To build with custom themes manually:

```bash
npx @marp-team/marp-cli@latest slides/deck.md -o output.pdf --pdf --theme-set themes/*.scss --allow-local-files
```

## VS Code Snippets

Two snippets are included for slide authoring:

- `page_1_fig` — page with centered figure and caption
- `page_trans` — transition slide

## Resources

- [Marp Official Site](https://marp.app/)
- [Marp CLI Documentation](https://github.com/marp-team/marp-cli)
- [Marpit Framework (directives, themes)](https://marpit.marp.app/)

## License

MIT
