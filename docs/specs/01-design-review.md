## Purpose

This reviews the "Agentforce Password Reset with Identity Verification" build spec (27 Oct 2026) before we build. It checks two things: is the spec complete enough to implement, and is the target org ready. It also lists the decisions needed to lock the design. Constraint from the delivery lead: **every agent artifact is built in Agent Script (the new script-based agent authoring)**, not the classic Builder topic/action configuration.

Status: **DRAFT, design not yet locked.**

## Verdict

The architecture (option B: two subagents, a shared `IsVerified` gate, and a Flow that checks again on the server) is sound. We keep it.

The spec is **not complete enough to build as written**. There are 6 org prerequisites it assumes but this org doesn't have, 9 security or logic gaps in the sample code and Flow, 3 contradictions between the user stories and the design, and 4 points that only apply in the classic Builder and need restating for Agent Script.

## What the org has today (lal-devedition, verified live)

| Item | Spec assumes | Org today | Impact |
|------|--------------|-----------|--------|
| Agentforce agent "UC Assist" | Exists | **No agent** (0 BotDefinition, 0 authoring bundles); Bot settings `enableBots=false` | We create it in Agent Script |
| Einstein generative AI | On | On (`enableEinsteinGptPlatform=true`) | OK |
| Einstein Agent user | Exists | **None yet**; 201 Einstein Agent licences available | We create one dedicated agent user |
| Experience Cloud site | Exists | **Digital Experiences not enabled** (`enableNetworksEnabled=false`) | Blocker for real portal users. Enabling it **cannot be undone** |
| Portal users | 2 test customers | 0 Contacts, 0 portal users; 5 licences each for Customer Community / Login / Plus | Must create |
| Role on account owner | Implied | Both admin users have **no role** | A customer user can't be created unless the account owner has a role |
| Org-wide email address | Verified | **None** | Must create and verify (verification is a click in an email) |
| Single email limit | Not mentioned | **15 per day** (Developer Edition, from `/limits`) | Each code is one email, so T1–T8 use about 10. Budget test runs |
| Case Reason "Password Reset" | Exists | **Missing** (only 7 default values) | Add picklist value |
| Case Origin "Chat" | Exists | **Missing** (Web, Phone, Email) | Add picklist value |
| "Password Support" queue + Omni routing | Exists | **No queues**; Omni service channel `sfdc_livemessage` exists | Must build |
| Messaging for In-App and Web | Optional | **No messaging channel** | Escalation can't be tested end to end without it |
| Existing verification and reset Flows | "UC's existing" | `SvcCopilotTmpl.SendVerificationCode`, `VerifyCode`, `ResetPassword` are **Salesforce template placeholders**. `ResetPassword` describes itself as a placeholder that must be reconfigured | Don't reuse (see gap S1) |
| Contact sharing default | Not stated | Controlled by Parent; Account sharing default is Edit | `with sharing` Apex is fine once the agent user can read Accounts |
| Repository | n/a | `slalmohemed-git/AgentForce-Demo` is **empty** (no branches) | `develop` must be created from an initial commit |

## Security and logic gaps in the spec

