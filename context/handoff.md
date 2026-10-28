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
**Status:** at risk — Deploy A waiting (25 components, no permissions); split strategy avoids safety check loop but adds second approval step

**Done this session**
- Identified root cause: permission sets can't deploy before Apex/Flow/objects they grant access to
- Redesigned as Deploy A (25 components, no permissions) + Deploy B (permissions, Apex, Flow, tests)
- Deploy A passed dry run: 25/25 components, 0 errors (ID 0Afak00000q8TV7CAM)

**Open items**
- Approve Deploy A Approve card to execute 25-component deploy to lal-devedition
- Verify all 25 components created in org post-Deploy A
- Approve Deploy B Approve card (permissions, Apex, Flow, agent, tests)
- Verify Deploy B components and run tests T1–T8
- Publish UC Portal site
- Publish and activate UC Assist agent
- Open PR from develop to main with final state

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0
- Routing model: MOST_AVAILABLE; capacityType INHERITED, isAttributeBased false
- Disable sendWelcomeEmail before deploy
- Deploy from develop branch files (commit 0eb8642 + later context-only commits)
- Split deploy into two: Deploy A (objects, settings, role, queue, routing, Case values, Communities) then Deploy B (permissions, Apex, Flow, site, agent, tests)

**Blockers**
- Safety check loop on permissions backup requests — if Deploy A also triggers backup request despite having no permissions, escalate as bug to Orchestrate team

**Next**
- Approve Deploy A Approve card to execute 25-component deploy
- Verify 25 components created in lal-devedition post-Deploy A
- Approve and execute Deploy B with permissions, Apex, Flow, and tests

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
An Approve card is waiting for Deploy A. Nothing is deployed yet.

**Why the split changed:** your option put the permission files first, but that order can't work. The permission sets grant access to the Apex classes, the Flow and the Verification Code object, and none of those are in the org yet. The other way round fails too: the tests need the permission sets and the profile to exist. So I've split it differently.

**Deploy A (the waiting card):** 25 components with no Apex and no permissions:
- the Verification Code object and its fields
- the UC Assist Setting type and its record
- the role, the queue and the routing config
- the Case Origin and Reason values
- the Communities setting

It needs no tests. A dry run just passed: `0Afak00000q8TV7CAM`, 25 of 25 components, 0 errors. It doesn't touch permissions, so the backup check shouldn't come up.

**Deploy B (next, a separate Approve):** the profile, both permission sets and the group, each file named on its own. With them go the Apex classes, the Flow, the site file and the agent script, and the 5 test classes run.

Sources: checked live: `lal-devedition` (Deploy A dry run) · not checked: nothing else
<!-- orchestrate:session-state:end -->
