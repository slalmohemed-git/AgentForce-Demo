# Lessons
- Flows in namespace SvcCopilotTmpl (ResetPassword, SendVerificationCode, VerifyCode) are Salesforce Service Agent template placeholders, not customer flows. They can't be retrieved as source.
- This Developer Edition allows 15 single emails per day (from /limits). Every verification code is one email, so test runs need to be budgeted.
- Agent Script: datetime can't be a mutable or linked variable (action inputs/outputs only). Keep time-window rules on the server.
- Agent Script boilerplate exposes `RoutableId: linked string` from `@MessagingSession.Id`; empty in Builder preview, so bind verification with a server-issued token as well.
- `sf agent generate authoring-bundle -d` was ignored; the bundle landed in the project's force-app. Run it from the real project root.
- Bash heredocs containing Agent Script `set ...` lines are blocked by the shell guard; write such files with the file tool.

- An attached PDF can't be committed byte for byte from a session without retyping its base64; commit the text copy and have the user upload the binary in the GitHub UI.
