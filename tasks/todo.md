# UC Assist — Password Reset with Identity Verification (Agent Script)
Session 98d70d6d · branch `develop` · org lal-devedition · no Jira (specs live in git)

## Step 1 — Lock the design
- [x] Read-only discovery: repo (empty), org (agents, flows, sites, users, licenses, limits, settings)
- [x] Spec gap analysis (D01-design-review)
- [x] User decisions: D1 enable Digital Experiences + site; D2 queue + Case, live later; D3 S2,S3+S4,C1/C2,S5-S8; D4 slalmohemed+maria/+ken
- [x] Final spec v1.0 written (docs/specs/02-final-spec.md) + ADR-001, ADR-002, README
- [x] Commit specs to git: main bootstrap commit, develop with specs + source text copy, PR develop -> main
- [ ] Original source PDF into docs/specs/00-source/ (user upload via GitHub UI; no byte-safe tool path from this session)
- [x] Spec v1.0 LOCKED by user, 27 Oct 2026

## Step 2+ — Build (after design lock)
- [ ] Org prerequisites (Digital Experiences, site, role, portal users, org-wide email, picklists, queue)
- [ ] Verification_Code__c + permission set
- [ ] Apex: SendVerificationCode, CheckVerificationCode, ResetUserPassword + tests (>=90%)
- [ ] Flow Reset Portal Password
- [ ] Agent Script authoring bundle (UC Assist): validate, publish, preview
- [ ] Testing Center T1–T8

# Phase 6 — End-to-end testing as non-admin employees
- [x] Step 1 survey (read-only) — findings reported 2026-11-19
- [ ] Get approval: users, permission set, seat handling, wording fix
- [ ] Step 2 create test users + POC_Knowledge_Agent_User permset; read back; access matrix
- [ ] Step 3 wording fix in POC_Knowledge_Agent (line 244), publish v8, read back, trace
- [ ] Step 4 docs/poc-phase6-test-script.md; run E1–E12 with Lal; verify after each
- [ ] Step 5 INDETERMINATE at Flow level (approval for the fake log row)
- [ ] Step 6 decision record, handoff.md, gotchas (if real), commit to develop
- [x] Phase 6 Step 2: POC_Knowledge_Agent_User deployed (0Afak00000tWoTSCA0), grant read back on POC_Knowledge_Agent only
- [x] Phase 6 Step 2: Employees A (005ak00000oWvKvAAK) and B (005ak00000oWFryAAG) created; assignments read back
- [x] Phase 6 Step 3: POC_Knowledge_Agent v8 published and activated; trace session 01a1f4d3-dec3-7fcd-9899-d91bd8bccd30 shows v8
- [x] Phase 6 Step 4: docs/poc-phase6-test-script.md written
- [ ] Phase 6 Step 4: Lal runs P0, E1–E12 in the panel; Orchestrate checks each
- [ ] Phase 6 Step 5: INDETERMINATE at Flow level (needs approval)
- [ ] Phase 6 Step 6: decision record, handoff, commit

### Assigned by hand (for handoff.md)
- 2026-11-19: POC_Knowledge_Agent_User assigned to Lal (assignment 0Paak00001G0XTiCAN) so Lal can open POC Knowledge Agent in the panel. Lal's runs do not count as Phase 6 tests.

### Fix: sensitive-data false positive (found by Lal in the panel, 2026-11-19)
- [ ] Narrow the sensitive rule to data about a specific, identifiable person; topics like scholarships, financial aid, fees or grading policy are not sensitive
- [ ] Validate, publish v9, activate, read back, confirm in trace
