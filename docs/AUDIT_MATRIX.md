# Audit Matrix

## Goal
Provide a single control matrix for full-project analysis: domain coverage, verification criteria, evidence sources, and completion state.

## Domain Matrix

| Domain | Primary Files | Key Risks | Verification Criteria | Status |
|---|---|---|---|---|
| Runtime code (daemon) | src/xmoused.c | Undefined behavior, event injection regressions, IPC handling faults | Build success, static path review, command/state flow consistency, timer-loop safety | **Done** — F-01 fixed, F-04 verify |
| Test helper (xbtts) | src-xbtts/xbtts.c | Incorrect qualifier mapping, fake button state drift | Qualifier->button mapping verified, clean startup/shutdown path review | **Done** — Clean |
| Build system | Makefile | Wrong flags, non-reproducible builds, broken targets | make build and mode coverage validated, output artifact path confirmed | **Done** — Clean |
| Setup/toolchain | scripts/setup.ps1, setup.config.psd1, .setup/config.psd1 | Dependency drift, env generation failures | setup env flow reviewed, required tools and vars mapped | **Done** — Clean |
| Release pipeline | scripts/build-release.ps1 | Packaging mismatch, placeholder leakage, archive inconsistencies | Release composition path reviewed, artifact list matches docs/install | **Done** — F-03 HIGH open |
| Deployment | Makefile upload target, tools/acp, tools/bgdbserver | Wrong destination host/path, accidental overwrite | Upload command sequence reviewed with explicit preflight checklist | **Done** — Clean |
| Installer | Install | Incorrect destination/protection/startup integration | Install flow, executable protection, User-Startup behavior validated | **Done** — F-08 low open |
| User docs | README.md, docs/USAGE.md | Command/config mismatch, compatibility misinformation | CLI/config table matches code, compatibility statements reviewed | **Done** — F-05/F-06 fixed |
| Technical docs | docs/TECHNICAL.md, docs/VISION.md | Architecture/API drift | Runtime behavior and port contract aligned with implementation | **Done** — F-02 fixed |
| Distribution docs | XMouseD.guide, XMouseD.readme | Outdated commands/modes, release metadata mismatch | Guide/readme claims aligned to code + release script outputs | **Done** — Clean |
| Change tracking | CHANGELOG.md, ROADMAP.md, docs/Next.md | Missing fixes, stale status claims | Current fixes captured, status sections updated or flagged | **Done** — Updated |

## Entry Checklist
- Confirm scope and version under analysis.
- Capture current git state before deep audit changes.
- Define severity levels for findings (Critical, High, Medium, Low).
- Record evidence format (file + line + impact).

## Exit Checklist
- All domains marked complete or explicitly deferred.
- Every finding includes: evidence, impact, severity, recommendation.
- Cross-domain consistency checks completed for CLI, config byte, port protocol, and release artifacts.
- Final go/no-go release summary produced.
