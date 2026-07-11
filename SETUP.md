# EduNavigate AI — Setup (bind your keys)

The app is wired end-to-end. It will not launch until Firebase keys are bound —
that is the only thing left for you to do.

## 1. Install dependencies

```bash
flutter pub get
```

## 2. Bind Firebase (pick ONE)

**Option A — automatic (recommended)**

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This overwrites `lib/firebase_options.dart` with real values and drops the
native config files in place.

**Option B — manual**

1. Firebase Console → Project Settings → Your apps → copy each value into the
   matching `PASTE_..._HERE` placeholder in `lib/firebase_options.dart`.
2. Download and place:
   - Android → `android/app/google-services.json`
   - iOS → `ios/Runner/GoogleService-Info.plist`

## 3. Enable Firebase services

In the Firebase Console:
- **Authentication** → enable **Email/Password**.
- **Firestore Database** → create database → paste `firestore.rules`.
- **Storage** → enable → paste `storage.rules`.

## 4. (Optional, Phase 5) Gemini key

Not needed until the AI Mentor phase. When you get there, create a gitignored
`env.json` at the repo root:

```json
{
  "GEMINI_API_KEY": "your_google_ai_studio_key"
}
```

Get a key at https://aistudio.google.com/apikey — it must start with `AIzaSy`.
Then launch with:

```bash
flutter run --dart-define-from-file=env.json
```

## 5. (Optional) Nearby Schools & Coachings — Google Maps Platform

Not needed until you use the "Nearby Schools" / "Nearby Coachings" features.
This is live Google-only data — no bundled sample data is used, so without a
working key those screens show an explicit error instead of results.

1. In [Google Cloud Console](https://console.cloud.google.com/), create/select
   a project and **enable billing** (required by Google even within the free
   monthly usage credit).
2. Enable these APIs on that project:
   - **Places API (New)**
   - **Maps SDK for Android**
   - **Maps SDK for iOS**
3. Create an API key (APIs & Services → Credentials) and restrict it to the
   three APIs above.
4. Add it to the same gitignored `env.json` used for Gemini:

```json
{
  "GEMINI_API_KEY": "...",
  "GOOGLE_MAPS_API_KEY": "your_google_maps_platform_key"
}
```

Android reads this automatically at build time (see
`android/app/build.gradle.kts`) — no extra step needed.

For iOS, additionally paste the same key into
`ios/Runner/Info.plist` → `GMSApiKey` (this one isn't dart-define'd because
the native Maps SDK initializes before Flutter/Dart runs).

Then launch with:

```bash
flutter run --dart-define-from-file=env.json
```

## 6. Run

```bash
flutter run
```

Flow: Splash → Welcome → Signup (creates real account) → Upload Photo →
Basic Details → Profile Preview → **Finish Setup** (saves to Firestore) → Home.
Returning users are routed straight to Home from Splash; Login also works.

---

## Architecture (what was decided)

| Concern | Choice |
|---|---|
| Structure | feature-first: `lib/features/<feature>/{screens,data,providers,models}` + `lib/core` |
| State mgmt | **Riverpod** (`flutter_riverpod`) |
| Navigation | **go_router** (`lib/core/router/app_router.dart`, named `Routes`) |
| Backend | Firebase Auth + Cloud Firestore + Storage |
| AI provider | **Gemini** (Google AI Studio) — `lib/features/ai/services/gemini_service.dart` |
| Nearby schools/coachings | **Google Places API (New)** + Maps SDK — `lib/features/explore/services/google_places_service.dart`. Live only, no bundled data. |

Onboarding data is held in a shared Riverpod draft
(`onboarding_controller.dart`) instead of constructor-passing, so back-nav and
deep links never lose in-progress input.
