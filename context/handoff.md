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
**Status:** on track — Develop branch re-cloned (a7094de). Publish UC_Assist command ready for approval; scripts folder to be recreated.

**Done this session**
- Re-cloned develop branch (commit a7094de) with UC_Assist bundle

**Open items**
- Click verification link in slalmohemed@gmail.com inbox to activate sender address
- Confirm address shows as Verified in Setup → Organization-Wide Addresses
- Approve and execute publish UC_Assist authoring bundle to lal-devedition (creates version 1)
- Verify version 1 created in org after publish succeeds
- Approve and execute activate version 1 in lal-devedition
- Verify agent and active version exist in org after activation
- Run tests T1–T8 and confirm all pass
- Recreate and commit scripts/ folder with handoff notes; open PR from develop to main

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
- After publish succeeds, verify version 1 created in lal-devedition
- Approve activate version 1 command

**Checked live on 2026-10-28:** the repository
### Last session — 2026-10-28
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `develop` |
| Name | Demo-AgentBuild-UseCase-1 |
| Session | `98d70d6d-c047-4d6d-aaf6-068be5a06345` |
**In its own words (excerpt):**
Nothing has been published yet, and nothing in `lal-devedition` changed this run. The approved command was used up when it failed at its first step. The folder it starts in wasn't on this machine, so the publish part never ran, and the "User doesn't have access to agent" output was the old result left over from the earlier attempt.

I've re-cloned `develop` (commit a7094de), which has the `UC_Assist` bundle, and a new Approve card is waiting for the same publish command. It creates version 1 of the agent in `lal-devedition`. After you approve it, I'll check the result and then ask you to approve activating version 1.

The `scripts/` folder with the three test-data setup scripts was never committed, so it didn't survive the move to a new machine. The records those scripts created are still in the org. I'll write the scripts again and commit them in the handoff step.

Sources: checked live: GitHub `develop` branch (clone) · not checked: the org, since nothing ran against it this run
<!-- orchestrate:session-state:end -->
