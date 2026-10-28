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
**Status:** on track — Router fix committed & pushed to GitHub (PR #1). Version 2 created in lal-devedition, awaiting activation.

**Done this session**
- Committed router fix to develop (commit 59d54fe, +3/-1 lines in UC_Assist.agent)
- Pushed to GitHub — PR #1 now includes the fix
- Rebased onto 6 newer handoff.md commits with no conflicts
- Confirmed version 2 of UC_Assist created in lal-devedition at 17:32 UTC

**Open items**
- Approve activation: switch lal-devedition live agent from version 1 to version 2
- Verify version 2 shows Active after approval
- Run T6 in Preview with slalmohemed+maria@gmail.com to verify fixed router
- Run T1–T8 sequence and save as test set
- Review and merge PR #1 to main
- Run Deploy session to ship to production
- Decide: keep or remove test-data setup scripts from commit

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0
- Routing model: MOST_AVAILABLE; capacityType INHERITED, isAttributeBased false
- Disable sendWelcomeEmail before deploy
- Test UC_Assist in Preview panel (not in editing assistant chat)
- Use test customer emails: Maria (slalmohemed+maria@gmail.com), Ken (slalmohemed+ken@gmail.com), stranger (stranger@example.com)
- Fix router to always hand off immediately, never invent status claims
- Push router fix after publish approval to prevent loss

**Blockers**
- None

**Next**
- Approve activation of version 2 in lal-devedition
- Verify version 2 becomes Active
- Run T6 in Preview panel with slalmohemed+maria@gmail.com
- Review PR #1 and merge to main
- Schedule Deploy session to ship to production

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
• Code committed: yes (branch develop)
• Pushed to GitHub: yes
• Validated (sf deploy validate): NOT verified
• Deployed to org: no deploy in this session run — if an earlier run deployed, verify in the target org
Next: open/refresh the PR → review → merge to main → run a Deploy session to ship. This work is NOT live yet.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

The router fix is on GitHub. `develop` now points to commit `59d54fe`, which changes only `UC_Assist.agent` (+3/-1 lines), and PR #1 includes it. Before pushing I rebased onto 6 newer automatic commits that only touch `handoff.md`, and there were no conflicts.

In `lal-devedition`, version 2 (created 17:32 UTC) is still Inactive, and version 1 is still the Active one. There's an Approve card for `sf agent activate --api-name UC_Assist --version 2`. Approving it switches the live agent to the fixed router. Then I'll check it shows Active, and you can rerun T6 in the Preview panel with `slalmohemed+maria@gmail.com`.

Sources: checked live: GitHub (remote `develop` tip `59d54fe`), `lal-devedition` (BotVersion query) · not che

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
