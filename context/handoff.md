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
**Status:** at risk — Step 2 build locally complete; QueueRoutingConfig creation declined—routing metadata shape unresolved, blocking validation

**Done this session**
- Received decline decision on QueueRoutingConfig creation in lal-devedition

**Open items**
- Resolve routing-model metadata shape: create record manually in Setup OR proceed without routing config in deploy
- Fix role description to ≤80 characters
- Commit Salesforce project structure to develop branch
- Create UC Portal site (ucportal)
- Create portal profile
- Create users Maria and Ken
- Create agent user

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0 (org's latest version)
- Declined: create QueueRoutingConfig record in lal-devedition for metadata retrieval

**Blockers**
- QueueRoutingConfig routing-model validation fails—correct metadata shape unknown; manual Setup creation or scope reduction needed

**Next**
- Choose path: (A) manually create Password Support Routing config in lal-devedition Setup, retrieve and apply format, OR (B) exclude routing config from step 2 deploy and build remaining items
- Fix role description length to ≤80 characters
- Commit step 2 work to develop branch
- Resume build of portal site, profiles, and users

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
I didn't run the command, and I haven't made the same change any other way. Nothing in `lal-devedition` changed in this step.

**What I proposed:** creating one Omni-Channel routing configuration record in `lal-devedition`, called "Password Support Routing". It would have used most-available routing, priority 1, capacity weight 1 and a 60-second push timeout.

**Why I proposed it:** the check-only validation of the step 2 metadata rejected every routing-model value I gave the routing config. My plan was to create one real record in the org, retrieve it, and copy its exact metadata format into the repo.

**Why it was declined:** the org counts as a production org, so a record change needs your approval, and you declined. Your reason wasn't given, but the effect is the same: nothing was created.

**Where step 2 stands now:**
- **Deployed and checked live earlier:** Digital Experiences is on in `lal-devedition`.
- **Written locally on `develop` only, not committed, pushed or deployed:**
  - the project structure (`sfdx-project.json` at API 68.0, `.forceignore`, `.gitignore`)
  - the UC account-owner role
  - the UC Portal Customer profile
  - the Case Origin "Chat" and Reason "Passwor

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
