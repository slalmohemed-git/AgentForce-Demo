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
**Status:** at risk — Deploy A done. Deploy B blocked by safety check bug (4 approvals consumed). Profile-only deploy waiting for approval.

**Done this session**
- Prepared profile-only deploy (UC Portal Customer profile, dry run passed 1/1)

**Open items**
- Escalate Deploy B safety check bug to Orchestrate team (session 98d70d6d-c047-4d6d-aaf6-068be5a06345)
- Approve profile-only deploy Approve card
- Approve Deploy B Approve card (18 components: permissions, Apex, Flow, site, agent, tests)
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

**Blockers**
- Deploy B safety check repeatedly consuming approvals without executing (4 times)—suspected bug in Orchestrate safety check logic

**Next**
- Approve profile-only deploy Approve card
- Verify UC Portal Customer profile exists in lal-devedition
- Approve Deploy B Approve card for 18-component deploy
- If safety check blocks again, pause and escalate to Orchestrate team

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
Nothing has been deployed yet. There's an Approve card waiting for the profile-only deploy. It adds just the UC Portal Customer profile to `lal-devedition`, with system permissions only and no tests. Its dry run passed (`0Afak00000q8DOkCAM`, 1 of 1 components, 0 errors).

The safety check asked for its backup before the approval step this time, so no approval was used up. The backup is saved and shows the profile doesn't exist yet, so nothing can be removed. Once you approve, I'll check the profile exists in the org and then re-run Deploy B unchanged.
<!-- orchestrate:session-state:end -->
