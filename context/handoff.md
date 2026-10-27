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
**Status:** on track — Step 2 validated & ready; welcome email setting flagged—turn off before deploy to preserve email quota

**Done this session**
- Checked site file: sendWelcomeEmail=true found (line 53); would consume 2 of 15 daily emails
- Confirmed sf agent publish, activate, and sf community publish command syntax and required flags
- Verified CLI default org is wrong; all commands will use --target-org lal-devedition explicitly

**Open items**
- Turn off sendWelcomeEmail in site file (line 53: false) and re-validate before deploy
- Deploy validated step 2 build to lal-devedition
- Set up test data: assign role to user, create Maria and Ken, add org-wide sender address, create agent user with permissions
- Publish UC Portal site (sf community publish --name --target-org lal-devedition)
- Publish UC Assist agent (sf agent publish authoring-bundle --api-name --target-org lal-devedition)
- Activate UC Assist agent (sf agent activate --api-name --version --target-org lal-devedition)
- Commit step 2 work to develop branch
- Push to GitHub; add Apex class access (classAccesses) to permission set for non-admin access

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0 (org's latest version)
- Routing model metadata format: MOST_AVAILABLE; include capacityType INHERITED and isAttributeBased false
- Disable sendWelcomeEmail on UC Portal site before deploy to preserve email quota for verification codes

**Blockers**
- Apex class access not wired — non-admins and Agentforce agents cannot use new Apex entry point until classAccesses added to persona permission set

**Next**
- Disable sendWelcomeEmail (line 53 → false) in local site file
- Re-validate all 43 components and 23 tests after site file change
- Approve deploy to lal-devedition
- Create test data (role, Maria, Ken, sender address, agent user)
- Publish site and agent, then activate agent
- Commit and push to develop

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
I ran the approved command once, unchanged. It only read files and help text, so nothing changed in the org or the repo.

**What it found:**

1. **The UC Portal site will send welcome emails.** Line 53 of the local site file has `sendWelcomeEmail` set to `true`, using the standard `CommunityWelcomeEmailTemplate` (line 62). If I create Maria and Ken as they are, Salesforce sends each of them a welcome email. That uses 2 of the org's 15 emails a day, which the verification codes also need. I suggest turning it off (`false`) in the site file before the deploy, so the test users don't get emails we didn't plan for. Codes and the reset link aren't affected, because those are sent separately.

2. **Publishing the agent:** `sf agent publish authoring-bundle` takes `--api-name` and `--target-org`. It also has optional `--skip-retrieve`, `--verbose` and `--concise` flags.

3. **Activating the agent:** `sf agent activate` takes `--api-name`, `--target-org` and `--version`. If you leave out the name or version, it asks for them, so I'll always pass both.

4. **Publishing the site:** `sf community publish` takes `--name` and `--target-org`, and both are required.

5. **The CLI's default org is

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
