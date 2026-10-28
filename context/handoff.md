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
**Status:** on track — Script 01 done: agent user + Account Owner role live. Script 02 awaiting approval.

**Done this session**
- Script 01 executed: UC Assist Agent user created (005ak00000mI9ijAAC), UC_Assist_Agent permission set assigned, admin user given UC Account Owner role

**Open items**
- Approve script 02 (Lopez Freight and Ito Logistics accounts + contacts)
- Run script 02 and verify accounts and contacts in org
- Approve and run script 03 (portal users Maria and Ken)
- Approve and set up org-wide sender address
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
- Approve script 02 (accounts and contacts)
- Run script 02 and verify Lopez Freight and Ito Logistics accounts with contacts in org
- Approve script 03 (portal users)
- Run script 03 and verify Maria and Ken as portal users

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
Script 01 ran once, unchanged, and worked. I checked the results in `lal-devedition`:
- **Agent user:** "UC Assist Agent" (`ucassist.agent.e68b5eeb6b@example.com`, Id `005ak00000mI9ijAAC`) is created and active, on the Einstein Agent User profile with the Einstein Agent licence.
- **Permission set group:** `UC_Assist_Agent` is assigned to the agent user.
- **Your admin user:** now has the UC Account Owner role.

The agent user has no role. Einstein Agent users don't need one, so that's fine.

An Approve card is now waiting for script 02. It creates the Lopez Freight and Ito Logistics accounts, with Maria Lopez (slalmohemed+maria@gmail.com) and Ken Ito (slalmohemed+ken@gmail.com) as their contacts. Once you approve, I'll check them in the org and go on to script 03, the portal users.

Sources: checked live: `lal-devedition` (script result, user, permission set assignment and role queries) · not checked: nothing else
<!-- orchestrate:session-state:end -->
