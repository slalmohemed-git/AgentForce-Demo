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
**Status:** on track — Org-wide sender address created; awaiting verification link click. Ready for step 4: publish UC Assist agent.

**Done this session**
- Created org-wide sender address 'UC Support' <slalmohemed@gmail.com> (Id 0D2ak0000009F9VCAU) in lal-devedition, available to all profiles

**Open items**
- Click verification link sent to slalmohemed@gmail.com to activate sender address
- Publish and activate UC Assist agent (step 4)
- Run tests T1–T8 and confirm all pass
- Update handoff notes and open PR from develop to main

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0
- Routing model: MOST_AVAILABLE; capacityType INHERITED, isAttributeBased false
- Disable sendWelcomeEmail before deploy
- Deploy from develop branch (commit 0eb8642 + context-only commits)
- Split deploy: Deploy A then Deploy B (18 components, deployed)
- Deploy UC Portal Customer profile separately before Deploy B
- Use quick-deploy for validated job instead of retrying safety check

**Blockers**
- None

**Next**
- Click verification link in slalmohemed@gmail.com inbox to verify org-wide sender address
- Confirm address shows as Verified in Setup → Organization-Wide Addresses
- Reply 'continue' when ready to proceed with step 4: publish and activate UC Assist agent

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
I ran the command once, unchanged, and the org-wide address is now in `lal-devedition`. I read it back to check:

- **Record:** "UC Support" <slalmohemed@gmail.com>, Id `0D2ak0000009F9VCAU`, available to all profiles.

**One thing only you can do:** Salesforce sends a verification link to slalmohemed@gmail.com, and the address can't send email until you click it. My query couldn't tell me whether it's been verified yet, because the verification status field wasn't available. After you click the link, Setup → Organization-Wide Addresses should show it as Verified.

That finishes step 3. The agent user, the role, both customers, both portal users and the sender address are all in place.

**Next is step 4: publish and activate UC Assist.** This makes the agent live in the org, so I'll say exactly what it will do and ask you first. Reply "continue" when you're ready. Click the verification link first if you can, because test T1 needs the code email to send.

Sources: checked live: `lal-devedition` (create result, OrgWideEmailAddress query) · not checked: whether the address has been verified
<!-- orchestrate:session-state:end -->
