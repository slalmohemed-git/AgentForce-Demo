# Handoff — current state

> **Rewritten at the end of every session.** This file is *now*; [`gotchas.md`](gotchas.md) is *forever*.
> If this file and [`../CONTEXT.md`](../CONTEXT.md) disagree, this one is newer.

**Last updated:** 2026-11-19 · **By:** Orchestrate build session (Poc-Antioch-Build-p1)

---

## Where things stand

**POC Phase 1 (schema and access) is done** and deployed to `lal-devedition` (deploy `0Afak00000tTsOjCAK`,
16 of 16 components). Read back on 2026-11-19:

- `POC_Submission_Log__c`: Auto Number `SUB-{000000}`, Private, 7 fields. `Submission_Id__c` is Text(80),
  Unique (case-sensitive), External ID. A duplicate key was rejected and a lowercase key was accepted.
  The validation rule `Requester_Required` rejects a log with no Requester. (A User lookup can't be made
  required at field level, so a rule does it.) The test records were deleted; the object is empty.
- Case Origin now includes **Agent**. Case Type now includes **General Inquiry**, **Access Request** and
  **Technical Issue**. The existing values are unchanged. Priority is unchanged.
- No `Submission_Log__c` back-link on Case: `POC_Submission_Log__c.Case__c` already joins them.
- Permission sets: `POC_Case_Agent_Access` (Case and log: Read, Create, Edit, no Delete, View All or Modify All),
  `POC_Knowledge_Agent_Access` (Knowledge__kav Read, `Article_Body__c` Read, no Case),
  `POC_Submission_Log_Audit` (log Read only).

The UC Assist and Staff_Assistant builds were not touched.

## Assigned by hand (not in the repo)

A fresh org needs these redone:

| User | What | Why |
|---|---|---|
| POC Agent (`poc.agent.e68b5eeb6b@example.com`, `005ak00000oV1FxAAK`, Einstein Agent User profile) | User created; licence AgentforceServiceAgentUserPsl; permission sets AgentforceServiceAgentUser, POC_Case_Agent_Access, POC_Knowledge_Agent_Access | Running user for the POC agents. Publishing fails with a 401 without AgentforceServiceAgentUser. |
| Lal (`slalmohemed.c437bd0a8ab7@agentforce.com`) | POC_Case_Agent_Access | So Lal could run the duplicate-key test. Lal already had AgentPlatformBuilder for publishing. |

## Next steps

1. **Phase 2: the Flow** that reserves a `POC_Submission_Log__c` row and creates the Case. Add the Flow's
   access (`<flowAccesses>`) to `POC_Case_Agent_Access` in that phase.
2. Decide after Phase 6 whether `POC_Submission_Log__c` gets a tab.
3. Older, still open: the UC Assist tests T1–T8, the sender address, and the PR from `develop` to `main`.

## Things the next session should know

- Submission_Id__c and Status__c don't appear in the permission sets' field permissions because both are
  required fields, and Salesforce always grants access to required fields.
- Lal's user couldn't see the log fields until POC_Case_Agent_Access was assigned: System Administrator has
  no field access to new custom fields in this org.

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
