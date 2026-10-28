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
**Status:** on track — BUILD completed; code committed & pushed. Awaiting email verification, test runs T1–T8, and PR #1 review before Deploy.

**Done this session**
- Confirmed UC_Assist v1 is Active in lal-devedition and responds in Preview panel
- Clarified that Builder's assistant replies are separate from UC_Assist agent behavior
- Provided test procedure: T6 (password reset) → T1 (identity verification) with email code flow

**Open items**
- Click verification link in slalmohemed@gmail.com inbox to activate sender address
- Verify sender address shows Verified in Setup → Organization-Wide Addresses
- Run tests T1–T8 in Agentforce Builder Preview panel and save as Testing Center test set
- Add two permission sets (assigned by hand) to agent's permission set group in repo
- Review and merge PR #1 (retitle & update description if needed)
- Confirm whether to keep test-data setup scripts in commit or remove them

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0
- Routing model: MOST_AVAILABLE; capacityType INHERITED, isAttributeBased false
- Disable sendWelcomeEmail before deploy
- Test UC_Assist in Preview panel (not in the editing assistant chat)

**Blockers**
- None

**Next**
- Click email verification link and confirm sender address Verified status
- Run test T6 in Preview panel: type 'I forgot my password' and report UC_Assist's reply
- If T6 routes correctly, run T1–T8 and save as test set
- Review PR #1, retitle if needed, merge to main
- Schedule Deploy session to ship to production

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
That reply came from Agentforce Builder's own built-in assistant, not from UC Assist, so this doesn't show a problem with the agent. The wording "editing your agent and answering questions about your agent and the Agentforce development platform" is how the Builder's helper describes its own job. I searched the `UC_Assist` script in the repo and that text isn't anywhere in it.

**To test UC Assist itself:**
1. In Setup, go to **Agentforce Agents**, then **UC Assist**, and open it in Builder.
2. Check you're looking at **version 1**, the active one.
3. Open the **Preview** (conversation test) panel. Don't type into the assistant chat you used just now, which is for editing the agent.
4. Type `I forgot my password` there.

**What should happen:** this is test T6 from the spec, where a customer asks for a reset straight away. UC Assist should send you to identity verification first by asking for the email you use for the UC Portal. If you then give `you+maria@gmail.com`, it should reply "If that email is on file, a 6-digit code has been sent…", which starts T1.

**Before you run T1:**
- The sender address still isn't verified, so the code email may not arrive yet. Click the verificati

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
