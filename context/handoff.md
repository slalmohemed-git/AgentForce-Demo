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
**Status:** waiting — Build validated & ready to deploy; awaiting Approve click to proceed with org setup

**Done this session**
- Confirmed build files recovered; full validated copy in working folder
- Backed up UC Portal Customer profile and permission sets before deploy
- 43 components ready: 23 tests passing, 91–100% coverage

**Open items**
- Click Approve to deploy 43 components to lal-devedition
- Verify components created in org post-deploy
- Set up test data: user role, Maria & Ken users, org-wide sender, agent user with permission group
- Publish UC Portal site
- Publish and activate UC Assist agent
- Commit and push validated build to develop branch

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0
- Routing model: MOST_AVAILABLE; capacityType INHERITED, isAttributeBased false
- Disable sendWelcomeEmail before deploy
- Maintain build files in saved working folder to persist between runs
- Push to develop after validation and org setup complete

**Blockers**
- Awaiting Approve click to deploy to lal-devedition (production org requires explicit approval)

**Next**
- Click Approve to deploy 43 components
- Verify all components created in org
- Create test data and configure sender address
- Publish site and activate agent
- Commit and push to develop

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
The platform is holding the deploy for your Approve click. Your message in chat can't stand in for it, because `lal-devedition` counts as a production org. The command deploys the full UC Assist build, 43 components with the 5 test classes. That's the same set that just passed a fresh check-only validation (`0Afak00000q1VlNCAU`, 23 of 23 tests, coverage 91–100%). The repo comes after the org, as you asked.

**Done this turn:**
- **The build files weren't lost after all.** The full validated copy came back into the working folder: the Apex classes, test classes, Flow, permission sets, permission set group and UC Assist agent script. I've used that copy and set aside the partial rebuild from last turn.
- **I backed up permissions before the deploy.** The UC Portal Customer profile and both permission sets don't exist in the org yet, so this deploy can only add permissions, never remove them.

**After you click Approve:**
1. I'll check in the org that the components were created.
2. I'll set up the test data: your user's role, Maria and Ken (Ken switched off), the org-wide sender address and the agent user with its permission group. The sender address sends you a verification email to

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
