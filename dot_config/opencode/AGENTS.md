# Shared global rules

Follow the user’s request and the repository’s instructions. User instructions take precedence over skill guidance. If a skill blocks authorized work, name the file and quote the exact instruction before asking for clarification.

Never print or commit credentials. Keep secrets in environment variables or the existing credential store.

<!-- context7 -->
Use the `ctx7` CLI to fetch current documentation whenever the user asks about a library, framework, SDK, API, CLI tool, or cloud service — even well-known ones like React, Next.js, Prisma, Express, Tailwind, Django, or Spring Boot. This includes API syntax, configuration, version migration, library-specific debugging, setup instructions, and CLI tool usage. Use even when you think you know the answer — your training data may not reflect recent changes. Prefer this over web search for library docs.

Do not use for: refactoring, writing scripts from scratch, debugging business logic, code review, or general programming concepts.

## Steps

1. Resolve library: `npx ctx7@latest library <name> "<user's question>"` — use the official library name with proper punctuation (e.g., "Next.js" not "nextjs", "Customer.io" not "customerio", "Three.js" not "threejs")
2. Pick the best match (ID format: `/org/project`) by: exact name match, description relevance, code snippet count, source reputation (High/Medium preferred), and benchmark score (higher is better). If results don't look right, try alternate names or queries (e.g., "next.js" not "nextjs", or rephrase the question)
3. Fetch docs: `npx ctx7@latest docs <libraryId> "<user's question>"` — run a separate `docs` command per distinct concept if the question spans multiple topics, unless it's about how they interact
4. Answer using the fetched documentation

You MUST call `library` first to get a valid ID unless the user provides one directly in `/org/project` format. Use the user's full question as the query — specific and detailed queries return better results than vague single words, but keep each query to a single concept unless the question is about how concepts interact; combined multi-topic queries dilute ranking and return shallow results for each topic. Do not run more than 3 commands per question. Do not include sensitive information (API keys, passwords, credentials) in queries.

For version-specific docs, use `/org/project/version` from the `library` output (e.g., `/vercel/next.js/v14.3.0`).

If a command fails with a quota error, inform the user and suggest `npx ctx7@latest login` or setting `CONTEXT7_API_KEY` env var for higher limits. Do not silently fall back to training data.
Run Context7 CLI requests outside Codex's default sandbox. If a Context7 CLI command fails with DNS or network errors such as ENOTFOUND, host resolution failures, or fetch failed, rerun it outside the sandbox instead of retrying inside the sandbox.
<!-- context7 -->

## Publishing a prototype

Use the `prototype-host` command to publish a static demo or register a container-backed app. Read the installed operations document first: `$HOME/Library/Application Support/helloBrio/prototype-host/OPERATIONS.md`.

- Publish a build: `prototype-host static NAME ./dist --owner STABLE-ID`
- Register an app: `prototype-host proxy NAME PORT --host NAME.localhost --owner STABLE-ID`
- Inspect: `prototype-host status` (read-only; it does not reinstall or rewrite Compose)
- Report the printed `http://...` URL. A static publication is a snapshot; edits require another `static` run.

If `prototype-host` is not on `PATH` (a GUI-launched agent with a restricted PATH), call the absolute path: `"$HOME/Library/Application Support/helloBrio/prototype-host/prototype-host.py" status`.

## Git worktrees

Use `wtp` (Worktree Plus), not raw `git worktree`; its `.wtp.yml` post_create
hooks make a fresh worktree runnable (copy gitignored state, symlink caches).
Traps not in `--help`:

- `.wtp.yml` is read from the main worktree only; a copy in a linked worktree is ignored.
- The first failing hook aborts the rest, yet the worktree still reports created —
  the failure is only a `Warning:` line. Read hook output, not the exit code.
- Never symlink a directory containing tracked files (worktree reads permanently
  dirty). Symlink its children, and write `.cache` not `.cache/` in `.gitignore` —
  the trailing slash doesn't match a symlink.

## Delegated work

Announce a handoff before it starts: the work being delegated and the model receiving it. Follow the repository’s delegation rules.

# Model note: DeepSeek / OpenCode

Before starting work, confirm the selected model and effective effort from OpenCode’s resolved configuration and session metadata. Report an unset or unobservable effort as unknown; do not infer it from a model label. Complete and verify the requested result using simple, direct steps.
