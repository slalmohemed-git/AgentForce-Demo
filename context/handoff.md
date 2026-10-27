# Handoff — current state

> **Rewritten at the end of every session.** This file is *now*; [`gotchas.md`](gotchas.md) is *forever*.
> If this file and [`../CONTEXT.md`](../CONTEXT.md) disagree, this one is newer.

**Last updated:** 2026-10-27 · **By:** <session or person>

---

## Where things stand

> **Not yet filled in.** — Where is the work right now, in two or three sentences? Someone picking
> this up cold reads this first.

## In progress

| What | State | Where it lives | Blocked on |
|---|---|---|---|
| | | | |

## Next steps

<!-- Ordered. The top item should be the one to do next, not the most interesting one. -->

1.

## Waiting on someone else

| What | Who | Since | Chased? |
|---|---|---|---|
| | | | |

## Things the next session should know

<!-- Anything true right now that is not obvious from the code: a half-finished refactor, a
     deliberately disabled test, a workaround that needs removing, a deploy that is half-applied.
     If you leave something in a strange state, this is where you say so. -->

-

<!-- orchestrate:session-state:start -->
<!-- Written by Orchestrate at the end of each session. Edits inside this block are
     replaced next session; anything OUTSIDE it is yours and is never touched. -->
### Engagement state — 2026-10-27
**Status:** at risk — Build files lost between runs; step 2 partially rebuilt locally, awaiting rebuild completion & validation

**Done this session**
- Rebuilt project files, Communities setting, UC Portal site (welcome email off, Live status)
- Rebuilt UC Account Owner role, UC Portal Customer profile, Password Support queue
- Rebuilt Case Origin/Reason values, Verification Code object with 10 fields
- Rebuilt UC Assist Setting metadata type with 6 fields and Default record
- Rebuilt 3 Apex classes: VerificationCodeService, SendVerificationCode, CheckVerificationCode
- Identified root cause: uncommitted work didn't persist; now rebuilding in saved working folder

**Open items**
- Confirm last 2 Apex classes (RedeemVerificationToken, ResetUserPassword) were written correctly
- Rebuild test data factory and 5 test classes (23 tests, 90%+ coverage)
- Rebuild SUB_Reset_Portal_Password Flow
- Rebuild 2 permission sets and permission set group
- Rebuild UC Assist agent script
- Run check-only validation on complete step 2 build
- Approve deploy to lal-devedition
- Create test data and publish site/agent, then activate agent

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0
- Routing model: MOST_AVAILABLE; capacityType INHERITED, isAttributeBased false
- Disable sendWelcomeEmail before deploy
- Rebuild in saved working folder (not git clone) to persist between runs
- Push to develop after each validation stage to prevent loss of work

**Blockers**
- Build files were lost; step 2 partially rebuilt but incomplete — cannot deploy until full rebuild validates
- Apex class access not wired — non-admins and Agentforce agents cannot use new Apex entry point until classAccesses added to permission set

**Next**
- Reply 'continue' to resume rebuild from last 2 Apex classes
- Verify RedeemVerificationToken and ResetUserPassword files exist and are correct
- Complete rebuild: test factory, 5 test classes, Flow, 2 permission sets, agent script
- Run check-only validation (target 90%+ coverage, 23 tests passing)
- Push validated step 2 to develop branch immediately
- Await approval to deploy to lal-devedition

**Checked live on 2026-10-27:** nothing — the status above is as recorded, not re-checked
### Last session — 2026-10-27
| | |
|---|---|
| Type | BUILD |
| Outcome | COMPLETED |
| Branch | `develop` |
| Name | Demo-AgentBuild-UseCase-1 |
| Session | `98d70d6d-c047-4d6d-aaf6-068be5a06345` |
**In its own words (excerpt):**
I've paused the rebuild. Nothing was deployed, committed or pushed this turn.

**There's a problem: the build files were lost.** The local copy of the repo, which held all the uncommitted step 2 work, didn't carry over into this run. That means there's nothing to deploy right now. None of that work had reached the org: the earlier runs only did check-only validations, which leave nothing behind. The org still has only what was there before: Digital Experiences turned on, the UC Portal site (still "Under Construction") and the Password Support routing config.

**Rebuilt this turn.** I'm writing it under the saved working folder this time, not inside a git clone, so it survives between runs:
- The project files (API 68.0) and the Communities setting.
- The UC Portal site file: welcome email off, the portal profile added as a member, status set to Live.
- The UC Account Owner role, the UC Portal Customer profile and the Password Support queue.
- The Case Origin "Chat" and Reason "Password Reset" values.
- The Verification Code object with its 10 fields.
- The UC Assist Setting metadata type with its 6 fields and Default record.
- The Apex classes `VerificationCodeService`, `SendVerifi

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
