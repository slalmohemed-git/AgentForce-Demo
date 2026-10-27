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
**Status:** on track — enableNetworksEnabled=true deployed & verified live. Project structure ready locally. Step 2 build tasks next.

**Done this session**
- Executed approved deployment to lal-devedition (deploy ID 0Afak00000q06KRCAY)
- Verified enableNetworksEnabled=true applied in org post-deployment
- All 9 existing local tests passed during deployment

**Open items**
- Commit Salesforce project structure to develop branch
- Build role for UC Portal
- Create UC Portal site (ucportal)
- Create portal profile
- Create users Maria and Ken
- Configure Case picklist values
- Set up Password Support queue and routing
- Create agent user

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0 (org's latest version)

**Blockers**
- None

**Next**
- Commit Salesforce project structure (sfdx-project.json, .forceignore, .gitignore, force-app/) to develop
- Build step 2 components: role, UC Portal site, portal profile, users, Case picklist, queue/routing, agent user
- Commit all step 2 work together on develop

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
━━ Build status (auto-checked from tool results — deploy = sf CLI exit, not runtime effect) ━━
• Code committed: no new commit in this session run — if an earlier run committed, check the repository
• Pushed to GitHub: nothing new pushed in this session run — if an earlier run pushed, check the repository
• Validated (sf deploy validate): yes
• Deployed to org: yes — lal-devedition
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

I ran the approved command once, unchanged, and Digital Experiences is now on in `lal-devedition`. I pulled the setting back from the org afterwards and it reads `enableNetworksEnabled = true`.

**What the deploy did** (deploy ID `0Afak00000q06KRCAY`):
- It finished as Succeeded at 18:19:46 UTC.
- It deployed 1 of 1 components (`CommunitiesSettings` / `Communities`), with no component errors.
- It ran all 9 of the org's existing local tests, and all 9 passed (1.3 s).
- Changing the setting didn't touch any other part of the org.

**Not yet done:**
- The Salesforce project structure (`sfdx-project.json` at API 68.0, `.forceignore`, `.gitignore`, `force-app/`) is still only in the local working copy of `develop`. It isn't committed or pushed yet.
- None of t

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
