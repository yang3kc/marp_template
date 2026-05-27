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
headingDivider: [2,3]
---
```

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

Constrain height with Marp's native syntax: `![h:300px](image.png)`

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
- **Transition slides:** use `<!-- _class: trans -->` with `<!-- _footer: "" -->` and `<!-- _paginate: "" -->` to suppress footer/page number.
- **Cover slide:** suppress header, footer, and pagination with `<!-- _header: "" -->`, `<!-- _footer: "" -->`, `<!-- _paginate: "" -->`.
- **Last slide:** `<!-- _class: lastpage -->` — uses social-icon glyphs from Font Awesome; internet access needed at build time to load the font CSS.
- **Long bullet lists:** use `tinytext` or `smalltext` classes to prevent overflow.
- **Adding a new color palette:** create a new `.scss` file that `@import 'am_template'` and overrides the CSS variables (`--color-coverbg`, `--color-much`, etc.).
