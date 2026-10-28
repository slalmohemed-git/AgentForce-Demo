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
**Status:** on track — UC Assist solution documented (D01); email delivery & repo records still need fixes before deploy

**Done this session**
- Wrote D01 — UC Assist Solution Summary (11 sections, 16 KB) covering deliverables, architecture, design, test status, and deployment order
- Confirmed v3 active, Flow active, 23 Apex tests passing (91.9–100% coverage)
- Identified repo gaps: PR #1 description outdated, spec changelog incomplete, todo.md not updated

**Open items**
- Search Gmail Spam and All Mail for 'Your UC verification code' email; check Setup → Email Log Files if not found
- Fix sender address: clear Org_Wide_Email_Address__c or verify non-Gmail domain sender
- Rerun T6 handoff test with fresh verification code
- Complete and test T1–T8 test suite end to end
- Commit D01 to docs/, update PR #1 description, update spec changelog, update tasks/todo.md
- Add Verification Code tab and read-only permission set for admin audit trail access
- Review and merge PR #1 to main
- Schedule Deploy session to production

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
- Verification email not arriving (Gmail SPF/DMARC rejection of Salesforce-sent mail claiming @gmail.com sender)

**Next**
- Search Gmail Spam and All Mail for verification code email; check Salesforce email log if not found
- Fix sender address configuration
- Request new verification code and rerun T6 test
- Commit D01 and update repo records (PR #1, spec changelog, todo.md)
- Add admin access to Verification Code audit trail
- Complete T1–T8 test suite
- Merge PR #1 and schedule Deploy session

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
I've written the summary of deliverables and technical design as **D01 — UC Assist Solution Summary**, and it's attached to this session. It's 11 sections and about 16 KB.

**What it covers:**
- **Deliverables:** the specs, design review and ADRs in git, the 43 Salesforce components, and the setup scripts and test data.
- **Architecture:** option B, two subagents, and the three controls that stop an unverified reset (the action gate, a forced hand-off to verification, and a token re-check on the server).
- **Detailed design:** the Agent Script subagents and variables, versions 1 to 3, the Verification Code object and its status lifecycle, the settings, the Apex classes with test coverage, the Flow steps, and the security controls.
- **Status of each user story:** US-4 is fully met. The others are built but haven't been tested end to end yet. Live transfer to a human for US-5 is still out of scope.
- **Open items, deployment order for a new org, and next steps.**

**Checked in `lal-devedition` before writing:**
- Version 3 of `UC_Assist` is the active version.
- The Flow is active.
- All 23 Apex tests passed in the last validation, with coverage between 91.9% and 100% per class.
- P

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
