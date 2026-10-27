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
**Status:** waiting — Deploy enableNetworksEnabled=true to lal-devedition — awaiting approval before execution

**Done this session**
- Added Salesforce project structure to repo (API 68.0)
- Validated deployment: 1 component, 9 local tests passed

**Open items**
- Approve and execute enableNetworksEnabled=true deployment
- Verify setting change in org post-deployment
- Build role, UC Portal site, portal profile
- Create users Maria and Ken
- Configure Case picklist values
- Set up queue and routing
- Create agent user

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0 (org's latest version)

**Blockers**
- Requires manual approval via Approve button (production org)

**Next**
- Click Approve button to execute deployment
- Verify enableNetworksEnabled=true applied in org
- Commit Salesforce project structure to repo
- Begin step 2 build tasks

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
This deploys one setting, `enableNetworksEnabled=true`, to `lal-devedition`. That turns on Digital Experiences, which you already confirmed and which can't be undone. The same change passed a check-only validation a moment ago: 1 component, and all 9 existing local tests passed. The org counts as a production org, so you need to approve this exact command with the Approve button before it runs.

So far this run I've added a Salesforce project structure to the repo locally, pinned to API 68.0, the org's latest version. None of it is committed yet. Once you approve, I'll check that the setting really changed in the org, then build the rest of step 2: the role, the UC Portal site, the portal profile, Maria and Ken, the Case picklist values, the queue and routing, and the agent user.
<!-- orchestrate:session-state:end -->
