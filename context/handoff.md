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
**Status:** on track — Script 02 done: Lopez Freight & Ito Logistics accounts + contacts live. Script 03 awaiting approval.

**Done this session**
- Script 02 executed: Lopez Freight and Ito Logistics accounts created with Maria Lopez and Ken Ito contacts
- Verified accounts and contacts in lal-devedition org

**Open items**
- Approve script 03 (portal users Maria and Ken)
- Run script 03 and verify portal users in org
- Approve and set up org-wide sender address (UC Support)
- Publish and activate UC Assist agent
- Run tests T1–T8 and confirm all pass
- Update handoff notes and open PR from develop to main

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0
- Routing model: MOST_AVAILABLE; capacityType INHERITED, isAttributeBased false
- Disable sendWelcomeEmail before deploy
- Deploy from develop branch (commit 0eb8642 + context-only commits)
- Split deploy: Deploy A then Deploy B (18 components, deployed)
- Deploy UC Portal Customer profile separately before Deploy B
- Use quick-deploy for validated job instead of retrying safety check

**Blockers**
- None

**Next**
- Approve script 03 (portal users Maria active, Ken deactivated)
- Run script 03 and verify both portal users on UC Portal Customer profile in org
- Set up and approve org-wide sender address (UC Support)
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
Script 02 ran once, unchanged, and worked. I checked `lal-devedition` afterwards and both customers are there:
- **Lopez Freight** (1 account), with contact **Maria Lopez** (slalmohemed+maria@gmail.com, `003ak00002K5ZJxAAN`).
- **Ito Logistics** (1 account), with contact **Ken Ito** (slalmohemed+ken@gmail.com, `003ak00002K5ZJyAAN`).
- Your admin user owns both accounts and has the UC Account Owner role. Customer portal users need their account's owner to have a role, so script 03 can create them.

Script 03 hasn't run yet and is waiting for your Approve click. It creates the portal users on the UC Portal Customer profile without sending welcome emails. Maria stays active and Ken is deactivated, which test T5 needs. This uses 2 of your 5 Customer Community licences. Once you approve, I'll check both users and then add the "UC Support" org-wide address.

Sources: checked live: `lal-devedition` (script result, Contact and Account queries) · not checked: nothing else
<!-- orchestrate:session-state:end -->
