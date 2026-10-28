# Handoff — current state

> **Rewritten at the end of every session.** This file is *now*; [`gotchas.md`](gotchas.md) is *forever*.
> If this file and [`../CONTEXT.md`](../CONTEXT.md) disagree, this one is newer.

**Last updated:** 2026-10-28 · **By:** Orchestrate build session (Demo-AgentBuild-UseCase-1)

---

## Where things stand

The UC Assist password-reset build (43 components) is deployed to `lal-devedition`. The `UC_Assist`
Agent Script bundle is published and **version 1 is Active** (BotVersion `0X9ak000007eFPJCA2`, checked
2026-10-28). The end-to-end tests T1–T8 have not been run yet, and the outgoing sender address still needs verifying.

## In progress

| What | State | Where it lives | Blocked on |
|---|---|---|---|
| Tests T1–T8 (spec test scripts) | Not run | Agentforce Builder test panel | Nothing |
| Org-wide sender address | Verification email sent, not clicked | Setup → Organization-Wide Addresses | Lal clicking the link |
| PR develop → main | Open | GitHub | Review |

## Next steps

<!-- Ordered. The top item should be the one to do next, not the most interesting one. -->

1. Click the verification link sent to slalmohemed@gmail.com, then confirm the address shows Verified.
2. Run T1–T8 in the Agentforce Builder test panel and check the plan tracer each turn.
3. Save T1–T8 as an Agentforce Testing Center test set.
4. Review and merge the PR from `develop` to `main`.

## Waiting on someone else

| What | Who | Since | Chased? |
|---|---|---|---|
| Sender address verification | Lal Shaik | 2026-10-28 | No |

## Things the next session should know

<!-- Anything true right now that is not obvious from the code: a half-finished refactor, a
     deliberately disabled test, a workaround that needs removing, a deploy that is half-applied.
     If you leave something in a strange state, this is where you say so. -->

- Two permission sets were assigned by hand in the org to make publish work (see gotchas.md). They are
  not in the repo's permission set group yet, so a fresh org setup needs them assigned again.
- Test data (users, customers, portal users) is created by the scripts in `scripts/apex/`, run in order 01 → 03.

<!-- orchestrate:session-state:start -->
<!-- Written by Orchestrate at the end of each session. Edits inside this block are
     replaced next session; anything OUTSIDE it is yours and is never touched. -->
### Engagement state — 2026-10-28
**Status:** on track — Router v3 live & tested; T6 handoff works but verification email blocked by Gmail SPF/DMARC

**Done this session**
- Confirmed Verification_Code record created (VC-00000) and Salesforce sendEmail succeeded
- Diagnosed email delivery failure: Gmail rejecting mail from Salesforce servers claiming @gmail.com sender

**Open items**
- Check Gmail Spam and All Mail for verification code email; search subject:'Your UC verification code'
- If email not found, review Setup → Email Log Files for last hour to confirm Gmail rejection
- Fix sender address: either clear Org_Wide_Email_Address__c or verify non-Gmail domain sender
- Rerun T6 with fresh verification code (previous one expired 10 min after 18:52 UTC)
- Complete remaining T1–T8 tests and save as test set in Testing Center
- Review and merge PR #1 to main
- Decide: keep or remove test-data setup scripts from commit
- Schedule Deploy session to ship to production

**Decisions**
- Deploy Digital Experiences via enableNetworksEnabled=true to lal-devedition
- Use Salesforce API 68.0
- Routing model: MOST_AVAILABLE; capacityType INHERITED, isAttributeBased false
- Disable sendWelcomeEmail before deploy
- Test UC_Assist in Preview panel (not in editing assistant chat)
- Use test customer emails: Maria (slalmohemed+maria@gmail.com), Ken (slalmohemed+ken@gmail.com), stranger (stranger@example.com)
- Fix router to always hand off immediately, never invent status claims
- Push router fix after publish approval to prevent loss

**Blockers**
- None

**Next**
- Search Gmail Spam and All Mail for 'Your UC verification code' email
- If not found, check Setup → Email Log Files for delivery status
- Choose sender fix: (a) clear Org_Wide_Email_Address__c or (b) verify non-Gmail domain
- Request new verification code and rerun T6 handoff test
- Continue T1–T8 test suite

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
The send worked on the Salesforce side. The problem is very likely how Gmail treats the email.

**What I found in `lal-devedition`:**
- Your test created a code record (`VC-00000`, 18:52 UTC) for Maria. This is the first one ever created, so the send action ran this time. The tracer in your screenshot agrees.
- `Messaging.sendEmail` didn't fail. If it had, the code rolls everything back and that record wouldn't exist. So Salesforce accepted the email.
- The email goes out with **From: `slalmohemed@gmail.com`** (the verified sender address) **to `slalmohemed+maria@gmail.com`**, which is the same Gmail inbox.

**Why it probably isn't in your inbox:** Salesforce sends from its own mail servers, not Google's, while claiming to be from a `@gmail.com` address. Gmail's sender checks (SPF/DMARC) fail for that kind of email, so Gmail often sends it to Spam or rejects it without telling you. It's worse when the From and To addresses are the same mailbox. This is my best explanation, not something I've confirmed. I can't see Gmail or Salesforce's outbound mail log from here.

**Please check now:**
1. In Gmail, search `subject:"Your UC verification code"` in **Spam** and **All Mail**.
2. If it

_[summary truncated — see the session record for the full text]_
<!-- orchestrate:session-state:end -->
