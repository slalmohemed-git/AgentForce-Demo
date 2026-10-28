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
**Status:** on track — Deploy A done (25/25 components in lal-devedition). Deploy B waiting for approval (18 components, dry run passed).

**Done this session**
- Deploy A executed: 25 components deployed to lal-devedition (0Afak00000q8PXyCAM)
- Verified all 25 Deploy A components created in org (Verification Code object, UC Assist Setting, role, queue, routing, Case values, Communities)
- Deploy B dry run passed: 18 components, 23 tests, 0 errors (0Afak00000q8VtVCAU)
- Permissions backup taken before Deploy B approval step

**Open items**
- Approve Deploy B Approve card to execute 18-component deploy (Apex, Flow, site, agent, profile, permission sets, tests)
- Verify Deploy B components created in lal-devedition post-execution
- Run tests T1–T8 and confirm all pass
- Publish UC Portal site
- Publish and activate UC Assist agent
- Set up test data
- Open PR from develop to main with final state

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0
- Routing model: MOST_AVAILABLE; capacityType INHERITED, isAttributeBased false
- Disable sendWelcomeEmail before deploy
- Deploy from develop branch files (commit 0eb8642 + later context-only commits)
- Split deploy into two: Deploy A (objects, settings, role, queue, routing, Case values, Communities) then Deploy B (permissions, Apex, Flow, site, agent, tests)

**Blockers**
- None

**Next**
- Approve Deploy B Approve card to execute 18-component deploy
- Verify 18 Deploy B components created in lal-devedition
- Confirm all 5 test classes pass
- Publish UC Portal site and activate UC Assist agent
- Set up test data for validation

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
━━ Build status (auto-checked from tool results — deploy = sf CLI exit, not runtime effect) ━━
• Code committed: no new commit in this session run — if an earlier run committed, check the repository
• Pushed to GitHub: nothing new pushed in this session run — if an earlier run pushed, check the repository
• Validated (sf deploy validate): yes
• Deployed to org: yes — lal-devedition · NOT read back from the org: the deploy's result listed no components (run it with --json, and not --async, so Orchestrate can check the org)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Deploy A is done: all 25 components are now in `lal-devedition`. Deploy B, the last 18 components, is waiting for your Approve click.

**Deploy A result:** deploy `0Afak00000q8PXyCAM` succeeded, with 25 of 25 components deployed and 0 errors. I checked the org afterwards and everything is there:
- the Verification Code object with all 10 fields
- the UC Assist Setting type and its Default record
- the UC Account Owner role
- the Password Support queue and its routing config
- the "Chat" Case Origin value and the "Password Reset" Case Reason value
- the Communities setting

**Deploy B (the waiting Approve card):** it

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
