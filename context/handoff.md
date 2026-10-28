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
**Status:** waiting — Deploy B live (43/43 components). Awaiting approval to set up test data (script 01: UC Account Owner role + agent user).

**Done this session**
- None

**Open items**
- Approve script 01: assign UC Account Owner role to admin, create UC Assist Agent user, assign permission set group
- Run scripts 02–03 and org-wide sender address setup (likely requiring separate approvals)
- Publish and activate UC Assist agent
- Run tests T1–T8 and confirm all pass
- Update handoff notes and open PR from develop to main

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0
- Routing model: MOST_AVAILABLE; capacityType INHERITED, isAttributeBased false
- Disable sendWelcomeEmail before deploy
- Deploy from develop branch (commit 0eb8642 + context-only commits)
- Split deploy: Deploy A then Deploy B (18 components, now deployed)
- Deploy UC Portal Customer profile separately before Deploy B
- Use quick-deploy for validated job instead of retrying safety check

**Blockers**
- None

**Next**
- Approve script 01 (UC Account Owner role + agent user creation)
- Run script 01 and verify result in org
- Approve and run scripts 02–03 (Maria and Ken as portal users)
- Approve and set up org-wide sender address
- Publish and activate UC Assist agent
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
Nothing has changed in the org yet. An Approve card is waiting for script 01. It gives your admin user the UC Account Owner role, creates the "UC Assist Agent" user without sending an email, and assigns it the UC_Assist_Agent permission set group. Once you approve, I'll run it, check the result, and then go on to scripts 02 and 03 and the org-wide address. Each of those will probably ask for its own approval.
<!-- orchestrate:session-state:end -->
