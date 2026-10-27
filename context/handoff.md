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
**Status:** on track — QueueRoutingConfig created in prod org; retrieved metadata format; ready to update local files and validate step 2

**Done this session**
- Approved and executed QueueRoutingConfig creation command in lal-devedition
- Retrieved live record metadata format (routing model MOST_AVAILABLE, capacityType INHERITED, isAttributeBased false)
- Identified metadata format mismatch (MostAvailable vs MOST_AVAILABLE)

**Open items**
- Update local routing config file with retrieved metadata format (MOST_AVAILABLE, capacityType, isAttributeBased)
- Fix role description to ≤80 characters
- Run check-only validation on step 2 files
- Deploy step 2 to lal-devedition
- Commit step 2 work to develop branch
- Create UC Portal site (ucportal)
- Create portal profile and users (Maria, Ken, agent user)

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0 (org's latest version)
- Routing model metadata format: MOST_AVAILABLE (not MostAvailable); include capacityType INHERITED and isAttributeBased false

**Blockers**
- None

**Next**
- Copy retrieved metadata format into local routing config file
- Shorten role description to ≤80 characters
- Run check-only validation on step 2 files
- Deploy step 2 to lal-devedition
- Commit step 2 to develop branch

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
I ran the approved command once, without changing it, and it worked. The "Password Support Routing" config now exists in `lal-devedition`.

**What the command did:**
- It returned status 0 and created the record with Id `0K9ak000001zVntCAE`. There was no error message.
- I queried the record back afterwards. It has DeveloperName `Password_Support_Routing`, routing model `MostAvailable`, priority 1, capacity weight 1 and a 60-second push timeout.

**Why the earlier validation failed:** I pulled the record back as metadata into a scratch folder. In metadata the routing model has to be written `MOST_AVAILABLE`, not `MostAvailable`. The record also carries two values my local file didn't have: `capacityType` set to `INHERITED` and `isAttributeBased` set to `false`.

**Not done yet:**
- I haven't changed the local routing config file or the role description, which is still over 80 characters.
- I haven't re-validated, deployed or committed the step 2 files. They are still only in the local copy of `develop`.
- I haven't started the UC Portal site, Maria and Ken, or the agent user.

Next I'll copy the retrieved format into the local routing config, shorten the role description, and re-ru

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
