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
**Status:** on track — Permission set assigned ✓; awaiting approval to publish UC_Assist bundle and create version 1

**Done this session**
- None

**Open items**
- Approve and execute publish UC_Assist authoring bundle command
- Verify version 1 created in lal-devedition after publish succeeds
- Approve and execute activate version 1 in lal-devedition
- Run tests T1–T8 and confirm all pass
- Click verification link in slalmohemed@gmail.com inbox to activate sender address
- Confirm address shows as Verified in Setup → Organization-Wide Addresses
- Commit restored test-data scripts and handoff to develop, push, open PR to main

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
- Approve publish UC_Assist authoring bundle command
- Verify version 1 created in lal-devedition
- Approve activate version 1 command

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
An Approve card is waiting for the `UC_Assist` publish. It publishes the authoring bundle to `lal-devedition` and creates version 1 of the agent. The two permission sets that were missing are now assigned, so this is the retry after that fix.

Once you approve it, I'll check the result and ask you to approve activating version 1. After that I'll commit the restored test-data scripts and the handoff to `develop`, push, and open the PR to `main`.
<!-- orchestrate:session-state:end -->
