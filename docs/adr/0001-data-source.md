# ADR-001: NFL Data Source

## Status
Accepted — 2026-09-22

## Context
Gridiron needs NFL game, schedule, and play-by-play data for the ingest hub. It must be free (no
licensed sportsbook or broadcast data), and it must let me build and demo the platform on any day
of the year, not just Sundays in season. Two realistic free options were evaluated.

### Option A: nflverse (`nflreadr` / `nfl_data_py` / `nflreadpy`)
Open-source, actively maintained, official-adjacent project used widely in the NFL analytics
community. Verified against the current `nflreadr` docs and package changelogs rather than assumed:

- **Play-by-play (`load_pbp()`):** updates **nightly** after each game day, plus at unspecified
  "specific points" during game days. Fully corrected data lands Thursday evenings after stat
  corrections are applied Monday–Wednesday. **This is not a live, in-game feed.**
- **Raw play-by-play (`nflfastR::build_nflfastR_pbp()`):** faster, but still only "usually
  available within 15 minutes **after a game has ended**" — post-game, not during.
- **Schedule/game state:** the most responsive nflverse dataset, updating **every 5 minutes**
  during the season. Still not sub-minute.
- No API key, no rate limits published, stable schema, safe to depend on long-term.

### Option B: ESPN's unofficial "hidden" API (`site.api.espn.com/.../nfl/scoreboard`, etc.)
Undocumented JSON endpoints ESPN.com itself uses. Widely used by hobby projects for near-real-time
scores and play-by-play, free, no key required.

- Latency is close to live (seconds, not minutes) for scores and plays.
- **Unofficial and undocumented:** no SLA, no versioning guarantees, can change or start
  rate-limiting/blocking without notice. Not something to depend on for a core guarantee.

## Decision
**Primary data source: nflverse.** It's the only option here with a stable, documented, actively
maintained update schedule I can design around and depend on for the life of this project.

**Replay mode is not a fallback — it is the primary demo and test path**, exactly as already
scoped in the architecture. Given nflverse's own numbers above (pbp nightly/interval, schedule
every 5 min), nflverse alone cannot deliver sub-minute freshness even during a live game. Replay
mode sidesteps that entirely: it replays a completed game's data as a synthetic live stream at
whatever pace the hub wants, so freshness during development, demos, and CI is fully controlled
and doesn't depend on an external service's update cadence at all.

**ESPN's hidden API is explicitly rejected as a dependency for now.** It's faster, but "unofficial,
can break without notice" is a bad foundation for anything the freshness SLI/SLO (Sprint 8) will
be measured against. It stays an option to revisit later as a *supplementary* live-score source,
not a replacement for nflverse.

## Consequences
- **The Sprint 8 target of "data freshness under 60 seconds, 99% of the time" is very likely
  unachievable against nflverse's real update cadence during genuinely live games** (5-minute
  schedule updates is the best case; pbp is coarser than that). This isn't a problem to solve
  today — the plan already calls for setting real SLO targets from real data in Sprint 8. Flagging
  it now so it's not a surprise then: either the target gets revised with real measured data, or
  a supplementary faster source (ESPN's API, accepted with its risks) gets added specifically for
  the scores spoke at that point.
- Play-by-play driven features (parlay leg evaluation) will be accurate and reliable, but during a
  real live game should be expected to lag by minutes, not seconds, unless/until a faster source is
  added. Replay mode remains the reliable way to demo "live" leg tracking and close-game alerts
  responsively.
- No cost, no auth, no rate-limit risk from nflverse — good for the $25/month budget guardrail.
- Revisit this ADR if nflverse changes its update cadence, or if a faster official free source
  becomes available.
