# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Marp slide template repository with custom themes and a Make-based build system.

## Build Commands

### Build All Slides to PDF

```bash
make all
```

This converts all `.md` files (excluding README.md, CLAUDE.md, and example.md) to PDFs in `PDFs/`.

### Build Single Slide Deck

```bash
make PDFs/example.pdf
```

### Other Makefile Targets

```bash
make list    # Show available markdown files
make clean   # Remove all generated PDFs
make help    # Show all available targets
```

### Direct Marp CLI Usage

```bash
# Preview with live reload
npx @marp-team/marp-cli@latest -p example.md

# Watch mode
npx @marp-team/marp-cli@latest -w example.md

# Convert to PDF manually (custom themes require --theme-set)
npx @marp-team/marp-cli@latest example.md -o output.pdf --pdf --theme-set themes/*.scss --allow-local-files
```

## Custom Marp Themes

Three custom themes are available: `am_crimson`, `am_blue`, `am_template`.

### Slide Classes

Use `<!-- _class: classname -->` to apply these layouts:

**Cover slides:** `cover_a`, `cover_b`, `cover_c`, `cover_d`, `cover_e`
**Table of contents:** `toc_a`, `toc_b`
**Column layouts:** `cols-2`, `cols-3`, `cols-2-64`, `cols-2-46`, `cols-2-73`, `cols-2-37`
**Row layouts:** `rows-2`, `pin-3`
**List styles:** `col1_ol_sq`, `col1_ol_ci`, `cols2_ol_sq`, `cols2_ol_ci`, `cols2_ul_sq`, `cols2_ul_ci`
**Special:** `trans` (transition), `caption`, `navbar`, `lastpage`, `footnote`
**Text size:** `tinytext`, `smalltext`, `largetext`, `hugetext`
**Blockquote colors:** `bq-blue`, `bq-red`, `bq-green`, `bq-purple`, `bq-black`

### Image Modifiers

Images have drop shadows by default. Control with alt text:
- `#noshadow` or `#ns` - Remove shadow
- `#l` - Float left
- `#r` - Float right
- `#c` - Center

Example: `![My image #c #ns](image.png)`

### Column Layout Usage

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

## VS Code Snippets

Two snippets are available for slide authoring:
- `page_1_fig` - Page with centered figure and caption
- `page_trans` - Transition slide
