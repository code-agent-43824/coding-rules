# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository state

This repository is a new, empty project. As of the initial commit it contains only `README.md` and `LICENSE` (MIT) — there is no source code, package manifest, build system, test framework, or linter configuration.

Per `README.md`, the project's purpose is: **rules for coding agents**.

## Consequences for working here

- There are no build, test, lint, or run commands. Do not assume a toolchain exists or attempt to invoke one — verify against the working tree first.
- There is no architecture to preserve. The first substantive change defines the project's language, layout, and conventions, so those choices are worth confirming with the user rather than inferring.
- When tooling is introduced, replace this section with the actual commands (including how to run a single test) and a description of the code structure.

## Conventions

- Default branch: `main`.
