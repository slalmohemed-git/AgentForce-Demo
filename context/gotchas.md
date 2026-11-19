# Gotchas

> The things that will bite the next person. **Append-only — this file only grows.**
> [`handoff.md`](handoff.md) is *now*; this is *forever*.

**Last reviewed:** 2026-10-27

## How to write one

**Every entry carries the incident and the date.** That is what stops the next person waving it away
and losing the same two hours.

> ❌ "Prompt Template deploys can be unreliable."
>
> ✅ "**Prompt Template content updates cannot be deployed via Metadata API** — the deploy reports
> success but the content is unchanged (silent no-op). Must be edited in Prompt Builder UI.
> *Hit 2026-09-10, cost ~2 hrs before we noticed the content had not changed.*"

The difference: the second one is checkable, tells you what to do instead, and carries the evidence
that it is real.

---

## Platform

<!-- Salesforce / platform behaviour that is surprising, undocumented, or documented-but-wrong. -->

- **`sf agent publish authoring-bundle` fails with "User doesn't have access to agent" (HTTP 401) even
  though `validate` passes.** Two permission sets were missing: **Agent Platform Builder** on the user
  doing the publish, and **Agentforce Service Agent User** on the agent's running user. Assign both, then
  publish. *Hit 2026-10-28, took two failed publishes to find.*

- **A FlowTest assertion takes exactly one condition.** Two conditions in one `<assertions>` block fail the deploy
  with "contains an assertion that exceeds the limit of conditions"; use one `<assertions>` per condition.
  Flow Tests on an autolaunched flow are supported here (inputs as `<type>InputVariable</type>` at the `Start`
  test point, assertions at `Finish`). *Hit 2026-11-19, cost one failed deploy.*
- **`flowAccesses` on a permission set doesn't stop an admin from running a flow** (and the Einstein Agent User
  profile has Run Flows). Enforce who may call a flow with a custom permission checked inside the flow.
  *Seen 2026-11-19: Lal ran POC_Create_Case with POC_Case_Agent_Access removed; only the custom permission
  check refused it.*

## This client's environment

<!-- Specific to this org: a validation rule that fires unexpectedly, a managed package that
     conflicts, an integration that rate-limits, a sandbox that behaves unlike production. -->

-

## Process

<!-- How work gets approved, deployed or reviewed here that is not obvious — an approval that takes
     three days, a deploy window, a person who must be in the room. -->

-
