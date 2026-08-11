# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This repository holds the rules coding agents are expected to follow when working on the owner's projects — instructions about agent behavior. The deliverable is the rules themselves, not application code.

## Repository state

Currently `README.md`, `LICENSE` (MIT), and this file. There is no source code, package manifest, build system, test framework, or linter configuration, and therefore no build, test, lint, or run commands. Do not assume a toolchain exists or attempt to invoke one — verify against the working tree first.

## Git workflow

These override the usual branch-and-PR defaults:

- **Commit directly to `main`.** Do not create feature branches, and do not open pull requests for changes to this repository.
- **All history lives on `main`.** If a branch does get created, merge it fast-forward and delete it, locally and on the remote.
- **Commit each change separately** rather than batching unrelated edits into one commit.
