# ADR — POC Phase 5: intake in the Knowledge agent, one confirmed call to a real Case agent

**Date:** 2026-11-19 · **Status:** Accepted
**Deciders:** Lal Shaik · **Supersedes:** none (replaces the Phase 4 stub handoff target)

## Context

Phase 4 left `POC_Knowledge_Agent` handing support requests to `POC_Case_Agent_Stub`. Phase 3 showed that a
connected agent in supervisor mode does one request and one reply per call, that the Flow runs as the employee
only when reached through the Employee orchestrator, and that `submission_id` survives repeat calls in the same
Case-agent session.

## Decision

1. **Intake lives in the Knowledge agent.** It collects subject, description, category, what was tried and the
   article numbers cited, shows a summary, asks "Shall I submit this?", and only a clear yes in reply submits.
   Reason: the Case agent cannot hold a multi-turn conversation (one request, one reply per call).
2. **The Case agent is new: `POC_Case_Agent`.** Service agent (ExternalCopilot), no channel, default user POC Agent,
   one action: `flow://POC_Create_Case`. The stubs are unchanged.
3. **Fields go over as typed inputs, not chat text.** The `connected_subagent` block declares `inputs:` bound to the
   Knowledge agent's variables (Subject, Description, Category, TroubleshootingNotes, KnowledgeRefs, confirmed,
   request_key). The Case agent's matching variables must be `visibility: "External"`, or publishing the
   orchestrator fails with "has no variables defined". The Case agent passes them to the Flow from variables, so the
   model never retypes them.
4. **The Flow call is a step, not a model choice.** In the Case agent, `run @actions.poc_create_case with … set …`
   runs CREATE (new ID) or CHECK first (ID already sent), then CREATE only on NOT_FOUND. The model only creates the
   submission ID (`POC-` + 12 characters), which it must do itself. The reply is built from the stored ResultCode,
   CaseNumber and Message.
5. **Submission ID lifecycle:** `request_key` (from the Knowledge agent, +1 per new request) decides it.
   New key → ID cleared → model creates a new one → CREATE. Same key (a retry, or a repeat after SUCCESS) → CHECK
   first → DUPLICATE returns the existing Case, NOT_FOUND → CREATE with the same ID. VALIDATION / AUTHORIZATION reset
   the ID; ERROR / INDETERMINATE keep it so a retry is safe. `confirmed` is reset to false after every turn.
   This differs from the brief (which cleared the ID straight after SUCCESS): the Knowledge agent cannot read the
   result as data, so a "lost response" retry must keep the same ID to come back DUPLICATE. Approved 2026-11-19.
6. **The Knowledge agent marks the request submitted after any confirmed submit turn**, and clears the case fields
   when the next request starts. A plain "yes" afterwards does not submit again; "try again" re-sends with the same
   request_key, which is safe because of 5.

## Tested (lal-devedition, 2026-11-19, as Lal via `sf agent preview`; final versions Case v4, Knowledge v7)

T1, T2, T3, T4, T5, T6, T7, T9, T10, T11, T12, T13, T15 passed. The Case agent's Flow calls were read from Data Cloud
session tracing (CREATE once for T1; CHECK → DUPLICATE for the T10 retry; CREATE with a new ID for T3).

## Not tested / assumed

- T8: the Flow's VALIDATION result through the agent. The Knowledge agent never passes a category outside the three,
  and direct preview cannot set `confirmed=true` (see gotchas). VALIDATION was tested at Flow level in Phase 2.
- T14: whether POC_Case_Agent shows in any picker. It has no channel and no access grants; the UI was not checked.
- INDETERMINATE and timeout paths: built, not reached by any test.
- Two submits at the same moment with the same Failed row (known Flow limit from Phase 2).

## Consequences

Phase 6 tests from a non-admin employee and the Lightning panel. Changing POC_Case_Agent's active version needs
POC_Knowledge_Agent deactivated first.
