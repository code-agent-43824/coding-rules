# AGENTS.md — rules for coding agents

The owner's canonical rules, shared by all of his projects. Copy this file into a
repository as is; anything project-specific goes in the [Appendix](#appendix--what-to-add-per-project).

## 0. How the rules are organised

- **`AGENTS.md` is the single source of rules.** Every agent reads it: Claude Code,
  Codex, Copilot, Gemini.
- **`CLAUDE.md`, `.github/copilot-instructions.md` and `GEMINI.md` do not restate the
  rules.** They hold either a one-line pointer to this file or a map of the code
  (architecture, commands, pitfalls) — what is *not* here. Restating is forbidden: two
  copies always drift apart, and an agent ends up following the stale one.
- **Project rules extend this file; they do not override it.** Where a project has to
  depart from a shared rule, the departure is stated explicitly, with its reason, under
  "Departures" in the project's `AGENTS.md`. A silent departure is a mistake.
- If the owner asks for something different on a specific task, that is his call — it
  breaks no rule and needs no change to this file.

---

## 1. Git

- **One working branch — the repository's trunk** (`main`, or `master` in older
  repositories; same thing). **Do not create branches. Do not open pull requests.**
  Everything is committed to the trunk.
- **Each completed logical step is its own commit, pushed immediately.** Do not
  accumulate work into one large commit, and do not mix unrelated changes.
- **The trunk is always green.** A commit that breaks the build, the tests or the
  linter does not go into the trunk.
- **A red trunk outranks your own task.** If you broke it, fix it immediately. If
  someone else did, tell the owner and get his go-ahead before touching it — another
  agent may already be on it. Ask first, but ask right away: this comes before the
  work you arrived to do.
- **`git fetch` before starting work**, and make sure the local trunk is not behind:
  other agents may be working in the same repository.
- **Before committing, run `git diff --check` and `git status`.** Do not sweep in
  other agents' files, temporary files or generated output.
- **Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/)
  and are written in English:** `feat:`, `fix:`, `docs:`, `refactor:`, `chore:`, `ci:`,
  `test:`. The message says *what and why*, and stands on its own without the diff.
- **Use plain git commands.** The GitHub API is for reading only — statuses, logs,
  releases, artifacts.

## 2. Project documents

Six documents. Each answers exactly one question. **A given fact lives in exactly one
of them.** When unsure where something belongs, this table decides.

| Document | Answers | How it lives |
| --- | --- | --- |
| `docs/ROADMAP.md` | **Where we are going.** What the product is, which stages the path has, in what order | Long-lived; changes rarely and deliberately |
| `docs/PLAN.md` | **What we are doing in the current stage.** Concrete actions with `[ ]` / `[~]` / `[x]` / `[!]` checkboxes | Lives until the stage closes, then is rewritten for the next one |
| `docs/STATUS.md` | **What state the project is in right now.** What works, what is broken, current version, where work stopped | One screen; overwritten |
| `docs/WORKLOG.md` | **What we did.** One entry per chunk of work: plan → done → next | Append-only, newest on top |
| `docs/JOURNAL.md` | **What we learned.** Hypothesis → what we did → what the check showed → conclusion | Append-only, newest on top |
| `HANDOFF.md` | **What is unfinished right now.** The single state of in-flight work and the exact next step | Overwritten; when nothing is in flight, it says so |

`AGENTS.md` and `HANDOFF.md` live in the repository root — they are read first.
Everything else lives in `docs/`.

**`WORKLOG` vs `JOURNAL` is the easy one to get wrong.** The difference is not how
detailed the entry is, but what kind of record it is:

- `WORKLOG` is **operational**: what I set out to do, what I did, what is left. It
  exists so the next agent can pick up interrupted work. Fixed a typo → a worklog line.
- `JOURNAL` is **about knowledge**: what we now know about the project that we did not
  know yesterday. Tested a hypothesis on real hardware, found the cause of a bug,
  settled a contested question → a journal entry. Routine edits never reach it.

Rules for the documents:

- **Never delete failed attempts from `JOURNAL`.** Each one closes off a hypothesis you
  would otherwise return to.
- **Snapshot documents (`STATUS`, `HANDOFF`) do not update themselves.** When you check
  or change the real state, reconcile the document in the same session — do not leave a
  stale entry until someone asks.
