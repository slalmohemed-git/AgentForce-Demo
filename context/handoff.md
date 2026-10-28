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
**Status:** at risk — Deploy A done (25/25). Deploy B blocked by safety check consuming approvals—bug suspected, needs escalation.

**Done this session**
- None

**Open items**
- Escalate Deploy B safety check bug to Orchestrate team (4th approval consumed without execution)
- Approve Deploy B Approve card to execute 18-component deploy
- Verify Deploy B components created in lal-devedition post-execution
- Run tests T1–T8 and confirm all pass
- Publish UC Portal site and activate UC Assist agent
- Set up test data
- Open PR from develop to main with final state

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0
- Routing model: MOST_AVAILABLE; capacityType INHERITED, isAttributeBased false
- Disable sendWelcomeEmail before deploy
- Deploy from develop branch files (commit 0eb8642 + later context-only commits)
- Split deploy into two: Deploy A (objects, settings, role, queue, routing, Case values, Communities) then Deploy B (permissions, Apex, Flow, site, agent, tests)

**Blockers**
- Deploy B safety check repeatedly consuming approvals without executing deploy (4 times)—suspected bug in Orchestrate safety check logic

**Next**
- Report Deploy B safety check bug to Orchestrate team with session ID 98d70d6d-c047-4d6d-aaf6-068be5a06345
- Approve Deploy B Approve card once (will execute immediately if bug is fixed)
- If blocked again, pause and wait for Orchestrate team response before further approvals

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
Deploy B hasn't run, and nothing has changed in `lal-devedition`. The safety check stopped your approved command before it started and asked for another permissions backup in a new folder. That blocked attempt used up your approval, so a new Approve card is waiting for the same unchanged command.

The backup it asked for is now saved. It shows the UC Portal Customer profile and both permission sets don't exist in the org yet, so this deploy can only add permissions. The command deploys the last 18 components (Apex classes, the Flow, the UC Portal site, the UC Assist agent script, the profile, both permission sets and the group) and runs the 5 test classes. Its dry run passed earlier with 23 of 23 tests.

This is the fourth time the check has used up an approval like this. That looks like a bug in the deploy safety check, and it's worth reporting to the Orchestrate team. When you approve, I'll run the command once. If it's blocked again I'll tell you straight away instead of going round the loop.
<!-- orchestrate:session-state:end -->
