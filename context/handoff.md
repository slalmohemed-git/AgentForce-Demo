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
**Status:** waiting — Build ready; deploy approval consumed by safety check. Fresh permissions backup taken. New Approve card waiting.

**Done this session**
- Took fresh org permissions backup (UC Portal Customer profile & permission sets confirmed absent)

**Open items**
- Approve & execute deploy of 43 components to lal-devedition (new Approve card waiting)
- Verify all 43 components created in org post-deploy
- Set up test data: user role, Maria & Ken users, org-wide sender, agent user with permission group
- Publish UC Portal site
- Publish and activate UC Assist agent
- Run tests T1–T8 and report results
- Open PR from develop to main with final state

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0
- Routing model: MOST_AVAILABLE; capacityType INHERITED, isAttributeBased false
- Disable sendWelcomeEmail before deploy
- Deploy from develop branch files (commit 0eb8642 + later context-only commits)

**Blockers**
- None

**Next**
- Approve the new waiting Approve card to execute 43-component deploy to lal-devedition
- Verify each of 43 components exists in org post-deploy
- Set up test data: role, Maria & Ken users, org-wide sender, agent user + permission group
- Publish UC Portal site and UC Assist agent
- Run tests T1–T8

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
Nothing was deployed yet. Your approval was used up on the first run, when the safety check stopped the command and asked for a fresh permissions backup. I've taken that backup: it confirms the UC Portal Customer profile and the two permission sets don't exist in the org yet, so this deploy can only add permissions.

There's a new Approve card waiting for the same command. It deploys the 43 UC Assist components from `develop` (commit `0eb8642` plus a later commit that only touches the context files) to `lal-devedition`, and runs the 5 test classes. Once you approve, I'll run it and then check in the org that each component exists.
<!-- orchestrate:session-state:end -->
