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
**Status:** on track — Step 4 ready: publish command validated, awaiting approval to execute UC_Assist agent publish

**Done this session**
- Ran read-only safety check for publish and activate commands
- Confirmed develop branch and command options (--api-name, --target-org, --version)
- Identified scripts/ folder not yet committed — will include in step 6 handoff

**Open items**
- Click verification link in slalmohemed@gmail.com inbox to activate sender address
- Confirm address shows as Verified in Setup → Organization-Wide Addresses
- Approve and execute publish UC_Assist authoring bundle to lal-devedition (creates version 1)
- Approve and execute activate version 1 in lal-devedition
- Verify agent and active version exist in org after activation
- Run tests T1–T8 and confirm all pass
- Commit scripts/ folder with handoff notes and open PR from develop to main

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
- After publish succeeds, approve activate version 1 command
- Verify agent and active version in lal-devedition org

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
I ran the read-only check once, unchanged. It confirmed you're on `develop`. It also showed the options for the two commands: publish takes `--api-name` and `--target-org`, and activate takes `--api-name`, `--target-org` and an optional `--version`. One thing it found: the `scripts/` folder with the three test-data setup scripts isn't committed yet. I'll commit it with the handoff in step 6.

An Approve card is now waiting for the real publish. It publishes the `UC_Assist` authoring bundle to `lal-devedition`, which creates version 1 of the agent. Once you approve, I'll check the result, ask for approval to activate version 1, and then confirm in the org that the agent and its active version exist.
<!-- orchestrate:session-state:end -->
