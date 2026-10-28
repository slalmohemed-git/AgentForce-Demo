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
**Status:** on track — Script 03 done: portal users Maria (active) & Ken (inactive) live. Org-wide sender address awaiting approval.

**Done this session**
- Script 03 executed: portal users Maria Lopez and Ken Ito created on UC Portal Customer profile
- Verified both portal users in lal-devedition org with correct email addresses and active/inactive states

**Open items**
- Approve and set up org-wide sender address (UC Support) — requires verification link click
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
- Approve org-wide sender address (UC Support) setup
- Click verification link sent to slalmohemed@gmail.com to activate sender address
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
I ran script 03 once, unchanged, and it worked. Both portal users are now in `lal-devedition` on the UC Portal Customer profile:
- **Maria Lopez:** `maria.lopez.ucportal@example.com` (`005ak00000mIFrOAAW`), active, linked to her contact.
- **Ken Ito:** `ken.ito.ucportal@example.com` (`005ak00000mIFrNAAW`), inactive, which test T5 needs.
- **Licences:** 1 of your 5 Customer Community licences is used. Ken's inactive user doesn't take one.

An Approve card is waiting for the last setup item. It adds the org-wide address "UC Support" <slalmohemed@gmail.com>, open to all profiles, which the verification-code emails are sent from. The org has no org-wide addresses yet. After you approve, Salesforce emails a verification link to that inbox, and you'll need to click it before the address can send.

Sources: checked live: `lal-devedition` (script result, User and UserLicense queries, OrgWideEmailAddress query) · not checked: nothing else
<!-- orchestrate:session-state:end -->
