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
**Status:** blocked — Build files lost again; 8/43 components missing from working folder. Rebuild needed before deploy can proceed.

**Done this session**
- Identified root cause: uncommitted changes in git repo weren't persisted between sessions
- Catalogued what survived in work/src: 35 of 43 components intact
- Catalogued what's missing: 5 test classes, test factory, SUB_Reset_Portal_Password Flow, 2 permission sets, permission set group, UC Assist agent script

**Open items**
- Rebuild 8 missing components in work/src (test classes, test factory, Flow, permission sets, permission set group, agent script)
- Run check-only validation against rebuilt work/src
- Approve deploy command pointing at work/src/force-app to lal-devedition
- Verify all 43 components created in org post-deploy
- Set up test data: user role, Maria & Ken users, org-wide sender, agent user with permission group
- Publish UC Portal site
- Publish and activate UC Assist agent
- Commit and push validated build to develop branch

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0
- Routing model: MOST_AVAILABLE; capacityType INHERITED, isAttributeBased false
- Disable sendWelcomeEmail before deploy
- Rebuild missing components in work/src (non-git folder) to persist between sessions
- Push to develop immediately after validation, before deploy, to prevent file loss

**Blockers**
- 8 of 43 components missing from work/src; deploy cannot proceed until rebuilt and re-validated

**Next**
- Rebuild missing test classes, test factory, SUB_Reset_Portal_Password Flow, permission sets, permission set group, and UC Assist agent script in work/src
- Run check-only validation on complete 43-component set
- Await Approve click on new deploy command pointing at work/src/force-app

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
I didn't run the deploy, and nothing changed in `lal-devedition`. The approval check stopped the command before it started because the folder it deploys, `work/repo/force-app`, no longer exists.

**What happened:** last turn the full validated build was back in `work/repo`, which is a git copy of the repo. Its changes were never committed. Uncommitted changes inside a repository aren't kept from one run to the next, so the whole folder was gone again when this run started. I searched the whole machine and the files aren't anywhere else.

**What survived:** the partial rebuild in `work/src`, which isn't a git copy, came through intact. Compared with the 43 components that passed validation (`0Afak00000q1VlNCAU`):

- **Present (complete):** the Verification Code object and its 10 fields, the UC Assist Setting type with its 6 fields and Default record, the 5 Apex action and service classes, the role, the portal profile, the queue, the routing config, the two Case value sets, the Communities setting and the UC Portal site file.
- **Missing:**
  - the code inside the 5 test classes and the test data factory (only their small companion files are there)
  - the `SUB_Reset_Portal_Password`

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
