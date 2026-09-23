# CLAUDE.md

Conventions for AI tools (Claude Code, GitHub Copilot) working in this repo. This is a solo
learning project run with production-team discipline — see the full apprenticeship program spec
for the "why"; this file is the "how" for this specific codebase.

## What this is
Gridiron: a live NFL data platform (scores, parlay leg tracking, close-game alerts, and later an
AI analyst) built to teach AWS DevOps and SRE practices. No frontend in Part 1 — the platform is
the product.

## Workflow rules
- `main` is protected: no direct pushes, PR required (including from the repo owner), conversation
  threads must resolve before merge. Branch per ticket: `<type>/<short-description>` (e.g.
  `feat/grid-003-scores-api`), conventional commits (`feat:`, `fix:`, `docs:`, `chore:`).
- Every ticket has an ID (`GRID-###`). Reference it in the branch name and commit message when one
  exists.
- Infrastructure is Terraform only. Never create or modify AWS resources by hand in the console.
- PR descriptions must state what AI drafted vs. what was written by hand, and how it was verified.

## Terraform conventions
- Every resource gets `Project`, `Environment`, `Owner` tags at minimum.
- Never hardcode secrets, emails, or account-specific values — use variables with a committed
  `terraform.tfvars.example` and a gitignored real `terraform.tfvars`.
- State is local until the Sprint 2 S3 remote backend exists — don't invent a backend block before
  that infra is actually built.
- **Before using any resource argument you're not 100% sure of, verify it against the current
  HashiCorp provider docs (registry.terraform.io or the provider's GitHub source) rather than
  assuming from training data.** AI-invented resource arguments are a known, explicit failure mode
  for this project — don't guess.

## Python conventions
- Python 3.11+ (target is 3.13 per the original plan; note the gap if it matters for a specific
  feature). `pytest` for tests, `ruff` for linting. FastAPI for all services.
- No feature gets marked done without a passing test.

## Security — non-negotiable
- No secrets, API keys, or credentials in committed files, ever. `.gitignore` already excludes
  `.tfvars`, `.tfstate`, `.env`.
- No IAM users with static access keys for human access — Identity Center + SSO only.
- No public S3 buckets, no wildcard IAM policies, no open security groups — flag these if you see
  AI-drafted code producing them.
- Secrets go in AWS Secrets Manager, never environment files committed to git.

## AI collaboration rules (see ADR process for design decisions)
- AI drafts, the human owns it: nothing merges that the repo owner can't explain line by line.
- Every AI-assisted change gets logged in `docs/ai-usage.md` (what was delegated, what worked, what
  the AI got wrong, how it was caught) — create this file the first time it's needed.
- Significant technical decisions (data sources, ECS vs. EKS, SLO targets, tool-calling vs.
  text-to-SQL, etc.) get an ADR in `docs/adr/`, not just a Slack-style chat explanation.

## Docs that must stay current
- `docs/adr/` — architecture decisions, one file per decision, numbered.
- `docs/learning-log.md` — session-by-session learning log, newest entry first.
- `docs/tech-stack.md` — the "Tech Stack and Why" table (create in Sprint 2 when the stack starts
  growing beyond what's in this file).
