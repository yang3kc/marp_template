# marp-slides — Claude Code Skill

A Claude Code skill for authoring and building [Marp](https://marp.app/) slide decks. It ships three custom SCSS themes, a Make-based PDF build system, `init`/`sync` scripts the agent uses to bootstrap and maintain slides directories in project repos, and a `SKILL.md` that teaches the agent the full slide-class catalog.

## Skill layout

```
skills/marp-slides/
├── SKILL.md               ← agent instructions + full slide-class catalog
├── Makefile               ← drives npx @marp-team/marp-cli@latest
├── template_slides.md     ← starter deck to copy per project
├── themes/
│   ├── am_template.scss   ← base theme (~1600 lines)
│   ├── am_crimson.scss    ← color palette override
│   └── am_blue.scss       ← color palette override
├── vscode/
│   ├── settings.json      ← registers themes with Marp VS Code extension
│   └── slides_snippets.code-snippets
└── scripts/
    ├── init.sh            ← bootstrap a project's slides directory
    └── sync.sh            ← pull upstream theme/Makefile updates into a project
```

## Install the skill

```bash
# Using the skills CLI
npx skills install https://github.com/yang3kc/marp_template

# Or clone manually
git clone git@github.com:yang3kc/marp_template.git ~/.claude/skills/marp-slides
```

Once installed, the agent activates `marp-slides` automatically when you ask to create slides, add a deck to a project, or sync slide themes.

## Bootstrap slides in a project (without the agent)

```bash
cd skills/marp-slides
bash scripts/init.sh /absolute/path/to/project/slides
```

This copies `themes/`, `Makefile`, `template_slides.md`, and `.vscode/` into the target directory and appends `PDFs/` and `node_modules/` to the nearest `.gitignore`.

## Sync upstream theme/Makefile updates into a project

```bash
bash scripts/sync.sh /absolute/path/to/project/slides

# Force-overwrite without confirmation
bash scripts/sync.sh --force /absolute/path/to/project/slides
```

## Prerequisites

- **Node.js** (for `npx @marp-team/marp-cli@latest`)
- **Chrome/Chromium/Firefox** (for PDF rendering)
- Recommended: [Marp for VS Code](https://marketplace.visualstudio.com/items?itemName=marp-team.marp-vscode) for live preview

See [`skills/marp-slides/SKILL.md`](skills/marp-slides/SKILL.md) for the full authoring guide and slide-class catalog.

## Resources

- [Marp Official Site](https://marp.app/)
- [Marp CLI Documentation](https://github.com/marp-team/marp-cli)
- [Marpit Framework](https://marpit.marp.app/)

## Acknowledgements

The custom themes are based on [Awesome-Marp](https://github.com/favourhong/Awesome-Marp) by favourhong.

## License

MIT
