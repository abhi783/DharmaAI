# VERSION 1.0 — Release Checklist

This file tracks the production readiness items for Dharma 1.0 (Android-only).
Follow the order: complete Critical items, then Important, and defer Nice-to-Have.

## Completed
- Startup cinematic (procedural Dharma Orb, particles) and transition to Home.
- Voice Mode (immersive experience) with orbital states, waveform, minimal controls.
- Client-side TeachingSession UI with per-section animations and TTS speak-and-wait.
- Server SSE teaching endpoint (per-section generate→validate→stream) with scripture metadata and 1-retry policy (development provider stub).
- Client SSE consumer and client-only teaching session persistence (SharedPreferences) with explicit save dialog.
- Telemetry hooks added (opt-in required before sending any data).
- Unit tests for teaching engine and server SSE integration tests; basic widget tests for Voice Mode flows.

## Remaining — Critical (must fix before release)
1. Accessibility
   - Add TalkBack semantics for all interactive controls (mic CTA, mic floating action, controls, save dialogs) and for dynamic teaching sections.
   - Ensure focus order and keyboard navigation, large-text scaling and contrast.
2. Permission handling bug (fixed)
   - Fixed recursion in PermissionHandlerCompat.openAppSettings; verify on device flows and VA behavior.
3. Provider integration on server
   - Replace provider stubs with production LLM/RAG pipeline and secure config. (Coordination required — DO NOT proceed without ops/keys; listed as Critical for GA content quality.)
4. Performance profiling and optimization
   - Profile on target devices (low/mid/flagship) and fix hotspots to maintain 60 FPS in common flows.
5. Offline and network error handling
   - Add robust network error states, stream reconnection/backoff, and clear UI when offline or stream fails.
6. Privacy & telemetry wording
   - Add clear settings screen entry describing telemetry opt-in, exactly what is captured and how to disable it.

## Remaining — Important
- Reflection Mode interactive flow (pause, accept user's verbal/text answer, continue teaching adaptively).
- Learning Journey UI: saved sessions viewer, progress indicators (non-gamified), continue learning suggestions.
- Final voice settings: voice selection, speed, pitch, auto-continue toggle; persist settings.
- Replace temporary sound cues with production audio assets and tune haptics.
- Expand unit/widget tests covering interruption flows and save/delete session behavior.

## Remaining — Nice to Have
- Hotword offline support (deferred until post-launch).
- Multi-device sync of saved sessions.
- Rich Rive avatar assets for the orb or a companion avatar.

## Known Issues
- Telugu TTS voices vary across Android devices; fallback to English may be required on some devices.
- Some CI widget tests touching STT/TTS require device validation.
- Server currently contains provider stubs — production provider integration is required for authoritative scripture and teaching quality.

## Performance Notes
- Target 60 FPS. Use adaptive particle counts, reuse AnimationControllers and throttle streaming updates.
- Throttle UI updates from streaming text to 40–80ms windows or on sentence/punctuation boundaries.

## Testing Status
- Unit tests: teaching engine (client & server types) — passing.
- Widget tests: VoiceMode, CTA, TeachingSession build tests — basic passing; need expansion.
- Integration: server SSE tests for stubbed provider — passing in dev.

## Play Store Readiness
- Prepare Play Store assets (feature graphic, screenshots, promotional video) and localized store listing (Telugu + English).
- Prepare privacy policy and in-app privacy settings page.
- Ensure release signing and target API compliance (Android SDK targets).

---

Place this file at the repo root and use it as the authoritative v1 checklist. Fix Critical items first and update the checklist as each is resolved.
