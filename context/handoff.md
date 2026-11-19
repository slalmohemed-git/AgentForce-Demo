# Handoff — current state

> **Rewritten at the end of every session.** This file is *now*; [`gotchas.md`](gotchas.md) is *forever*.
> If this file and [`../CONTEXT.md`](../CONTEXT.md) disagree, this one is newer.

**Last updated:** 2026-11-19 · **By:** Orchestrate build session (POC-Antioch-Build-P2)

---

## Where things stand

**POC Phase 1 (schema and access)** is done: `POC_Submission_Log__c` (7 fields, Private, unique case-sensitive
`Submission_Id__c`), Case Origin **Agent**, Case Types General Inquiry / Access Request / Technical Issue, and the
permission sets `POC_Case_Agent_Access`, `POC_Knowledge_Agent_Access` and `POC_Submission_Log_Audit`.

**POC Phase 2 (the Flow)** is done and deployed to `lal-devedition` (deploy `0Afak00000tUTHrCAO`, 3 of 3; Flow Tests
in a second deploy, 3 of 3). Read back on 2026-11-19:

- Flow `POC_Create_Case` (label "SUB - POC Create Case"), autolaunched, API 68, **v1 Active**, run mode
  **System Context Without Sharing**. Inputs Mode, SubmissionId, Subject, Description, Category,
  TroubleshootingNotes, KnowledgeRefs. Outputs ResultCode, Message, CaseId, CaseNumber.
- The Flow, not the caller, sets: Requester = running user, Channel = Agent Assisted, Case Origin = Agent,
  Type = Category (same-name map; any other Category is VALIDATION), Priority = **Medium**. The Case
  Description is "Description / Troubleshooting Notes / Knowledge References" under labelled headings.
- Custom permission `POC_Create_Case_Allowed`, granted only by `POC_Case_Agent_Access`, together with
  `flowAccesses` for the Flow. The other two permission sets have neither.
- Flow Tests (3, all pass with `sf flow run test -n POC_Create_Case`): missing Subject, bad Category, CHECK unknown ID.

### Run mode and why

System Context Without Sharing, because the log is Private and the agent user must find logs to detect duplicates.
The Flow makes up for running in system mode by: checking `$Permission.POC_Create_Case_Allowed` first (both modes),
setting Requester from `$User.Id` itself, scoping CHECK to the running user's logs, and, in CREATE, returning
VALIDATION ("this submission ID is already in use") with no Case number when the ID belongs to another user.

### Result codes, as tested (REST invocable call as Lal, 2026-11-19)

| Test | Result | Agent Cases / logs after |
|---|---|---|
| Baseline | | 0 / 0 |
| CREATE valid (POC-P2-T01) | SUCCESS, Case 00001028, log Created and linked | 1 / 1 |
| CREATE missing Subject | VALIDATION "Subject is required." | 1 / 1 |
| CREATE Category "Billing" | VALIDATION | 1 / 1 |
| CREATE POC-P2-T01 again | DUPLICATE, 00001028 | 1 / 1 |
| CREATE POC-P2-T05A, then T05B | SUCCESS 00001029, SUCCESS 00001030 | 3 / 3 |
| CHECK T01 / unknown ID / "poc-p2-t01" / Mode "DELETE" | DUPLICATE / NOT_FOUND / NOT_FOUND / VALIDATION | 3 / 3 |
| CREATE with forced Case failure (POC-P2-T08) | ERROR, no Case, log saved as **Failed** | 3 / 4 |
| CHECK T08 | NOT_FOUND, "failed, retry is safe" | 3 / 4 |
| CREATE T08 retry | SUCCESS 00001031, the Failed row was reused (now Created) | 4 / 4 |
| CREATE and CHECK with POC_Case_Agent_Access removed from Lal | AUTHORIZATION, nothing written | 4 / 4 |

### Transaction finding (tested, not assumed)

When the Case create fails inside the Flow's handled fault path, the org **keeps** the log row: it was saved
with Status Failed, Result_Code ERROR and a safe Detail (SUB-000006). Only the failed Case insert is lost. So
ERROR means "no Case, retry is safe", and CHECK on that ID says the same. Forced with a temporary Case
validation rule, `POC_Force_Fail_Test` (Subject = "POC-FORCE-FAIL"), which is now **inactive** in the org
and not in the repo.

### What `$User` resolves to

Not verified yet. Every test ran as Lal, so Requester = Lal. When the agent calls the Flow in Phase 3, check
whether Requester is the POC Agent user or the employee. If it's always the agent user, CHECK's
per-requester scoping protects nothing between employees, and "requester" means the agent.

### Not verified

- The race path (a log insert that fails with DUPLICATE_VALUE because another call reserved the ID first).
  There's no way to force it without two calls at the same moment.
- INDETERMINATE (a Reserved row left behind, or the log update failing after the Case exists): the branches
  are built but no test reached them.
- The **agent user** running the Flow. The tests only showed that a user without the custom permission is
  refused, by the Flow, not by `flowAccesses`.
- Known limit: if two calls arrive at the same moment and both reuse the same **Failed** row, both could create
  a Case. Flow can't lock the row.

## Assigned by hand (not in the repo)

| User | What | Why |
|---|---|---|
| POC Agent (`poc.agent.e68b5eeb6b@example.com`, `005ak00000oV1FxAAK`, Einstein Agent User profile) | Licence AgentforceServiceAgentUserPsl; permission sets AgentforceServiceAgentUser, POC_Case_Agent_Access, POC_Knowledge_Agent_Access | Running user for the POC agents |
| Lal (`slalmohemed.c437bd0a8ab7@agentforce.com`) | POC_Case_Agent_Access (reassigned 2026-11-19 after the AUTHORIZATION test, now `0Paak00001Fy0aMCAR`) | Tests run as Lal |

## Test data left in the org

Cases 00001028–00001031 (Origin Agent) and logs SUB-000003–SUB-000006. Also the inactive validation rule
`Case.POC_Force_Fail_Test`. Keep them, or delete them with confirmation.

## Next steps

1. **Phase 3:** the headless Case Creation Agent, with `POC_Create_Case` as its only action. Check what
   `$User` is when the agent runs it.
2. Decide after Phase 6 whether `POC_Submission_Log__c` gets a tab.
3. Older, still open: the UC Assist tests T1–T8, the sender address, and the PR from `develop` to `main`.

## Things the next session should know

- `flowAccesses` doesn't stop a System Administrator from running the Flow, and the Einstein Agent User
  profile has Run Flows. The custom permission check inside the Flow is the real gate.
- Submission_Id__c and Status__c don't appear in the permission sets' field permissions because both are
  required fields.

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
