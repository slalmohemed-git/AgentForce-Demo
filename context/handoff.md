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
**Status:** on track — Router fix v3 ready to publish; PR #1 validated and pushed. Next: approve publish, activate v3, rerun T6.

**Done this session**
- Fixed Password Reset to always hand off unverified customers to Identity Verification
- Validated fix (commit 7cd0587) and pushed to develop branch
- Added fix to PR #1

**Open items**
- Approve publishing fix as UC_Assist version 3 in lal-devedition
- Approve activating version 3 (after publish approval)
- Rerun T6 in Preview panel with slalmohemed+maria@gmail.com to verify handoff now works
- Complete remaining T1–T8 tests and save as test set in Testing Center
- Review and merge PR #1 to main
- Decide: keep or remove test-data setup scripts from commit
- Schedule Deploy session to ship to production

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
- Approve publishing fix as version 3 of UC_Assist in lal-devedition
- Approve activating version 3
- Rerun T6 in Preview with slalmohemed+maria@gmail.com; type 'I forgot my password' and verify handoff to Identity Verification
- Check slalmohemed@gmail.com inbox for verification code email
- Complete remaining T1–T8 tests
- Review PR #1 and merge to main
- Schedule Deploy session for production ship

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

I've fixed Password Reset so a customer who isn't verified is always sent straight to Identity Verification. In your T6 run it said it would start verification, then stopped without handing over, so no code was ever sent. The fix is validated and pushed to `develop` (commit `7cd0587`, which adds to PR #1).

There's an Approve card for publishing the fix as version 3 of `UC_Assist` in `lal-devedition`. Version 2 stays live until you also approve activating version 3, which comes next.
<!-- orchestrate:session-state:end -->
