# PERFORMANCE_REPORT — Dharma 1.0

This report documents current performance posture, targets, findings from the review, and concrete optimization recommendations. The goal is 60 FPS across the target device classes.

## Target device classes
- Low-end: 4GB RAM, Android 10
- Mid-range: 6GB RAM, Android 12
- Flagship: 8GB+ RAM, Android 14+

## Measurement approach
- Profiled codebase conceptually and identified hotspots (CustomPainters, AnimationControllers, stream-to-UI updates).
- Recommended device testing: Pixel 6 (mid), Samsung A32/A53 (low-mid), and a Pixel 8/Pro (flagship). Real device testing required for STT/TTS.

## Findings
1. Particle system (CustomPainter) and halo shadows
   - Risk: High impact on frame rendering when many particles or large blur/shadow radii are used.
   - Recommendation: Reduce particle count dynamically based on available memory; reduce shadow blur on low devices.

2. Streaming text updates (per-character updates)
   - Risk: High CPU due to frequent rebuilds and text layout calculations.
   - Recommendation: Throttle updates to 40–80ms or update only on punctuation/sentence boundaries. Use partial buffering and then push batch updates to the UI.

3. AnimationControllers allocation
   - Risk: Medium — creating controllers per widget causes overhead.
   - Recommendation: Reuse controllers where possible (lift controllers to parent widgets) and use AnimatedBuilder/AnimatedWidget to localize rebuilds.

4. Waveform & orb painters
   - Risk: Medium — current painters are reasonably light, but can be optimized by caching paint objects and avoiding allocations per frame.
   - Recommendation: Cache Paint objects and precompute static parts; only animate amplitude values.

5. TTS latency & thread blocking
   - Risk: Medium — TTS start/stop calls can block if not awaited properly, and speakAndWait uses completion handlers.
   - Recommendation: Ensure TTS calls are non-blocking and run on the appropriate isolate if necessary; use timeouts for speakAndWait.

6. Memory leak risks
   - Risk: Medium — StreamSubscriptions and AnimationControllers must be disposed in all lifecycle paths.
   - Recommendation: Audit all StatefulWidgets for proper dispose() implementation. Add unit tests to check no active subscriptions after popping screens.

7. Network efficiency
   - Risk: Low — SSE streaming is efficient for per-section events. Ensure payloads are compact and meta is minimal. Use gzip on server if large.

8. Battery consumption
   - Risk: Medium — continuous use of STT/TTS and high-frequency animations may drain battery during extended sessions.
   - Recommendation: Offer an "Energy Saver" mode toggling lower visual fidelity and disabling continuous listening unless explicitly enabled.

## Immediate optimizations to implement (Critical & High)
1. Adaptive particle system (Critical)
   - Implement device capability detection (RAM and API level) and scale particle count / blur accordingly.
2. Throttle streaming UI updates (Critical)
   - Implement a short buffer/ticker so UI updates occur at most every 40–80ms or on sentence boundaries.
3. Reuse AnimationControllers (High)
   - Move shared controllers to parent widgets and use ValueListenable to propagate values.
4. Ensure all StreamSubscriptions/Controllers disposed (High)
   - Add tests and lint rules to detect leaks. Audit VoiceMode, RootScaffold, and other long-lived widgets.
5. TTS robustness (High)
   - Add timeouts and safe cancellation for speakAndWait. Ensure platform differences are guarded and errors handled.

## Performance checklist
- [ ] Add device capability detector and environment flags.
- [ ] Implement adaptive particle counts for low/mid/high devices.
- [ ] Add global streaming throttler (40–80ms) and update pipeline.
- [ ] Move heavy animations to a single shared AnimationController per screen.
- [ ] Profile on target devices and iterate.

## Notes for QA
- Use Android Profiler (CPU, Memory, GPU) during Voice Mode streaming and teaching session playback.
- Measure frame rendering jank and dropped frames; aim for < 5% dropped frames on mid-range device.
- Test TTS start latency and STT response on multiple devices; latency target: < 300ms to start TTS after receiving section (network latency excluded).

---

End of report. Implement Critical and High optimizations before release and schedule Medium/Low for v1.1.
