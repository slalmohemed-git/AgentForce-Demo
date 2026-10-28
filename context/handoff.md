# Handoff — current state

> **Rewritten at the end of every session.** This file is *now*; [`gotchas.md`](gotchas.md) is *forever*.
> If this file and [`../CONTEXT.md`](../CONTEXT.md) disagree, this one is newer.

**Last updated:** 2026-10-27 · **By:** <session or person>

---

## Where things stand

> **Not yet filled in.** — Where is the work right now, in two or three sentences? Someone picking
> this up cold reads this first.

## In progress

| What | State | Where it lives | Blocked on |
|---|---|---|---|
| | | | |

## Next steps

<!-- Ordered. The top item should be the one to do next, not the most interesting one. -->

1.

## Waiting on someone else

| What | Who | Since | Chased? |
|---|---|---|---|
| | | | |

## Things the next session should know

<!-- Anything true right now that is not obvious from the code: a half-finished refactor, a
     deliberately disabled test, a workaround that needs removing, a deploy that is half-applied.
     If you leave something in a strange state, this is where you say so. -->

-

<!-- orchestrate:session-state:start -->
<!-- Written by Orchestrate at the end of each session. Edits inside this block are
     replaced next session; anything OUTSIDE it is yours and is never touched. -->
### Engagement state — 2026-10-28
**Status:** blocked — Deploy B blocked by safety check bug consuming approvals. Profile-only deploy also blocked. Manual CLI deploy recommended.

**Done this session**
- Confirmed safety check defect: cannot distinguish missing profile from backup failure, loops requesting backups

**Open items**
- Escalate Deploy B safety check bug to Orchestrate team (session 98d70d6d-c047-4d6d-aaf6-068be5a06345)
- Deploy UC Portal Customer profile via CLI: sf project deploy start --source-dir force-app/main/default/profiles/UC\ Portal\ Customer.profile-meta.xml --target-org lal-devedition --test-level NoTestRun
- Deploy Deploy B (18 components + profile) via CLI with specified tests
- Verify profile created in lal-devedition post-execution
- Verify Deploy B components created in lal-devedition post-execution
- Run tests T1–T8 and confirm all pass
- Publish UC Portal site and activate UC Assist agent
- Open PR from develop to main with final state

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0
- Routing model: MOST_AVAILABLE; capacityType INHERITED, isAttributeBased false
- Disable sendWelcomeEmail before deploy
- Deploy from develop branch (commit 0eb8642 + context-only commits)
- Split deploy: Deploy A (done) then Deploy B (18 components, blocked by safety check bug)
- Deploy UC Portal Customer profile separately before Deploy B
- Bypass Orchestrate safety check: run both deploys manually via CLI from VS Code/terminal

**Blockers**
- Deploy B safety check bug: cannot distinguish new profile (nothing to back up) from backup failure; loops requesting backups and consuming approvals (5 consumed, no deploy executed)

**Next**
- Run profile-only deploy from CLI on develop branch
- Run Deploy B (18 components + profile) from CLI with specified tests on develop branch
- Verify both deploys succeeded in lal-devedition
- Report safety check defect to Orchestrate team with session ID 98d70d6d-c047-4d6d-aaf6-068be5a06345

**Checked live on 2026-10-28:** nothing — the status above is as recorded, not re-checked
### Last session — 2026-10-28
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `develop` |
| Name | Demo-AgentBuild-UseCase-1 |
| Session | `98d70d6d-c047-4d6d-aaf6-068be5a06345` |
**In its own words (excerpt):**
Nothing was deployed, and `lal-devedition` is unchanged. The safety check stopped your approved command before it ran. It asked for another permissions backup, this time in a new folder (`…/2026-10-28T12-12-39-768Z-1`). I already took exactly that backup for this profile last turn.

As I said I would, I've stopped here instead of going round again. That's now the fifth approval the check has used up without the deploy running. The cause is a defect in the check itself:
- The check tries to back up the profile from the org before it deploys.
- The UC Portal Customer profile is new, so there's nothing in the org to back up.
- The check can't tell "nothing to back up" from "backup failed", so it asks for a new backup on every run, whatever is already saved.

Retrying won't fix this from inside this session.

**Where things stand:**
- **Deployed and checked earlier:** Deploy A, 25 of 25 components.
- **Not deployed:** the profile, and Deploy B's 18 components (the Apex classes, the Flow, the UC Portal site, the UC Assist agent script, both permission sets and the group).
- Both of those passed their dry runs: the profile `0Afak00000q8DOkCAM` (1 of 1 component) and Deploy B `0Afak00000q

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