| # | Gap | Why it matters | Proposed fix |
|---|-----|----------------|--------------|
| S1 | The template `VerifyCode` flow compares a code passed **into** it, so the real code would sit in agent memory | The model could see or echo the code | Use the spec's Apex hash design; don't reuse the template flows |
| S2 | No limit on **sending** codes. A lockout applies to one code, but a new code resets the count | Unlimited 3-guess rounds lets someone brute-force codes, and the customer's inbox can be flooded | Max 3 codes per Contact per hour; a new code expires the earlier Sent codes |
| S3 | `Session_Id__c` is defined but never written or checked | A code verified in **another** chat within 15 minutes would unlock a reset here | Write the messaging session id on send; Flow matches on session |
| S4 | A Verified code stays usable for 15 minutes after a reset | Replay: a second reset in the same window | Add status **Consumed**; Flow sets it after a successful reset |
| S5 | "Expired" status is never set | The audit trail (US-6) is wrong | Set Expired lazily on check, plus an optional nightly cleanup |
| S6 | Email lookup uses `LIMIT 1` with no order | Duplicate emails pick an arbitrary Contact | Match only Contacts that have an **active portal user**; more than one match is handled as not found |
| S7 | `Math.abs(Crypto.getRandomInteger())` overflows on Integer.MIN_VALUE and has a slight modulo bias | Possible negative code; uneven distribution | Draw random bytes and reject values outside the range |
| S8 | Email is sent from the default sender, not the org-wide address | Deliverability, and "from" isn't UC | `setOrgWideEmailAddressId` from Custom Metadata (no hard-coded Ids) |
| S9 | `System.resetPassword` runs as the Einstein Agent user | That user may not be allowed to reset external users' passwords | Spike in step 2: prove it works; if not, run the reset through a tightly scoped system-context path |

## Contradictions between stories and design

| # | Conflict | Proposed resolution |
|---|----------|---------------------|
| C1 | US-6 says **every attempt** creates a Case, but the Flow ends at NOT_VERIFIED with no Case, and lockouts create none | Create a Case on every outcome: SUCCESS (Closed), NOT_VERIFIED, NO_ACTIVE_USER, ERROR, LOCKED (New) |
| C2 | US-5 says 3 failed codes escalate "with the case attached", but no Case exists on that path | A lockout logs a Case (from C1) before escalation |
| C3 | The message says the "reset link expires in 24 hours", but link lifetime is an org/site setting | Read it from config or drop the duration from the message |

## Restating the spec for Agent Script

| Spec (classic Builder) | Agent Script equivalent |
|------------------------|-------------------------|
| Action "Filter / Conditions: IsVerified = true" | `available when @variables.IsVerified == True` on the reset action. The action doesn't exist for the planner until then |
| "Not user-editable" variables | Mutable variables written **only** by `set ... = @outputs...` after an action. Never by `with x = ...` from slot-filled user input |
| "Require user confirmation" on the action | A deterministic confirm step in the subagent's reasoning before calling the reset. The exact keyword will be checked against `sf agent validate authoring-bundle`, not taken from the spec's from-memory sketch |
| Session id for S3 | Linked/context variable for the messaging session. To be verified with the validator; fallback is the conversation id passed as an action input |

All Agent Script is validated with `sf agent validate authoring-bundle` and tested with `sf agent preview` / `sf agent test` before publishing. The spec's sketch is treated as illustrative only.

## Decisions needed to lock the design

1. **Experience Cloud.** Enable Digital Experiences (permanent) and build a minimal site with 2 portal users, or test the reset another way.
2. **Escalation scope.** Full Messaging for Web + Omni queue, or queue + Case now with the live handoff later.
3. **Hardening.** Which of S2–S5 and C1 to adopt beyond the spec.
4. **Test inboxes.** Which email addresses Maria and Ken use. They must be real inboxes you can open.

## Proposed repository layout (no Jira, so the specs live with the code)

```
docs/specs/00-source/Agentforce-Password-Reset-Build-Spec.pdf   (original, unchanged)
docs/specs/01-design-review.md                                  (this document)
docs/specs/02-final-spec.md                                     (locked spec v1.0: stories, AC, tests, decisions)
docs/adr/ADR-001-separate-verification-and-reset-subagents.md
docs/adr/ADR-002-agent-script-only.md
force-app/main/default/aiAuthoringBundles/UC_Assist/...         (Agent Script)
force-app/main/default/{objects,classes,flows,permissionsets,...}
tasks/todo.md, tasks/lessons.md
```

Branching: `main` gets an initial README commit (the repo is empty). `develop` is created from it, all work commits go to `develop`, and a PR runs `develop` → `main`.
