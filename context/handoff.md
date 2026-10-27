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
**Status:** on track — Build committed to develop; 43 components ready for deploy to lal-devedition. Next: deploy & verify in org.

**Done this session**
- Rebuilt all 8 missing components in work/src
- Committed complete 43-component set to develop branch (commit 0eb8642)
- Pushed to GitHub; verified all 14 metadata folders present
- Confirmed 23/23 tests passing in validated build

**Open items**
- Deploy 43 components to lal-devedition from develop branch
- Verify all 43 components created in org post-deploy
- Set up test data: user role, Maria & Ken users, org-wide sender, agent user with permission group
- Publish UC Portal site
- Publish and activate UC Assist agent
- Run tests T1–T8 and report results
- Open PR from develop to main with final state

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0
- Routing model: MOST_AVAILABLE; capacityType INHERITED, isAttributeBased false
- Disable sendWelcomeEmail before deploy
- Commit to develop immediately after validation to prevent file loss
- Deploy from develop branch files (not local work folder)

**Blockers**
- None

**Next**
- Deploy 43 components to lal-devedition from develop branch (will receive Approve card)
- Verify each of 43 components exists in org post-deploy
- Set up test data: role, Maria & Ken users, org-wide sender, agent user + permission group
- Publish UC Portal site and UC Assist agent
- Run tests T1–T8

**Checked live on 2026-10-27:** the repository
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
• Code committed: yes (branch develop)
• Pushed to GitHub: yes
• Validated (sf deploy validate): NOT verified
• Deployed to org: no deploy in this session run — if an earlier run deployed, verify in the target org
Next: open/refresh the PR → review → merge to main → run a Deploy session to ship. This work is NOT live yet.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

I've pushed the build to `develop`, so it can't be lost between runs any more. This was step 1 of the plan.

**What was pushed:**
- One commit, `0eb8642`, on `develop` in `slalmohemed-git/AgentForce-Demo`.
- I checked GitHub afterwards: the branch now points at `0eb8642`, and all 14 metadata folders are in `force-app/main/default`.
- It holds 55 build files plus the project files. That's the full set of 43 components that passed check-only validation `0Afak00000q1VlNCAU`, with 23 of 23 tests passing.
- Before committing, I updated my local copy with 13 newer commits from GitHub `develop`. They only changed the engagement context files, so nothing on the branch was overwritten.
- Nothing went to `main`.

**Status:**
- Commi

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
