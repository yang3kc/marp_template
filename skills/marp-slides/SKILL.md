---
name: marp-slides
description: Author and build Marp slide decks using custom themes and a Make-based build system. Apply this skill when the user asks to create slides, add a presentation deck to a project, build PDF slides, or author Marp markdown. Provides init/sync scripts to bootstrap a slides directory in a project repo and to pull theme/Makefile updates from upstream.
---

# Marp Slides

## When to Apply

Apply this skill when the user says things like:
- "create slides", "make a slide deck", "add a Marp presentation"
- "add slides to this project", "set up slides under `materials/slides/`"
- "build PDF slides", "author a Marp deck"
- "update slide themes", "sync slide template", "sync themes from the template"

Do **not** apply if slides already exist in the project using a different system (PPTX, Quarto reveal, LaTeX beamer, etc.) unless the user explicitly wants to switch.

## End-State: What a Project's Slides Directory Looks Like

After `init.sh` runs, a project's slides directory contains:

```
<project>/slides/          (or materials/slides/, talks/, etc.)
├── Makefile
├── template_slides.md     ← starter deck; rename/copy for each new deck
├── themes/
│   ├── am_template.scss
│   ├── am_crimson.scss
│   └── am_blue.scss
└── .vscode/
    ├── settings.json
    └── slides_snippets.code-snippets
```

`PDFs/` and `node_modules/` are appended to the project's `.gitignore` (not committed).

Decks live directly inside `slides/` or in subdirectories like `slides/lectures/`, `slides/talks/`, etc. The Makefile discovers all `*.md` files automatically (excluding `README.md` and `template_slides.md`).

## Bootstrap a New Project's Slides

To add a slides infrastructure to a project, run `init.sh` from the skill directory:

```bash
# From this skill's directory:
bash scripts/init.sh <absolute-path-to-target-slides-dir>

# Example:
bash scripts/init.sh /path/to/my-project/materials/slides
```

`init.sh` will:
1. Create the target directory.
2. Copy `themes/`, `Makefile`, `template_slides.md`, and `vscode/` → `.vscode/` into the target.
3. Append `PDFs/` and `node_modules/` to the nearest enclosing `.gitignore` (creates one at the project root if none exists).
4. Print a summary and next steps.

It refuses to run if `themes/` already exists in the target (use `sync.sh` instead).

After `init.sh`, the natural next steps are:
1. Copy `template_slides.md` to a new name (e.g., `lectures/01_introduction.md`).
2. Edit the new deck.
3. Run `make` to build all decks to `PDFs/`.

## Sync Upstream Changes into an Existing Project

To pull theme or Makefile updates from this skill into an existing project:

```bash
bash scripts/sync.sh <absolute-path-to-target-slides-dir>

# Force-overwrite without prompting:
bash scripts/sync.sh --force <absolute-path-to-target-slides-dir>
```

`sync.sh` will:
1. Show local modifications to `themes/` and `Makefile` before overwriting (via `git diff`).
2. Ask for confirmation if there are local diffs (or skip with `--force`).
3. Overwrite `themes/` and `Makefile` from this skill's bundled copies.
4. Print the resulting `git diff --stat`.

## Custom Marp Themes

Three themes are available: `am_crimson`, `am_blue`, `am_template`.

Set the theme in the slide front matter:

```yaml
---
marp: true
size: 16:9
theme: am_crimson
paginate: true
---
```

**Do not add `headingDivider`.** It inserts a slide break before every heading
at the listed levels, which strands a `<!-- _class: ... -->` directive on its own
blank slide and leaves the heading unstyled on the next one — silently turning
one transition slide into two broken ones. Use explicit `---` separators.

## Slide Classes

Use `<!-- _class: classname -->` in any slide to apply a layout:

**Cover slides:** `cover_a`, `cover_b`, `cover_c`, `cover_d`, `cover_e`
**Table of contents:** `toc_a`, `toc_b`
**Column layouts:** `cols-2`, `cols-3`, `cols-2-64`, `cols-2-46`, `cols-2-73`, `cols-2-37`
**Row layouts:** `rows-2`, `pin-3`
**List styles:** `col1_ol_sq`, `col1_ol_ci`, `cols2_ol_sq`, `cols2_ol_ci`, `cols2_ul_sq`, `cols2_ul_ci`
**Special:** `trans` (transition), `caption`, `navbar`, `lastpage`, `footnote`
**Text size:** `tinytext`, `smalltext`, `largetext`, `hugetext`
**Blockquote colors:** `bq-blue`, `bq-red`, `bq-green`, `bq-purple`, `bq-black`

## Column Layout Usage

```markdown
<!-- _class: cols-2 -->

##### Slide Title

<div class="ldiv">

Left content

</div>

<div class="rdiv">

Right content

</div>
```

Use `ldiv`/`rdiv` for text, `limg`/`rimg` for images.

## Image Modifiers

