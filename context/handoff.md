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
**Status:** on track — Router fix live in lal-devedition v2 (Active). Next: rerun T6 in Preview to verify handoff behavior.

**Done this session**
- Activated version 2 of UC_Assist in lal-devedition (command succeeded)
- Confirmed version 2 now Active, version 1 Inactive as of 17:56 UTC
- Fixed router (commit 59d54fe) is now live to customers

**Open items**
- Rerun T6 in Preview panel with slalmohemed+maria@gmail.com to verify handoff works
- Complete T1–T8 sequence and save as test set in Testing Center
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
- Rerun T6 in Preview panel with slalmohemed+maria@gmail.com; type 'I forgot my password' and verify handoff to Identity Verification or Password Reset
- Check slalmohemed@gmail.com inbox for verification code email
- If email fails, check org for new Verification Code record
- Complete remaining T1–T8 tests
- Review PR #1 and merge to main
- Schedule Deploy session for production ship

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
I ran the command once, exactly as approved, and version 2 of `UC_Assist` is now the live agent in `lal-devedition`. The command returned `success: true` for version 2. I then checked the org, and both versions changed at 17:56 UTC:

| Version | Status | Id |
|---|---|---|
| 1 | Inactive | `0X9ak000007eFPJCA2` |
| 2 | **Active** | `0X9ak000007ePlFCAU` |

The fixed router (commit `59d54fe` on `develop`, part of PR #1) is now what customers reach.

**Next: rerun T6 to check the fix**
1. Open UC Assist in Agentforce Builder, check you're on version 2, and use the **Preview** panel (not the Builder's own assistant chat).
2. Type `I forgot my password`. The plan tracer should show a handoff to Identity Verification or Password Reset, not the router replying itself.
3. When it asks for your email, give `slalmohemed+maria@gmail.com`. Look in your `slalmohemed@gmail.com` inbox for "Your UC verification code". The sender address is now verified, so the email should arrive.
4. If no email comes, tell me and I'll check the org for a new Verification Code record.

**Still open:** the rest of T1–T8 and saving them as a Testing Center test set, merging PR #1, and deciding whether to keep the tes

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
