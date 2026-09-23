# Learning Log

Newest entry first. Each entry: what I learned, what broke, how I fixed it, next step.

---

## 2026-09-22 — CLAUDE.md, ADR-001, and the first branch-protected PR

**Learned:** How to write an ADR that documents a real tradeoff instead of just restating a
decision — ADR-001 required actually checking nflverse's current update cadence instead of
assuming it, which turned up a real conflict with the Sprint 8 freshness SLO target (nflverse
can't hit 60s freshness in a live game; best case is 5-minute schedule updates). Also watched
branch protection do its job: `main` rejected a direct push and required PR #1 to go through
review-gate mechanics, even for the repo owner.

**What broke:** Nothing broke this round — first clean PR cycle end to end (branch, commit, push,
PR, merge, branch cleanup).

**How I fixed it:** N/A.

**Next step:** Start the Sprint 1 hub — a local Python service with replay mode and a scores API
exposing a data-freshness field, running via Docker Compose. No AWS resources needed for this
piece; it's fully local.

---

## 2026-09-22 — GRID-001: AWS account security + first Terraform resource

**Learned:** IAM Identity Center vs. static IAM user keys — Identity Center issues short-lived,
MFA-backed role credentials instead of long-lived access keys that never expire on their own.
Wrote and applied my first Terraform resource (`aws_budgets_budget`), including the difference
between an `ACTUAL` notification (fires on money already spent) and a `FORECASTED` one (fires on
a spend trend prediction, before the money's gone) — same leading/lagging pattern I'll see again
with SLO burn-rate alerts in Sprint 8.

**What broke:** My old `default`/`glamgo` AWS CLI profiles used a static access key that was
already invalid (`InvalidClientTokenId`) — the underlying IAM user had been deleted. Separately,
Claude's own redaction command had a bug and briefly printed that (already-dead) key in plaintext
to the session.

**How I fixed it:** Replaced static keys entirely with `aws configure sso` against IAM Identity
Center. Verified with `aws sts get-caller-identity`. Deleted the dead `glamgo` profile and
overwrote `default` — confirmed the AWS account itself had zero leftover resources from the old
project, so no cloud-side cleanup was needed.

**Next step:** Write CLAUDE.md (repo AI conventions) and ADR-001 (data source decision) so the
hub's data strategy is documented before writing any ingest code.
