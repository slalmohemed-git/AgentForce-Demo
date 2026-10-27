# ADR-001: Separate verification and reset subagents, gated by a shared variable

Date: 2026-10-27
Status: Accepted

## Context

UC Assist must reset a customer's portal password only after it has verified who they are. The source spec weighed three options:

- A: reset action inside the verification subagent
- B: a separate Password Reset subagent, gated by a verification variable
- C: a verification-subagent instruction that triggers the reset

## Decision

Option B. Identity Verification only verifies, and writes `IsVerified`, `VerifiedContactId` and `VerificationToken` from action outputs. Password Reset only resets, and its action is `available when @variables.IsVerified == True`. The reset Flow re-checks the verification on the server by redeeming a one-time token bound to the Contact and the session, within 15 minutes, single use.

## Rationale

- One job per subagent; verification can be reused by future subagents (for example Update Email) with no change.
- The gate is deterministic (action availability), not just an instruction to the model.
- The server re-check means a bypass of the agent layer still can't reset an unverified account.

## Consequences

- Three layers of control: action gate, instructions, server re-check.
- The token adds one field and one Apex action, but closes cross-session reuse and replay.
