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
**Status:** on track — BUILD completed. Two test customers confirmed in lal-devedition. Ready to run T6 once sender address verified.

**Done this session**
- Confirmed two test customers (Maria Lopez, Ken Ito) exist in lal-devedition with correct emails and portal login states
- Clarified real test email addresses: slalmohemed+maria@gmail.com and slalmohemed+ken@gmail.com route to slalmohemed@gmail.com inbox

**Open items**
- Click verification link in slalmohemed@gmail.com inbox to activate sender address
- Verify sender address shows Verified in Setup → Organization-Wide Addresses
- Run test T6 in Preview panel: type 'I forgot my password', enter slalmohemed+maria@gmail.com, verify code arrives and UC_Assist routes to T1
- Run tests T1–T8 in Agentforce Builder Preview panel and save as Testing Center test set
- Add two permission sets to agent's permission set group in repo
- Review and merge PR #1
- Confirm whether to keep test-data setup scripts in commit or remove them

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0
- Routing model: MOST_AVAILABLE; capacityType INHERITED, isAttributeBased false
- Disable sendWelcomeEmail before deploy
- Test UC_Assist in Preview panel (not in the editing assistant chat)
- Use test customer emails: Maria (slalmohemed+maria@gmail.com), Ken (slalmohemed+ken@gmail.com), stranger (stranger@example.com)

**Blockers**
- None

**Next**
- Click email verification link for sender address in slalmohemed@gmail.com inbox
- Confirm sender address Verified status in Setup → Organization-Wide Addresses
- Run T6 in Preview panel: type 'I forgot my password', provide slalmohemed+maria@gmail.com, enter 6-digit code from inbox
- If T6 routes to T1 correctly, run T1–T8 sequence and save as test set
- Review PR #1 and merge to main
- Schedule Deploy session

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
Yes, the exercise created two test customers. I checked them in `lal-devedition` just now. You don't log in as either of them to test. In the Preview panel you act as the customer and type that customer's email when UC Assist asks for it.

**I need to correct my last message.** I told you to type `you+maria@gmail.com`, but that was only the spec's placeholder. The real email on file is `slalmohemed+maria@gmail.com`. If you type the placeholder, the agent gives the same neutral "if that email is on file" reply but sends no code, which is what test T3 checks for.

| Customer | Email to type in Preview | Portal login | Use it for |
|---|---|---|---|
| **Maria Lopez** | `slalmohemed+maria@gmail.com` | `maria.lopez.ucportal@example.com`, **Active** | T1 (happy path), T2 (three wrong codes), T4 (jailbreak), T6 (direct ask), T7 (stale session) |
| **Ken Ito** | `slalmohemed+ken@gmail.com` | `ken.ito.ucportal@example.com`, **Inactive** on purpose | T5: the reset should fail with no active login and hand you to a person |
| *(no record)* | `stranger@example.com` | — | T3: unknown email, same neutral reply, no code sent |

**How the emails reach you:** both plus-addresses deliver to your own

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
