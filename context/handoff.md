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
**Status:** on track — Agent router inventing text instead of handing off. Fix identified: update router instructions, republish v2, activate, commit.

**Done this session**
- Root cause analysis: Agent Router answered on its own instead of handing to Identity Verification subagent
- Confirmed 0 Verification Code records exist — no send ever ran
- Confirmed sender address now Verified in Setup
- Identified email mismatch: typed slalmohemed@gmail.com (unknown) instead of slalmohemed+maria@gmail.com
- Clarified S6 design: multiple active logins on same email = no code sent (by design)

**Open items**
- Edit UC_Assist.agent router instructions: always hand off, never claim code sent or reset started
- Validate bundle and publish version 2 to lal-devedition
- Activate version 2 in lal-devedition
- Commit router fix to develop (updates PR #1)
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
- Wording correction pending: S6 spec says 'active portal user' but code also matches inactive (intentional for T5)

**Blockers**
- None

**Next**
- Edit UC_Assist.agent router block instructions in repo
- Validate bundle and publish as version 2 to lal-devedition
- Activate version 2
- Commit and push to develop
- Run T6 in Preview: type 'I forgot my password', enter slalmohemed+maria@gmail.com, verify code arrives
- If T6 routes to T1 correctly, run T1–T8 and save as test set
- Merge PR #1 to main

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
I found why no email arrived. There are two separate causes.

**1. The agent never sent a code.** The tracer in your screenshot shows it: the Agent Router answered you itself and never handed over to Identity Verification, so the send action never ran. I checked `lal-devedition` and there are **0** Verification Code records, so no send has ever happened. The router's only tools are hand-offs to other subagents, so "I've sent a code" was invented text. Its instructions say which subagent to pick, but they don't stop it from answering on its own.

**2. That email wouldn't have got a code anyway.** You typed `slalmohemed@gmail.com`. No Contact has that address. The test customers are `slalmohemed+maria@gmail.com` and `slalmohemed+ken@gmail.com`. With an unknown email you get the neutral "if that email is on file" reply and no code, by design (test T3). One piece of good news: the sender address now shows **Verified**, so codes can go out.

**If several customers share an email:** none of them gets a code, and they see the same neutral reply. The send action only looks at Contacts that have a portal login. If more than one of those has the email, the code treats it as "not found". It d

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
