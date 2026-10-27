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
**Status:** on track — Step 2 build validated & ready to deploy; welcome email disabled; awaiting approval

**Done this session**
- Disabled sendWelcomeEmail in site file (line 53: false)
- Re-validated all 43 components and 23 tests after site file change
- Backed up org permissions state before deploy
- Prepared deploy package for lal-devedition (validation 0Afak00000q1MgTCAU, 91–100% coverage)

**Open items**
- Approve deploy to lal-devedition
- Confirm components created in org after deploy
- Set up test data: assign role to user, create Maria and Ken, add org-wide sender address, create agent user with permissions
- Publish UC Portal site (sf community publish --name --target-org lal-devedition)
- Publish UC Assist agent (sf agent publish authoring-bundle --api-name --target-org lal-devedition)
- Activate UC Assist agent (sf agent activate --api-name --version --target-org lal-devedition)
- Commit step 2 work to develop branch and push to GitHub
- Add Apex class access (classAccesses) to permission set for non-admin access

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0 (org's latest version)
- Routing model metadata format: MOST_AVAILABLE; capacityType INHERITED, isAttributeBased false
- Disable sendWelcomeEmail on UC Portal site before deploy to preserve email quota

**Blockers**
- Apex class access not wired — non-admins and Agentforce agents cannot use new Apex entry point until classAccesses added to persona permission set

**Next**
- Approve deploy to lal-devedition
- Confirm 43 components and permissions created in org
- Create test data (role, Maria, Ken, sender address, agent user)
- Publish site and agent, then activate agent
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
An Approve card is now waiting for you. It deploys the full UC Assist build to `lal-devedition`: 43 components and 5 test classes, the same set that just passed a check-only validation (`0Afak00000q1MgTCAU`, 23 of 23 tests, coverage 91–100%).

**What changed this turn:**
- **Welcome email turned off.** The UC Portal site file now has `sendWelcomeEmail` set to `false`, so creating Maria and Ken won't use up the 15 emails a day the verification codes need.
- **Permissions backed up first.** I checked the org before this deploy. The UC Portal Customer profile and the two permission sets don't exist yet, so the deploy can only add permissions, never remove them. I saved that check as a backup.

**Still to do after you approve:**
1. Confirm in the org that the components were created.
2. Set up the test data: your role, Maria and Ken, the org-wide sender address, and the agent user.
3. Publish the site, then publish and activate UC Assist.
4. Commit and push to `develop`.

Nothing has been committed or pushed yet.

Sources: checked live: `lal-devedition` (check-only validation, and queries showing the profile and permission sets don't exist yet) · not checked: nothing else
<!-- orchestrate:session-state:end -->
