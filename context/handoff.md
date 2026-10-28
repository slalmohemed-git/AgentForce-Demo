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
**Status:** on track — Router fix validated & ready to commit. Publish approval pending for v2 creation in lal-devedition.

**Done this session**
- Validated router fix bundle against lal-devedition — passes

**Open items**
- Approve publish: create version 2 of UC_Assist in lal-devedition
- Activate version 2 in lal-devedition
- Commit router fix to develop (updates PR #1)
- Push committed changes to GitHub
- Run T6 in Preview with slalmohemed+maria@gmail.com after v2 active
- Run T1–T8 sequence and save as test set
- Review and merge PR #1
- Decide: keep or remove test-data setup scripts from commit

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0
- Routing model: MOST_AVAILABLE; capacityType INHERITED, isAttributeBased false
- Disable sendWelcomeEmail before deploy
- Test UC_Assist in Preview panel (not in editing assistant chat)
- Use test customer emails: Maria (slalmohemed+maria@gmail.com), Ken (slalmohemed+ken@gmail.com), stranger (stranger@example.com)
- Fix router to always hand off immediately, never invent status claims

**Blockers**
- None

**Next**
- Approve publish to create version 2 in lal-devedition
- Commit router fix to develop
- Push to GitHub
- Approve activation of version 2
- Run T6 in Preview: verify code arrives for slalmohemed+maria@gmail.com

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
━━ Build status (auto-checked from tool results — deploy = sf CLI exit, not runtime effect) ━━
• Code committed: no new commit in this session run — if an earlier run committed, check the repository
• Pushed to GitHub: nothing new pushed in this session run — if an earlier run pushed, check the repository
• Validated (sf deploy validate): NOT verified
• Deployed to org: NO — not deployed to any org
Next: open/refresh the PR → review → merge to main → run a Deploy session to ship. This work is NOT live yet.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

I've put the router fix back on a fresh copy of `develop`, and it passes validation against `lal-devedition`. The fix makes the router hand every message to a subagent straight away. It can't reply itself, ask for an email or a code, or say a code was sent or a reset has started.

There's an Approve card for the publish. Approving it creates version 2 of `UC_Assist` in `lal-devedition`, and version 1 stays active until you approve activating version 2 separately. The fix isn't committed yet. I'll push it to `develop` after the publish so it can't get lost again.
<!-- orchestrate:session-state:end -->
