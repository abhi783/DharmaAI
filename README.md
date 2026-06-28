# Dharma AI - Flutter App

This repository contains a production-ready Flutter app scaffold for "Dharma AI" — a premium Android AI chatbot with Material 3, dark gold accents, MVVM + Clean Architecture, modular structure, Glassmorphism UI, and modern animations.

Features included in this scaffold:
- Premium dark theme with gold accents
- Glassmorphism cards and smooth micro-interactions
- Home screen with header and modular cards (AI Chat, Voice Chat, Bhagavad Gita, Ramayanam, Mahabharatam, Daily Wisdom, Settings)
- Chat screen with chat bubbles and input
- History, Profile, Settings screens
- MVVM-style ViewModels (ThemeViewModel, BaseViewModel)
- AIService stub (replace with your API integration)

How to run
1. Install Flutter (stable channel)
2. flutter pub get
3. flutter run

Next steps (recommended):
- Add platform apps via `flutter create` if you need native folders (android/ios) in this repo
- Integrate an AI provider (OpenAI, local LLM) in lib/core/services/ai_service.dart
- Add voice integration in services (speech_to_text + flutter_tts)
- Implement persistence for history with shared_preferences or a local DB
- Add real assets and refine branding

This scaffold is designed to be modular and easy to extend into a production app.
