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
**Status:** on track — Deploy B quick-deployed successfully (18/18 components live). All 43 build components now in lal-devedition. Ready for test data setup.

**Done this session**
- Quick-deployed validated Deploy B job (0Afak00000q8jBhCAI) as deploy 0Afak00000q8hLCCAY
- Verified all 18 components in lal-devedition: 11 Apex classes, Flow, profile, 2 permission sets, permission set group, UC Portal site (now Live), UC Assist agent script
- Confirmed all 43 build components (Deploy A + Deploy B) now present in org

**Open items**
- Set up test data: user role, Maria and Ken as portal users, org-wide sender address, agent user with permission set group
- Publish UC Assist agent and activate it
- Run tests T1–T8 and confirm all pass
- Update handoff notes and open PR from develop to main

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0
- Routing model: MOST_AVAILABLE; capacityType INHERITED, isAttributeBased false
- Disable sendWelcomeEmail before deploy
- Deploy from develop branch (commit 0eb8642 + context-only commits)
- Split deploy: Deploy A (done) then Deploy B (18 components, now deployed)
- Deploy UC Portal Customer profile separately before Deploy B
- Use quick-deploy for validated job instead of retrying safety check

**Blockers**
- None

**Next**
- Approve test data setup: user role, Maria and Ken portal users, org-wide sender address, agent user assignment
- Set up test data in lal-devedition (step 3)
- Publish and activate UC Assist agent (step 4)
- Run tests T1–T8 and report results (step 5)
- Open PR from develop to main with final state (step 6)

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
Deploy B worked: all 18 components are now in `lal-devedition`. The command ran once, unchanged, and the safety check didn't stop it this time.

**What it did:** it quick-deployed the job I validated earlier (`0Afak00000q8jBhCAI`) as deploy `0Afak00000q8hLCCAY`. It reported success with 18 of 18 components and 0 errors. Because it was a quick deploy, it reused the 23 of 23 test results from that validation and didn't run the tests again.

**What I checked in the org afterwards:**
- **11 Apex classes:** the 5 action and service classes, their 5 test classes and `VerificationTestDataFactory`. All are present.
- **The `SUB_Reset_Portal_Password` Flow:** version 1, Active.
- **The UC Portal Customer profile:** present.
- **Both permission sets:** `DATA_Identity_Verification_CRU` and `APP_UC_Assist_Agent` are present.
- **The `UC_Assist_Agent` permission set group:** present. Its status is "Updated", which means it has finished recalculating and is ready to assign.
- **The UC Portal site:** the deploy changed it, and its status is now **Live**. Before, it was Under Construction, so the site file in this deploy switched it on.
- **The UC Assist agent script:** saved in the org as `UC_Ass

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