Images have drop shadows by default. Control via alt text:

| Modifier | Effect |
|---|---|
| `#noshadow` or `#ns` | Remove shadow |
| `#l` | Float left |
| `#r` | Float right |
| `#c` | Center |

Example: `![My image #c #ns](image.png)`

## Sizing Figures

Size with Marp's native syntax — `![h:300px](image.png)` or `![w:1050px](image.png)`.
Both are honoured exactly and preserve the source aspect ratio.

- **Set the binding dimension only.** Use `w:` for wide figures and `h:` for
  tall ones. Setting both distorts.
- **Usable content box**, measured for this theme at 16:9. Max figure height on
  a slide with a title is about **540 CSS px** (560 overflows); widths by layout:

  | Container | Width |
  |---|---|
  | full-width slide | **1123 px** |
  | `cols-2-64` left panel | **674 px** |
  | `cols-2` half panel | **561 px** |

  Exceeding the height overflows the slide. Exceeding the width overflows the
  panel — explicit `h:`/`w:` sizing is no longer silently clamped, so check the
  render.
- **Wide figures need a full-width slide.** A figure wider than about 2:1 placed
  in a column panel is clamped to the column and wastes most of the slide. Put
  it on its own slide with a caption line underneath.
- **Split multi-panel journal figures** into one panel per slide rather than
  shrinking the composite. Paper figures are sized for a two-column page and are
  unreadable from the back of a room. `magick figure.png -crop WxH+X+Y +repage
  -trim +repage panel.png` after rasterising the source PDF with
  `pdftoppm -png -r 200`.

> Historical note: the theme's `img { max-width: 95% }` used to fight Marp's
> inline sizing and squeeze every explicitly sized figure out of aspect. That is
> fixed in `am_template.scss`; if you inherit an older theme copy, run
> `scripts/sync.sh` or the figures will be silently distorted.

## Verify the Built Deck

A 5% horizontal squeeze is invisible by eye but obvious in the numbers. After
building, check the rendered geometry of every image against its source:

```bash
pdfimages -list PDFs/deck.pdf
# displayed_pt = px / ppi * 72
# Compare that aspect ratio against the source file's (magick identify).
# Any mismatch beyond rounding means the figure is distorted.
```

Also worth a look: `pdfinfo PDFs/deck.pdf | grep Pages` should equal your `---`
separator count plus one. More pages than that means something inserted a break
you did not intend. To eyeball layout without opening a viewer, render to images
with `pdftoppm -png -r 80 PDFs/deck.pdf /tmp/slide` and inspect them.

## Build Commands

```bash
# Build all decks to PDFs/
make

# List markdown files that will be built
make list

# Build a single deck
make PDFs/lectures/01_introduction.pdf

# Remove all generated PDFs
make clean

# Show help
make help
```

Prerequisites: Node.js (for `npx`) and Chrome/Chromium/Firefox (for PDF rendering via `--allow-local-files`).

### Direct Marp CLI usage

```bash
# Live preview
npx @marp-team/marp-cli@latest -p my_deck.md

# Watch mode (rebuild on save)
npx @marp-team/marp-cli@latest -w my_deck.md

# Manual PDF conversion
npx @marp-team/marp-cli@latest my_deck.md -o output.pdf --pdf --theme-set themes/*.scss --allow-local-files
```

## VS Code Snippets

Two snippets are included (activate with `Ctrl+Space` in a `.md` file):

- `page_1_fig` — Slide with a centered figure and caption
- `page_trans` — Transition slide

## Authoring Tips

- **Images:** store in a `figures/` or `images/` subdirectory alongside the deck. Reference with relative paths: `![#c](./figures/diagram.png)`.
- **Transition slides:** use `<!-- _class: trans -->` with `<!-- _footer: "" -->` and `<!-- _paginate: "" -->` to suppress footer/page number. Keep the directive and its heading on the same slide, between the same pair of `---` separators.
- **Cover slide:** suppress header, footer, and pagination with `<!-- _header: "" -->`, `<!-- _footer: "" -->`, `<!-- _paginate: "" -->`. `cover_a` positions the title and subtitle absolutely (28% / 38%), so a title long enough to wrap collides with the subtitle — shorten it or override `top` in a per-deck `<style>` block.
- **Last slide:** `<!-- _class: lastpage -->` — a two-row grid of `heading` then `icons`. Only the heading and a `.icons` div get placed; other body content lands outside the named areas and renders below the colour band. Uses social-icon glyphs from Font Awesome; internet access needed at build time to load the font CSS.
- **Column panels** (`ldiv`/`rdiv`/`mdiv`) are left-aligned; full-width prose keeps the theme's justified setting.
- **Long bullet lists:** use `tinytext` or `smalltext` classes to prevent overflow.
- **Adding a new color palette:** create a new `.scss` file that `@import 'am_template'` and overrides the CSS variables (`--color-coverbg`, `--color-much`, etc.).
