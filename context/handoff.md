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
**Status:** waiting — Step 2 build locally complete; awaiting approval to create Password Support routing config in lal-devedition

**Done this session**
- Built role, portal profile, Case Origin/Reason picklist values locally
- Built Password Support queue and routing config locally
- Identified role description exceeds 80 chars — will fix before deploy
- Validation found correct metadata shape needed from live org

**Open items**
- Approve or decline: create QueueRoutingConfig record in lal-devedition to retrieve correct metadata shape
- Fix role description to ≤80 characters
- Commit Salesforce project structure to develop branch
- Create UC Portal site (ucportal)
- Create portal profile
- Create users Maria and Ken
- Create agent user

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0 (org's latest version)
- Retrieve live QueueRoutingConfig metadata shape from org before final deploy

**Blockers**
- Awaiting approval to create QueueRoutingConfig record in production org lal-devedition

**Next**
- Approve or decline the QueueRoutingConfig creation command
- If approved: retrieve metadata, fix role description, commit all step 2 work to develop
- If declined: manually document correct routing metadata shape and proceed with local fixes

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
This command creates one Omni-Channel routing configuration record, "Password Support Routing" (most-available routing, priority 1, capacity weight 1, 60-second push timeout), in `lal-devedition`. The metadata deploy rejected every routing-model value it was given, so I want one real instance in the org to retrieve and copy the correct metadata shape from. It still needs your Approve, because `lal-devedition` is treated as a production org.

Where step 2 stands: the role, portal profile, Case Origin "Chat" and Reason "Password Reset" values, routing config and queue are written locally on `develop`. Nothing is deployed or committed yet. The check-only validation also found that the role description is over 80 characters, and I'll fix that before the real deploy.

[Asked the person]
This session wants to change records in the PRODUCTION org lal-devedition and stopped for your approval. Approve it to run exactly the command below once, or decline to stop it. [DATA CHANGE]
   - Approve — Run `cd /tmp/build-98d70d6d-c047-4d6d-aaf6-068be5a06345/work/repo && sf sobject describe -s QueueRoutingConfig -o lal-devedition --json 2>/dev/null | jq -c '{c:.result.createable, req:[.result.fields[

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
