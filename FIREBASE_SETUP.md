# EduNavigate AI — Firebase Setup Guide

Follow these steps exactly. The app will crash on launch until all steps are done.

---

## PART 1 — Prerequisites (install these first)

### 1.1 Install Flutter
```bash
git clone https://github.com/flutter/flutter.git -b stable ~/flutter
echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
flutter doctor
```
All checkmarks must be green for Flutter and Xcode before continuing.

### 1.2 Install Node.js (needed for Firebase CLI)
Download from https://nodejs.org → install LTS version.

### 1.3 Install Firebase CLI
```bash
npm install -g firebase-tools
```

### 1.4 Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
echo 'export PATH="$PATH:$HOME/.pub-cache/bin"' >> ~/.zshrc
source ~/.zshrc
```

---

## PART 2 — Create Firebase Project

1. Open https://console.firebase.google.com
2. Click **"Add project"**
3. Name it: `EduNavigate AI`
4. Click Continue → disable Google Analytics (not needed now) → **Create project**
5. Wait for project to be created → click **Continue**

---

## PART 3 — Enable Firebase Services

### 3.1 Authentication
1. Left sidebar → **Authentication** → **Get started**
2. Click **Email/Password**
3. Toggle **Enable** → **Save**

### 3.2 Firestore Database
1. Left sidebar → **Firestore Database** → **Create database**
2. Select **"Start in production mode"** → Next
3. Choose location closest to your users (e.g. `asia-south1` for India) → **Enable**
4. After creation → click **Rules** tab → replace all text with:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /colleges/{id}        { allow read: if request.auth != null; allow write: if false; }
    match /schools/{id}         { allow read: if request.auth != null; allow write: if false; }
    match /coachingCenters/{id} { allow read: if request.auth != null; allow write: if false; }
    match /exams/{id}           { allow read: if request.auth != null; allow write: if false; }
    match /scholarships/{id}    { allow read: if request.auth != null; allow write: if false; }
    match /jobs/{id}            { allow read: if request.auth != null; allow write: if false; }
  }
}
```
5. Click **Publish**

### 3.3 Storage
1. Left sidebar → **Storage** → **Get started**
2. Click **Next** → choose same location as Firestore → **Done**
3. Click **Rules** tab → replace all text with:
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{file=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```
4. Click **Publish**

---

## PART 4 — Register iOS App in Firebase

1. Firebase Console → click the **iOS icon (+)** on the project overview page
2. **iOS bundle ID**: enter exactly → `com.example.myFirstApp`
3. App nickname: `EduNavigate iOS` (optional)
4. Click **Register app**
5. Click **Download GoogleService-Info.plist**
6. Click **Next** → **Next** → **Continue to console** (skip the SDK steps, already done in code)

---

## PART 5 — Place the Config File

```bash
cp ~/Downloads/GoogleService-Info.plist ~/Downloads/my_first_app/ios/Runner/
```

Verify it's there:
```bash
ls ~/Downloads/my_first_app/ios/Runner/GoogleService-Info.plist
```
Should print the file path. If "No such file" → copy failed, try again.

---

## PART 6 — Update firebase_options.dart

Run this to extract values from the plist:
```bash
/usr/libexec/PlistBuddy -c "Print :API_KEY" ~/Downloads/my_first_app/ios/Runner/GoogleService-Info.plist
/usr/libexec/PlistBuddy -c "Print :GOOGLE_APP_ID" ~/Downloads/my_first_app/ios/Runner/GoogleService-Info.plist
/usr/libexec/PlistBuddy -c "Print :GCM_SENDER_ID" ~/Downloads/my_first_app/ios/Runner/GoogleService-Info.plist
/usr/libexec/PlistBuddy -c "Print :PROJECT_ID" ~/Downloads/my_first_app/ios/Runner/GoogleService-Info.plist
/usr/libexec/PlistBuddy -c "Print :STORAGE_BUCKET" ~/Downloads/my_first_app/ios/Runner/GoogleService-Info.plist
/usr/libexec/PlistBuddy -c "Print :BUNDLE_ID" ~/Downloads/my_first_app/ios/Runner/GoogleService-Info.plist
```

Open `lib/firebase_options.dart` in any editor.

Find the `ios` section (around line 50) and replace each placeholder:

| Replace this | With value from command above |
|---|---|
| `PASTE_IOS_API_KEY_HERE` | output of API_KEY command |
| `PASTE_IOS_APP_ID_HERE` | output of GOOGLE_APP_ID command |
| `PASTE_SENDER_ID_HERE` | output of GCM_SENDER_ID command |
| `PASTE_PROJECT_ID_HERE` | output of PROJECT_ID command |
| `PASTE_STORAGE_BUCKET_HERE` | output of STORAGE_BUCKET command |
| `PASTE_IOS_BUNDLE_ID_HERE` | output of BUNDLE_ID command |

Also fill the same `PASTE_SENDER_ID_HERE`, `PASTE_PROJECT_ID_HERE`, `PASTE_STORAGE_BUCKET_HERE` in the **android** and **web** sections with the same values.

---

## PART 7 — Install Flutter packages

```bash
cd ~/Downloads/my_first_app
flutter pub get
```

Should end with: `Got dependencies.`

---

## PART 8 — Run the app

Make sure iPhone simulator is running:
```bash
open -a Simulator
```

Wait for simulator to fully boot, then:
```bash
cd ~/Downloads/my_first_app
flutter run
```

First build takes 2–3 minutes. After that, hot reload is instant.

---

## Expected Result

App launches → Splash screen → Welcome screen → Signup → Upload Photo → Basic Details → Profile Preview → Finish Setup (saves to Firestore) → Home screen.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `Lost connection to device` immediately | GoogleService-Info.plist missing or firebase_options.dart not updated |
| `firebase_options.dart` compile error | A placeholder `PASTE_..._HERE` was not replaced |
| `PERMISSION_DENIED` on signup | Email/Password auth not enabled in Firebase Console (Part 3.1) |
| `flutter: command not found` | Flutter not added to PATH — redo Step 1.1 |
| `pod install` errors | Run `cd ios && pod install && cd ..` then `flutter run` again |
