# Learning Log

Newest entry first. Each entry: what I learned, what broke, how I fixed it, next step.

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