- **Overwrite another agent's `HANDOFF` entry only once that work is finished.**
  Someone else's *unfinished* work is never erased — carrying it is the whole reason
  the file exists. If you cannot tell whether it is done, treat it as unfinished and
  leave it in place.
- **What is not written down was not started.** Unrecorded work does not exist for the
  next agent.
- **When code and documentation disagree, fix the documentation in the same change.**
- Create a document when it is first needed. Do not pre-create empty files.

## 3. Order of work

1. **Read:** `AGENTS.md`, `HANDOFF.md`, `docs/STATUS.md`, `docs/PLAN.md`, and the
   top entries of `docs/JOURNAL.md`.
2. **Write down the intent before the code.** The action goes into `docs/PLAN.md` as
   `[ ]`/`[~]`; the reasoning goes into `docs/WORKLOG.md`. **Commit this separately,
   before touching any code** — a docs-only commit is always green, so it never
   conflicts with the green-trunk rule.
3. **Do the work.**
4. **Verify it** — proportionally to the risk of the change (see §4).
5. **Record the result in the same change as the code:** `WORKLOG` (done / next),
   `PLAN` (status `[x]`/`[!]`), `STATUS` (if the project's state changed), `JOURNAL`
   (if something was learned), `HANDOFF` (if you are stopping before finishing).

The goal: the next agent can tell **what was planned, what shipped and what is next
from the documents alone**, without reading the diff.

## 4. Verification and honest reporting

- **Never present the unverified as verified.** If you could not run the tests — no SDK
  in the container, no device, no access — say so plainly. Silence reads as "checked".
- **A green CI badge is not proof.** For build and deployment changes, read the actual
  logs and artifacts, not just the checkmark.
- **Simulation does not become a claim about hardware or security.** Fakes and
  emulators exercise logic, not real devices.
- **Close gaps with data, not reasoning.** Do not put into an algorithm any property
  that is not in the confirmed facts: guessed changes have already produced wrong
  results.
- **Do not invent domain content** — statute text, expert commentary, instrument
  readings, constant values.
- **Report the actual outcome.** Tests failed — show the output. A step was skipped —
  say it was skipped. Part of the work is blocked — finish everything else and state
  explicitly what was left undone.

## 5. Actions an agent does not take alone

Most mistakes are undone by the next commit. These are not — so the agent stops and
asks the owner first, however obviously right the change looks:

- **Losing data.** Migrations that drop or rewrite existing data, destructive
  fixtures, clearing any store that holds the only copy of something.
- **Removing published artifacts.** Deleting branches, tags or releases.
- **Rewriting history.** `force-push`, rebasing published commits, `filter-branch` and
  the like. The trunk's history is append-only.
- **Changing a public contract.** API shape, wire formats, stored-data formats, and
  identifiers that other systems depend on.
- **Revoking or replacing keys and credentials** (see §7).
- **Anything inside someone else's system** — another project's server, a shared host,
  a third-party account.

When asking, say what would be lost, what the alternative is, and what you recommend.
Once the owner agrees, do it and record his decision in `JOURNAL` — the next agent
must be able to see that it was sanctioned rather than improvised.

## 6. Deployment

Who deploys depends on **whether the deployment needs manual work on the server**:

- **The project deploys itself through CI** (pipeline configured, no manual steps) —
  **any agent may deploy.**
- **Deployment requires manual work on the server** — **only Watson deploys.** Other
  agents do not touch the production server.

In addition:

- **If a push to the trunk means a production deploy, the project's rules say so
  explicitly.** Such projects have no staging environment, which makes the green-trunk
  rule critical: a red commit is a broken production.
- **Do not create deploy keys, server credentials or release jobs** without an explicit
  decision from the owner. A change in the repository is never permission to deploy it.
- **Destructive operations on shared resources are forbidden.** Where a resource is
  shared with other projects — a common webroot, a shared database, a shared host — use
  only the deployment script provided; no `rsync --delete` over a whole directory.
  Treat unfamiliar directories as someone else's and preserve them.
- **After deploying, verify what is live** — both your project and its neighbours on the
  same resource.

When production is broken:

- **Tell the owner immediately** — before investigating, before fixing. He may be
  looking at the same outage without knowing its cause.
- **Fix forward, with a new commit to the trunk.** A revert is an ordinary commit; the
  bad commit stays in history. Do not rewrite history to make it disappear (§5).
- **Once it is back up, record it in `JOURNAL`:** what broke, why, and what now stops
  it happening again.

## 7. Secrets

- **Never commit** credentials, tokens, private keys, personal data or production
  configuration.
- **Keep third-party vendor binaries out of git** — fetch them with build scripts,
  pinned by SHA-256.
- **Found a secret in the repository? Report it to the owner. Do not remove it
  yourself, and never without his knowledge.** Three reasons: it may be a deliberate
  exception (see below); deleting it from the working tree does not remove it from git
  history, and creates a false impression that the leak is closed; and revoking and
  replacing a compromised key is an action in external systems that only the owner can
  take. The agent's job is to notice and say so — naming the exact file and commit —
  then let him decide.
- **A deliberate exception is possible, but only an explicit one.** If something that
  looks like a secret is committed on purpose, it is recorded under the project's
  "Settled decisions" with its reason. Without that record, every later agent will keep
  raising it as a leak.

## 8. Settled decisions

Every project's rules carry a **"Settled decisions"** section: things decided
deliberately that look like mistakes to a fresh pair of eyes.

- **Each decision is recorded together with its reason.** The reason is mandatory:
  without it the next agent will clear the decision away as junk.
- **An agent does not reopen these on its own initiative.** Only the owner reverses them.
- Closed topics belong here too — questions already discussed and settled. Do not raise
  them again without being asked.
- Durable architectural decisions are recorded as ADRs under `docs/decisions/` where a
  project calls for it.

## 9. Scope and style of changes

- **Prefer clear, boring, maintainable solutions over speculative abstractions.**
- **Add dependencies, frameworks and infrastructure only as the adopted spec and the
  current stage require.** Anything beyond the adopted stack — including any
  third-party cloud or external service — needs a settled decision recorded before it
  is relied on.
- **Add or update tests alongside the application code they cover.**
- **Preserve unrelated work.** Inspect the state of the repository before changing it;
  unrelated cleanup belongs in `PLAN.md` as its own item rather than folded into the
  change at hand.
- **UTF-8, LF line endings.**

## 10. Language

- **Reply to the owner in Russian.**
- **Project documentation is written in Russian.**
- **Code identifiers and commit messages are in English.**
- **Agent instruction files — this file, `CLAUDE.md`, `copilot-instructions.md` — are
  in English.** They are instructions executed by a model, not documentation for a
  reader, which is why they are the exception to the rule above.
- **UI strings follow the project's own convention.** Where tests assert on specific UI
  strings, change both together.

## 11. Working alongside other agents

Several agents may work in a repository at once, and any of their sessions can be
interrupted at any moment.

- **Keep changes narrow and independently reviewable**, so a parallel agent can pick up
  without conflicts.
- **Every task must stay resumable.** The exact state of unfinished work belongs in
  `HANDOFF.md`.
- **Roles may be split** (for example, only Watson deploys) — this is stated in the
  project's rules.

## 12. Environment

- **The environment is ephemeral.** Re-do the GitHub access setup at the start of each
  session if it does not persist.
- **The environment's proxy returns HTTP 403 on some write operations** — known cases
  include pushing a tag, deleting a branch and writing through the REST API. This is
  environment policy, not a failure: **do not work around it, report it to the owner.**
  Where the operation is genuinely needed, a workflow performs it (release tagging, for
  example).

## 13. Owner review

Where the owner checks the result by hand — installing a build on his phone, opening the
site — **pause after each completed stage** and let him check before starting the next
one. What he checks is stated in the project's rules.

---

## Appendix — what to add per project

This file is copied unchanged. Project-specific material goes below it, or in
`CLAUDE.md`:

- **Commands** — build, tests, linter, formatter; always including how to run a
  **single** test.
- **Map of the code** — architecture, entry points, non-obvious couplings.
- **Settled decisions** — with reasons (§8).
- **Departures from this file** — with reasons (§0).
- **Version discipline** — where the version lives and what must change together.
- **Deployment** — CI or manual, who may do it, what to verify afterwards (§6).
- **What the owner reviews**, and at which step a pause is expected (§13).
