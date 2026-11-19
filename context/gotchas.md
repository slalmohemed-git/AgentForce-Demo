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

- **A connected (related) agent can't change its active version while an Active agent uses it.** `sf agent activate`
  fails with "Agent you are trying to deactivate is in use by other agents". Deactivate the orchestrator, activate the
  new version, reactivate the orchestrator. After activation, preview kept running the old version for about a
  minute. *Hit 2026-11-19, cost two test runs on the wrong version.*
- **The `$User` of a Service agent depends on how it's reached.** Previewed directly, the POC Case agent ran its Flow
  as its default agent user. Called in supervisor mode from an Employee agent, the same Flow ran as the employee.
  *Seen 2026-11-19 (Cases 00001032 vs 00001033).*
- **Agent Script: telling the model "never make up a submission ID" stops it filling a `@utils.setVariables` slot.**
  It passed an empty string three times until the instruction explicitly told it to create the value.
  *Hit 2026-11-19, cost three publishes.*

## This client's environment

<!-- Specific to this org: a validation rule that fires unexpectedly, a managed package that
     conflicts, an integration that rate-limits, a sandbox that behaves unlike production. -->

-

## Process

<!-- How work gets approved, deployed or reviewed here that is not obvious — an approval that takes
     three days, a deploy window, a person who must be in the room. -->

-

- **A message that says "ignore your rules…" never reaches your router.** The platform routes it to its own
  `Prompt_Injection` topic, which refuses the whole message, so an embedded real question ("…how do I reset a Mogli
  template?") gets no Knowledge search. Routing rules for injection in your script don't run. *Seen 2026-11-19
  (POC_Knowledge_Agent T7, trace `Router → Prompt_Injection`), cost one republish chasing it.*
- **Agent Script: a "no answer" instruction can make the model skip the action.** "If it returns NO_KNOWLEDGE_ANSWER,
  fails or returns nothing, say no answer" led the model to reply "no approved answer" without calling the
  Knowledge action (tool enabled, no FunctionStep). Store the action output in a variable and branch the
  instructions on it (`if @variables.last_answer == ""` → call it). Nested `if` isn't allowed; use `and`.
  *Hit 2026-11-19, POC_Knowledge_Agent v2, cost one republish.*

- **Agent Script: a `connected_subagent` with `inputs:` needs the target agent's matching variables marked
  `visibility: "External"`.** Variables default to Internal, and publishing the orchestrator then fails with "The agent
  … specified as the target has no variables defined, but the inputs block specifies input mappings", even though
  `validate` passes. The only values are Internal / External. *Hit 2026-11-19 (POC Phase 5), cost one failed publish
  and a republish of POC_Case_Agent.*
- **Agent Script: `run @actions.X` must name an action definition (the subagent-level `actions:` entry, e.g.
  `poc_create_case`) with its own `with` / `set` lines, not a reasoning tool name.** Naming a tool (`create_case`)
  validates and publishes, but every turn of the agent, on every path, fails with "I apologize, but I encountered an
  unexpected error" (ACTION_FAILED at the first node). Decode `agentGraph/*.json` (base64) after publishing and check that
  each `run` target is in `actionDefinitions`. A connected agent is a `supervision` tool, so it can't be `run` at all.
  *Hit 2026-11-19, both POC agents broken for about 5 minutes until rolled back with `sf agent activate --version`.*
- **Agent Script: a `set` on a `@connected_subagent` tool compiles (it shows in the graph as `stateUpdates`) but is
  never applied at runtime.** Don't use it to detect that the connected agent was called. *Hit 2026-11-19, Knowledge v6:
  the request stayed "awaiting confirmation" after a SUCCESS.*
- **The model can skip a connected-agent call and invent its reply.** POC_Knowledge_Agent v4 entered the submit step
  with the tool enabled, made no call, and replied "The Case agent replied: SUCCESS"; no Case existed. Make the
  downstream action deterministic (`run`) where you can, and keep retries safe (same submission ID → CHECK →
  DUPLICATE / NOT_FOUND → CREATE). *Hit 2026-11-19, found only because the Case and log counts didn't move.*
- **`sf agent preview start --context-variables` with a boolean (`confirmed=true` or `True`) stops the agent's
  planner, and the platform answers with invented text ("Your confirmed support request has been submitted") followed by
  SessionEnded.** No action runs. String and number context variables work. Always check record counts, not the reply.
  *Hit 2026-11-19 (POC_Case_Agent direct preview), cost the planned direct tests T8 and T10.*
