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
**Status:** waiting — Deploy blocked by safety check loop; new Approve card waiting. Fresh permissions backup confirms no UC Portal profile/sets exist yet.

**Done this session**
- Confirmed deploy hasn't executed; lal-devedition unchanged

**Open items**
- Approve new Approve card to execute 43-component deploy to lal-devedition
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
- Deploy from develop branch files (commit 0eb8642 + later context-only commits)

**Blockers**
- Safety check requests new permissions backup before each deploy attempt, consuming approval; if third approval also triggers backup request, escalate as bug to Orchestrate team

**Next**
- Approve the waiting Approve card to execute 43-component deploy
- If safety check asks for third backup, report loop as bug; otherwise proceed to verify 43 components in org post-deploy

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
Nothing was deployed. `lal-devedition` hasn't changed, and the build on `develop` is untouched.

**Why it keeps stopping:** this is the same thing that happened last time.
1. My first run of your approved command was stopped by the safety check before it started. Each time, the check asks for a new permissions backup in a new dated folder, even though earlier backups exist.
2. That blocked attempt still used up your approval.
3. I took the backup it asked for. It's read-only and confirms the UC Portal Customer profile and both permission sets don't exist in the org yet, so the deploy can only add permissions.
4. When I re-ran the same command, it needed a fresh approval because the first one was gone.

There's a new Approve card waiting for the same command. It deploys the 43 UC Assist components from `develop` to `lal-devedition` and runs the 5 test classes. The backup the check asked for is now in place.

If you approve and the check asks for a new backup a third time, the loop is in the safety check itself and retrying won't fix it. I'll tell you that rather than go round again, and you could report it to the Orchestrate team as a bug in the deploy safety check.
<!-- orchestrate:session-state:end -->
