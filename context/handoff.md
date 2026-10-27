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
**Status:** blocked — Step 2 build locally complete; awaiting approval to create QueueRoutingConfig record in production org

**Done this session**
- None

**Open items**
- Approve QueueRoutingConfig creation command in lal-devedition (production org approval required)
- Retrieve routing-model metadata format from created record
- Fix role description to ≤80 characters
- Commit step 2 work to develop branch
- Create UC Portal site (ucportal)
- Create portal profile
- Create users Maria and Ken
- Create agent user

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0 (org's latest version)
- Declined: create QueueRoutingConfig record without explicit approval (production org)

**Blockers**
- QueueRoutingConfig creation requires explicit approval click on command (lal-devedition is production org)

**Next**
- Approve the QueueRoutingConfig creation command for Password Support Routing in lal-devedition
- Retrieve exact routing-model metadata format from created record
- Apply metadata format to routing config and fix role description
- Validate and commit step 2 to develop branch
- Resume portal site, profile, and user creation

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
I couldn't run this yet. `lal-devedition` is treated as a production org, so this record change needs you to click the Approve button on the command itself; a typed "yes" in chat doesn't count. The command creates one Omni-Channel routing configuration record, "Password Support Routing" (most-available routing, priority 1, capacity weight 1, 60-second push timeout). Once it exists, I'll retrieve its exact metadata format, fix the routing config and the role description, then validate and deploy the rest of step 2.

Nothing has changed in the org this turn. The step 2 files are still only in the local copy of `develop`.
<!-- orchestrate:session-state:end -->
