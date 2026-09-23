# Glossary

Running list of terms, grown sprint by sprint. Quiz yourself on older entries before starting a new sprint.

## AWS & Identity

**IAM Identity Center (AWS SSO)** — AWS's system for human access to an account via short-lived, MFA-backed temporary credentials, issued through a browser login, instead of a permanent key.

**Static IAM user access key** — A long-lived `aws_access_key_id` / `aws_secret_access_key` pair tied to an IAM user. Never expires on its own, easy to leak, the pattern Identity Center replaces for human access.

**MFA (multi-factor authentication)** — A second proof of identity beyond a password (e.g., an authenticator app code). Required on the root account and on every human user in this project.

**SSO region vs. CLI default region** — Two different settings in `aws configure sso`. The SSO region is where Identity Center itself lives (ours: `us-east-2`). The CLI default region is where your actual resources get created (ours: `us-east-1`). Easy to conflate; they don't have to match.

**`aws sts get-caller-identity`** — Returns the ARN of whatever credentials the CLI is currently using. An `AWSReservedSSO_...` ARN confirms SSO is active; an IAM user ARN means it isn't.

## Terraform

**Terraform** — Infrastructure-as-code tool: AWS resources are defined in `.tf` files instead of clicked into existence in the console.

**`terraform init`** — Downloads the providers a config needs and sets up the working directory. Run again whenever providers or backend config change.

**`terraform validate`** — Checks that the configuration is syntactically valid and internally consistent. Doesn't touch AWS.

**`terraform plan`** — Shows what would change without changing anything. A preview, not an action.

**`terraform apply`** — Actually creates/changes/destroys real resources to match the config.

**State (`.tfstate`)** — Terraform's record of what it believes exists in AWS. Local for now (gitignored); moves to an S3 remote backend in Sprint 2. Never committed to git — it can contain sensitive values and causes conflicts if shared via git instead of a real backend.

**`.terraform.lock.hcl`** — Pins the exact provider version Terraform resolved. Unlike state, this *is* committed — it's what makes `terraform init` reproducible for anyone else running the repo.

**Provider** — A plugin that lets Terraform talk to a specific API (e.g., `hashicorp/aws`).

**Resource** — A single infrastructure object Terraform manages (e.g., `aws_budgets_budget`).

**Variable / `terraform.tfvars`** — Variables (`variable` blocks) parameterize a config; real values go in a gitignored `terraform.tfvars`. A committed `terraform.tfvars.example` documents the shape without leaking real values.

**Output** — A value Terraform exposes after apply (e.g., a resource's generated name or ARN).

**"Verify before trusting" (Terraform)** — Before using a resource argument you're not certain of, check it against the current provider docs rather than assuming from memory. Defends against AI-invented resource arguments, a named failure mode in this project's own rules.

## This project's first resource

**`aws_budgets_budget`** — The Terraform resource behind Gridiron's $25/month cost guardrail.

**`ACTUAL` notification** — Fires once real spend crosses a threshold. A lagging indicator — confirms something already happened.

**`FORECASTED` notification** — Fires when AWS *predicts*, from the current spend trend, that you're on track to cross a threshold before the period ends. A leading indicator — warns before it happens.

**Leading vs. lagging indicator** — A leading indicator predicts a problem before it fully arrives; a lagging indicator confirms one that already did. The `ACTUAL`/`FORECASTED` pairing is the same shape SLO burn-rate alerts use in Sprint 8.

## Git / GitHub workflow

**Branch protection** — Repo rules that block direct pushes to `main` and require a pull request instead. This project has it enabled with `enforce_admins: true`, so even the repo owner can't bypass it.

**`required_approving_review_count: 0`** — A branch protection setting requiring a PR to exist, but not requiring anyone else's approval to merge it — necessary for a solo project, since you can't approve your own PR.

**Conventional commits** — A commit message convention (`feat:`, `fix:`, `docs:`, `chore:`) that makes history and changelogs easier to scan.

**Squash merge** — Merges a PR's branch into `main` as a single commit, keeping `main`'s history clean even if the branch had many small commits.

**The branch → PR → merge cycle used in this repo:** `git checkout -b <branch>` → commit → `git push -u origin <branch>` → `gh pr create` → `gh pr merge --squash --delete-branch`.

## Documentation & process

**ADR (Architecture Decision Record)** — A document capturing a significant technical decision: the context, the options actually considered, the decision, and its consequences — not just the conclusion. ADR-001 (data source) is the first one in this repo.

**CLAUDE.md** — This repo's rulebook for AI coding tools: workflow, Terraform, security, and AI-collaboration conventions specific to Gridiron.

**Replay mode** — Replays a previously-recorded NFL game as a synthetic live stream, at whatever pace is useful. Not a fallback for when live data is unavailable — the primary path for development, demos, and tests, since it needs no external dependency and has fully predictable freshness.

**Data freshness field** — A field on an API response stating how old the underlying data is (e.g., "last updated 12 seconds ago"). What the Sprint 8 freshness SLO will actually be measured against.

**Explain-back gate** — The rule that no AI-drafted change merges until the person can explain what it does, in their own words, as if to a hiring manager.
