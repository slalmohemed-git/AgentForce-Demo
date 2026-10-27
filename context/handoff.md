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
**Status:** on track — Step 2 validated (43 components, 23 tests pass); ready to deploy. Site exists, agent script compiles. Awaiting approval to deploy.

**Done this session**
- Validated all 43 components and 23 tests against lal-devedition (check-only)
- Confirmed agent user can reset customer portal password
- Confirmed org email limit (15/day) applies during tests
- UC Portal site created and compiles without errors

**Open items**
- Deploy validated step 2 build to lal-devedition
- Set up test data: assign role to user, create Maria and Ken, add org-wide sender address, create agent user with permissions
- Publish UC Portal site (set to Live)
- Publish UC Assist agent
- Commit step 2 work to develop branch
- Push to GitHub
- Add Apex class access (<classAccesses>) to permission set for non-admin access

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0 (org's latest version)
- Routing model metadata format: MOST_AVAILABLE; include capacityType INHERITED and isAttributeBased false

**Blockers**
- Apex class access not wired — non-admins and Agentforce agents cannot use new Apex entry point until classAccesses added to persona permission set

**Next**
- Approve deploy to lal-devedition
- Create test data (role, Maria, Ken, sender address, agent user)
- Publish site and agent
- Commit and push to develop

**Checked live on 2026-10-27:** the web
### Last session — 2026-10-27
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
• Deployed to org: NO — not deployed to any org
• Access wiring (new actions/tabs/pages/apps/permissions/flows/credentials): ⚠ NOT wired — Apex class access (<classAccesses>) for the new Apex entry point / action. Non-admins (and Agentforce agent actions) can't use these. Add the grant on the persona permset or ask the user.
Next: open/refresh the PR → review → merge to main → run a Deploy session to ship. This work is NOT live yet.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

An Approve / Decline card is now waiting for you. The command on it changes nothing: it only reads the help text for the site- and agent-publish commands and checks one local file for the site's welcome-email setting. The safety check flagged it because the text contains the word "publish".

**Nothing is deployed and nothing is pushed yet.**

**Validated, not yet dep

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
