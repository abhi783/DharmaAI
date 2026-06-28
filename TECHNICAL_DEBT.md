# TECHNICAL_DEBT — Dharma 1.0

This document enumerates technical debt discovered during the Version 1.0 production review. Items are categorized by severity with suggested remediations and ownership notes.

## Critical
These must be fixed before release.

1. Provider stub on server (server/src/provider.ts)
   - Description: The server currently returns deterministic placeholder content for sections. Production teaching requires integration with a secure LLM + RAG pipeline to produce high-quality, verified sections and scripture excerpts.
   - Risk: Incorrect, low-quality, or fabricated teaching content; legal/trust risk for scripture content.
   - Remediation: Integrate production provider (LLM + RAG), ensure RAG sources are validated and markup scripture meta; include provider key management in secure secrets vault.
   - Note: This is a server-side change. Per your directive, backend work is paused after STEP 2 — coordinate ops to schedule provider rollout.

2. Accessibility gaps (client)
   - Description: Missing TalkBack semantics and insufficient focus/labeling on dynamic teaching sections and controls.
   - Risk: App unusable for screen-reader users; accessibility compliance failure.
   - Remediation: Add semanticsLabel to interactive widgets, ensure focus traversal order, support large fonts and contrast checks. Add automated a11y tests.

3. Permission handler recursion (fixed)
   - Description: PermissionHandlerCompat previously invoked itself, causing recursion when opening system settings.
   - Action taken: Fixed by calling package-level openAppSettings via alias to permission_handler.
   - Verification: Test on-device flows for both deny and permanently deny scenarios.

4. Offline & stream resilience
   - Description: Streaming client needs robust reconnection/backoff and clear offline state handling.
   - Risk: Poor UX during network issues; potential data loss for live sessions.
   - Remediation: Implement exponential backoff, user-visible offline banner, and option to retry or save partial sessions locally.

## High
Fix these after Critical items.

1. Performance hotspots — particle system & painters
   - Description: Particle painters and shadow blurs can cause frame drops on low-end devices.
   - Remediation: Implement adaptive particle counts based on device memory and CPU, reduce shadow layers, and optionally disable non-essential visual effects.

2. TTS locale and voice fallback logic
   - Description: Need robust selection of Telugu voices with graceful English fallback; test across devices.
   - Remediation: Gather available voices at init, prefer 'te-IN' variants, expose manual selection in settings.

3. Telemetry opt-in UX
   - Description: Telemetry hooks exist, but clear user-facing opt-in UI and privacy text are missing.
   - Remediation: Add Settings -> Privacy toggle and clear description; ensure no events sent until opt-in.

4. Memory leaks from stream subscriptions and controllers
   - Description: Some streams and animation controllers may not be consistently disposed in edge cases.
   - Remediation: Audit lifecycle of screens, ensure all StreamSubscription.cancel() and AnimationController.dispose() are invoked in dispose().

## Medium
Address in v1.1.

- Reflection Mode full interaction handler (accept user answer and continue teaching adaptively).
- Learning Journey UI polishing and saved session management UX improvements.
- Expand unit and widget test coverage for edge cases (permission denied, TTS unavailable).
- Improve error messages and localized strings (Telugu + English proofreading).

## Low
Address in future iterations.

- Hotword offline support (post-launch feature).
- Rich Rive animations and artist-driven orb assets.
- Multi-device sync for saved sessions.
- Gamified progress (explicitly deferred).

---

Notes
- The team should triage Critical and High items and allocate engineering time for them as the highest priority for v1.0.
- Several Critical items (provider integration) require coordination with ops and content teams; do not proceed without approvals and secret management in place.
