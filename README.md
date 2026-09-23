# Gridiron

*Your games and your parlay, live. Gridiron tracks every leg in real time, tells you which games are worth watching, and lets you ask AI about any game or player.*

A live sports platform built with DevOps practices and run with SRE principles.

## What this is

Gridiron is a personal portfolio project: a real-time NFL data platform, built the way a production team would build one — Terraform-only infrastructure, CI/CD, observability, SLOs, and an AI layer that's tested and guardrailed rather than bolted on. It doubles as a hands-on AWS DevOps & SRE apprenticeship, run solo, on a real 25-week build plan.

For fans, the plan is a way to cut through the noise of a Sunday slate: live leg tracking for parlays, alerts when a game is actually worth switching to, and a conversational AI analyst grounded in real game data. For engineering, it's the same problem ticketing, streaming, and sportsbook platforms face on their biggest days — bursty traffic, real-time delivery, and zero tolerance for a bad deploy mid-game.

**Status: early.** This is Sprint 1 (Week 1) of the build. Most of the architecture described below is the plan, not yet running code — see [Current Progress](#current-progress) for what's actually built today.

## Current progress

- [x] AWS account secured — IAM Identity Center, MFA, no static access keys
- [x] $25/month AWS budget guardrail, defined in Terraform
- [x] Branch-protected repo workflow (PRs required, including from the repo owner)
- [x] [ADR-001](docs/adr/0001-data-source.md) — NFL data source decision (nflverse + replay mode)
- [ ] Hub (ingest + replay mode) and scores API, running locally via Docker Compose
- [ ] CI pipeline, Terraform remote state, first AWS deployment
- [ ] Everything else — see the full roadmap in the project's planning doc (not yet published to this repo)

Real-time progress lives in [docs/learning-log.md](docs/learning-log.md).

## Planned architecture

A hub-and-spoke design on AWS:

- **Hub** — pulls NFL game and play-by-play data (or replays a past game as if it were live) and publishes events for the rest of the system to consume.
- **Scores API** — serves live scores and game state, with every response tagged with a data-freshness field.
- **Stats & Game Watch service** — tracks parlay legs and fires close-game alerts as plays happen.
- **Ask Gridiron** — a Bedrock-backed conversational AI analyst, grounded only in Gridiron's own data, with its own evals and SLOs.

Details and the reasoning behind each choice live in [docs/adr/](docs/adr/) as they're made.

## Tech stack (so far)

| Tool | Role | Why |
|---|---|---|
| Terraform | All AWS infrastructure | Infrastructure as code, never console clicks |
| AWS IAM Identity Center | Human access to AWS | Short-lived, MFA-backed credentials instead of static keys |
| AWS Budgets | Cost guardrail | $25/month cap with actual + forecasted spend alerts |
| GitHub + branch protection | Source control, workflow | Every change through a PR, even solo |

The full "Tech Stack and Why" table — covering the whole planned build — lands in `docs/tech-stack.md` starting Sprint 2, and gets kept honest as tools are actually added.

## Cost

Running under a $25/month AWS budget guardrail (see [terraform/budget.tf](terraform/budget.tf)). Real cost-per-game-day numbers get published here once the platform is actually live on real games.

## Responsible gaming

Gridiron's parlay leg tracker is for tracking only — it is not betting advice and does not place bets. 21+. If you or someone you know has a gambling problem, call 1-800-GAMBLER.

## Not affiliated with the NFL

Gridiron is an independent personal project. It is not affiliated with, endorsed by, or officially connected to the NFL, any NFL team, or any broadcast network. No official logos, footage, or broadcast audio are used.

## Docs

- [Architecture decisions](docs/adr/)
- [Learning log](docs/learning-log.md)
- [AI/repo conventions](CLAUDE.md)
