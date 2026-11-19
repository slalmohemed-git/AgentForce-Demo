# ADR-094 — GO: keep two agents (Employee orchestrator + headless Service Case agent, supervisor mode)

**Date:** 2026-11-19 · **Status:** Accepted
**Deciders:** Lal Shaik (Case agent type: Service; go-ahead to publish and test) · **Supersedes:** none

## Context

Before building the real agents in Phases 4 and 5, we had to prove three things in `lal-devedition`:
can an Employee Agent call a second, headless agent and get control back; what `$User` is when an agent
runs `POC_Create_Case`; and whether an agent variable can hold a submission ID across calls and a handoff.

Two stub agents were published and tested on 2026-11-19 with `sf agent preview` (CLI plugin-agent 2.0.5),
chatting as **Lal** (`slalmohemed.c437bd0a8ab7@agentforce.com`):

- `POC_Knowledge_Agent_Stub` — Employee agent (`InternalCopilot`), no default user, v1 Active. Calls the Case
  agent through `@connected_subagent.POC_Case_Agent_Stub` (supervisor mode). Planner type
  `Atlas__ConcurrentMultiAgentOrchestration`; agent graph holds a `supervision` tool aimed at a `related_agent` node.
- `POC_Case_Agent_Stub` — Service agent (`ExternalCopilot`), default user POC Agent (`005ak00000oV1FxAAK`),
  no channel, v4 Active. One action: `flow://POC_Create_Case`.

## Results (all TESTED unless marked)

| Question | Answer | Evidence |
|---|---|---|
| Connected agents supported | **Yes** (supervisor mode) | Trace `RelatedAgentStep`, `delegationMode: supervision`, `delegationType: SYNC`, Case agent runs in its own session |
| Handoff returns control | **Yes**, in the same turn | Orchestrator spoke after every Case-agent reply ("Back with the Knowledge stub.") — T1, T4, T7 |
| Case agent keeps the conversation (T2) | **No**, by design of supervisor mode | A follow-up question went to the orchestrator, not the Case agent. Each call is one request/reply |
| Case agent hidden from the picker (T3) | **Not determinable** from here | It is a Service agent with no channel and no access grant (0 SetupEntityAccess rows), so it should not show in the employee panel; the UI picker was not opened |
| `$User` under the agent (T8) | **Depends on the entry point** | Reached **through the orchestrator**: Requester and CreatedBy = **Lal, the employee** (SUB-000008 / Case 00001033). Previewed **directly**: Requester = **POC Agent user** (SUB-000007 / Case 00001032) |
| CHECK scoping follows `$User` (T4) | **Yes** | CHECK POC-P2-T01 (Lal's log): through orchestrator → DUPLICATE 00001028; directly as POC Agent → NOT_FOUND "found for you" |
| `submission_id` reused across calls (T6) | **Yes** | Same ID POC-P3-4ZKJ3T1V8QY sent twice → SUCCESS 00001032, then DUPLICATE 00001032 |
| `submission_id` survives the return to the orchestrator (T7) | **Yes** | Both orchestrator calls used the same Case-agent session `01a1f45b-0283…`; same ID POC-P3-5ZK3Y2Q9RL → SUCCESS 00001033, then DUPLICATE |
| Authorized agent not refused (T9) | **Yes** | SUCCESS as POC Agent user and as Lal (both hold POC_Case_Agent_Access) |
| User without the permission set refused (T9) | **Not tested this phase** | Tested at Flow level in Phase 2 (AUTHORIZATION for Lal without the set) |

Assumed, not tested: that the Case-agent session (and `submission_id`) lives for the whole orchestrator session
and not beyond it; that an Employee user without access to the orchestrator cannot reach the Case agent.

## Options considered

| Option | For | Against |
|---|---|---|
| **A — Two agents, supervisor mode (chosen)** | Proven here; Case agent runs as the employee, so Requester and CHECK scoping are right | Case agent does not hold a multi-turn conversation; the orchestrator must collect intake and pass it on, or call it per step |
| **B — One agent with a case-intake subagent** | Multi-turn intake inside one agent | Loses the separation we just proved works; no benefit found |
| **C — Handoff mode (`@utils.transition to @connected_subagent`)** | Case agent would own the conversation | Compiles but not tested; control may not return |

## Decision

Continue with two agents. Phase 5's Case agent is reached in supervisor mode from the Knowledge agent.

## Why

Every gating question passed with evidence, and the `$User` result is the good case: through the orchestrator
the Flow runs as the employee, so "requester" means the employee and CHECK's per-requester scoping protects
employees from each other.

## Consequences

**Accepted costs:**
- Supervisor calls are single request/reply. Intake must be gathered by the orchestrator (or by repeated
  calls whose state lives in the Case agent's session variables, as T7 showed).
- If the Case agent is ever reached directly (its own channel), `$User` becomes the POC Agent user and every
  requester collapses to one user. Keep it channel-less.
- Switching the Case agent's active version needs the orchestrator deactivated first (see gotchas.md).

**Revisit if:** the Case agent gets a channel of its own, or Phase 5 needs true multi-turn intake inside the Case agent.
