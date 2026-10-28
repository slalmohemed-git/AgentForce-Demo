# Handoff — current state

> **Rewritten at the end of every session.** This file is *now*; [`gotchas.md`](gotchas.md) is *forever*.
> If this file and [`../CONTEXT.md`](../CONTEXT.md) disagree, this one is newer.

**Last updated:** 2026-10-28 · **By:** Orchestrate build session (Demo-AgentBuild-UseCase-1)

---

## Where things stand

The UC Assist password-reset build (43 components) is deployed to `lal-devedition`. The `UC_Assist`
Agent Script bundle is published and **version 1 is Active** (BotVersion `0X9ak000007eFPJCA2`, checked
2026-10-28). The end-to-end tests T1–T8 have not been run yet, and the outgoing sender address still needs verifying.

## In progress

| What | State | Where it lives | Blocked on |
|---|---|---|---|
| Tests T1–T8 (spec test scripts) | Not run | Agentforce Builder test panel | Nothing |
| Org-wide sender address | Verification email sent, not clicked | Setup → Organization-Wide Addresses | Lal clicking the link |
| PR develop → main | Open | GitHub | Review |

## Next steps

<!-- Ordered. The top item should be the one to do next, not the most interesting one. -->

1. Click the verification link sent to slalmohemed@gmail.com, then confirm the address shows Verified.
2. Run T1–T8 in the Agentforce Builder test panel and check the plan tracer each turn.
3. Save T1–T8 as an Agentforce Testing Center test set.
4. Review and merge the PR from `develop` to `main`.

## Waiting on someone else

| What | Who | Since | Chased? |
|---|---|---|---|
| Sender address verification | Lal Shaik | 2026-10-28 | No |

## Things the next session should know

<!-- Anything true right now that is not obvious from the code: a half-finished refactor, a
     deliberately disabled test, a workaround that needs removing, a deploy that is half-applied.
     If you leave something in a strange state, this is where you say so. -->

- Two permission sets were assigned by hand in the org to make publish work (see gotchas.md). They are
  not in the repo's permission set group yet, so a fresh org setup needs them assigned again.
- Test data (users, customers, portal users) is created by the scripts in `scripts/apex/`, run in order 01 → 03.

<!-- orchestrate:session-state:start -->
<!-- Written by Orchestrate at the end of each session. Edits inside this block are
     replaced next session; anything OUTSIDE it is yours and is never touched. -->
### Engagement state — 2026-10-28
**Status:** on track — UC_Assist published, version 1 created (0X9ak000007eFPJCA2). Awaiting approval to activate.

**Done this session**
- Publish UC_Assist authoring bundle command executed successfully
- Version 1 created in lal-devedition (0X9ak000007eFPJCA2) at 15:45 UTC
- Agent 0Xxak000004Sp0TCAS confirmed in org

**Open items**
- Approve and execute activate version 1 (sf agent activate --api-name UC_Assist --version 1)
- Verify version 1 shows Active in lal-devedition after activation
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
- Approve sf agent activate --api-name UC_Assist --version 1 command
- Verify version 1 shows Active in lal-devedition
- Run tests T1–T8
- Activate sender address and verify in Setup

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
The `UC_Assist` publish worked this time. The command ran once, unchanged. In `lal-devedition`, the agent is there (`0Xxak000004Sp0TCAS`) and version 1 was created at 15:45 UTC (`0X9ak000007eFPJCA2`). It's still Inactive.

You chose "Publish and activate", so an Approve card is now waiting for `sf agent activate --api-name UC_Assist --version 1`. That puts version 1 live. Once you approve it, I'll check in the org that the version shows Active. Then I'll commit the restored test-data scripts and the handoff to `develop`, push, and open the PR to `main`.

Sources: checked live: `lal-devedition` (BotDefinition and BotVersion queries) · not checked: activation, which hasn't run yet
<!-- orchestrate:session-state:end -->
