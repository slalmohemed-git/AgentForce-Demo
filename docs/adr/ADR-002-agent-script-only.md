# ADR-002: All agent work is authored in Agent Script

Date: 2026-10-27
Status: Accepted

## Context

The delivery lead requires every agent artifact to be built with Agent Script (the script-based Agentforce authoring model), not the classic Builder topic and action configuration.

## Decision

The UC Assist agent is one authoring bundle, `force-app/main/default/aiAuthoringBundles/UC_Assist/`, kept in source control. Classic-Builder concepts from the source spec map as follows:

| Classic Builder | Agent Script |
|-----------------|--------------|
| Topic | `subagent` |
| Action filter / conditions | `available when` |
| Non-user-editable variable | `mutable` variable written only by `set ... = @outputs...` |
| Require user confirmation | `require_user_confirmation: True` on the action definition |
| Conversation context | `linked` variable (for example `@MessagingSession.Id`) |

## Consequences

- The agent is reviewable, diffable and deployable like code.
- Every change is checked with `sf agent validate authoring-bundle`, then `sf agent preview` / `sf agent test`, before `sf agent publish authoring-bundle`.
- Datetime can't be a conversation variable, so time-based rules live on the server (final spec, V1).
- Keyword names can change between releases; the compiler has the final say, and changes are logged in the spec's change log.
