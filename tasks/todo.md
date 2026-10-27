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
