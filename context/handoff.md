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
### Engagement state — 2026-10-28
**Status:** waiting — Deploy B validated (18/18 components, 23/23 tests pass). Awaiting your approval to quick-deploy.

**Done this session**
- Validated Deploy B from develop (9ab0dcf): 18 components, 0 errors, 23 tests passed
- Confirmed UC Portal Customer profile, 5 Apex classes, both permission sets not yet in lal-devedition
- Safety check now proceeds to Approve card without requesting backup loop

**Open items**
- Approve Deploy B quick-deploy (validation ID 0Afak00000q8jBhCAI) in lal-devedition
- Verify all 18 Deploy B components created in lal-devedition post-approval
- Verify UC Portal Customer profile created in lal-devedition post-approval
- Run tests T1–T8 and confirm all pass
- Publish UC Portal site and activate UC Assist agent
- Open PR from develop to main with final state
- Escalate Deploy B safety check bug to Orchestrate team (session 98d70d6d-c047-4d6d-aaf6-068be5a06345)

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0
- Routing model: MOST_AVAILABLE; capacityType INHERITED, isAttributeBased false
- Disable sendWelcomeEmail before deploy
- Deploy from develop branch (commit 0eb8642 + context-only commits)
- Split deploy: Deploy A (done) then Deploy B (18 components, now validated)
- Deploy UC Portal Customer profile separately before Deploy B
- Use quick-deploy for validated job (ID 0Afak00000q8jBhCAI) instead of retrying safety check

**Blockers**
- Awaiting your approval to quick-deploy validated Deploy B job

**Next**
- Approve Deploy B quick-deploy in the org (validation ID 0Afak00000q8jBhCAI)
- Verify all 18 components and profile exist in lal-devedition after approval
- Run tests T1–T8 and confirm pass

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
I've validated Deploy B and prepared it. The newest Approve card is now waiting, but I can't click it for you. Approval in this org has to come from you, and I'm not able to give it on your behalf.

**Validation:** I ran a fresh check-only validation from `develop` (`9ab0dcf`, the same as GitHub). It passed as `0Afak00000q8jBhCAI`:
- 18 of 18 components, 0 errors
- 23 of 23 tests passed

I checked the org first: the UC Portal Customer profile, the 5 Apex classes and both permission sets aren't in `lal-devedition` yet.

**The waiting card:** it quick-deploys that validated job by its ID. That puts the same 18 components into the org (Apex classes, Flow, UC Portal site, UC Assist agent script, profile, both permission sets and the group). It doesn't send the files again or re-run the tests.

This time the safety check went straight to the Approve card and didn't ask for a permissions backup, so your approval shouldn't be used up the way it was before. A validated job can only be quick-deployed for a limited time (usually 10 days), so it doesn't need approving right away. Once you approve, I'll check each component exists in the org.

Sources: checked live: GitHub `develop`, `lal-deve

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
