# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

@AGENTS.md

The line above is an import: Claude Code does not read `AGENTS.md` by itself, so it pulls the
rules into context at session start. Nothing from them is restated here — two copies drift.

## What is different about this repository

`AGENTS.md` here is not the working agreement for this repository. It is **the product**: the
canonical rules the owner copies into his other projects. Editing it changes the rules for every
project at once, and the rules still apply here while you do.

- **Wording matters more than volume.** A rule that can be read two ways will be read the wrong
  way in one project out of seventeen.
- **Never add a rule the owner did not give.** The sources are his direct instructions and the
  rule files in his repositories. A guess presented as a rule spreads everywhere.
- **The file is copied unchanged**, so nothing project-specific goes into it. The Appendix at its
  end is where a project adds its own material.

## Commands

```bash
./check.sh     # every mechanical check; CI runs it on each push to the trunk
```

It verifies the line ceiling on `AGENTS.md`, that every `§N` cross-reference resolves to a
section, that markdown links point at files that exist, and that `install.sh` still works in a
clean clone.

## Map of the files

- `AGENTS.md` — the rules.
- `README.md` — how to install them into a repository.
- `OPEN-QUESTIONS.md` — the decision log: what was settled, when, and on what evidence.
- `install.sh` — fetches the rules into a repository and wires up the import.
- `check.sh` and `.github/workflows/check.yml` — the checks.

## Pitfalls

- `AGENTS.md` sits at the ceiling `check.sh` enforces, so anything added to it has to buy its
  space back from somewhere else.
- The rules file is deliberately excluded from link checking (§0): it names files, such as the
  Copilot instructions, that this repository does not have.
