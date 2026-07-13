# Week 5 — Firebase Authentication & Firestore Database

Flutter Developers Internship · Cycle 2 · Week 5 Deliverable

A clean, animated Flutter app that lets a user **sign up**, **log in**, and view a **live profile screen** backed by **Firebase Authentication** (Email/Password) and **Cloud Firestore**.

---

## ✨ Features

| Requirement (from task sheet)                          | Where it's implemented |
|----------------------------------------------------------|-------------------------|
| Configure Firebase in the Flutter project                | `lib/main.dart`, `lib/firebase_options.dart` |
| Email/Password Authentication                             | `lib/services/auth_service.dart` |
| Login & Signup screens                                    | `lib/screens/login_screen.dart`, `lib/screens/signup_screen.dart` |
| Show Profile screen after successful login                | `lib/main.dart` (`AuthGate`) → `lib/screens/profile_screen.dart` |
| Store name & email in Cloud Firestore                     | `lib/services/firestore_service.dart` → `createUserProfile()` |
| Retrieve & display saved data                              | `lib/services/firestore_service.dart` → `streamUserProfile()` (live stream) |
| Error handling & loading indicators (carried over from Wk4)| `PrimaryButton` loading state, toast errors via `fluttertoast`, `_ErrorState` widget |

**Design language:** Material 3, Poppins typography (Google Fonts), an indigo → teal gradient identity, rounded 16–20px surfaces, soft shadows, and subtle entrance animations (`flutter_animate`) — chosen to feel like a modern, polished fintech/SaaS onboarding flow rather than a default Flutter template.

---

## 📁 Project Structure

```
week5_firebase_auth_app/
├── lib/
│   ├── main.dart                  # App entry point + AuthGate (routes by auth state)
│   ├── firebase_options.dart      # PLACEHOLDER — regenerate with flutterfire configure
│   ├── models/
│   │   └── app_user.dart          # Firestore user document model
│   ├── services/
│   │   ├── auth_service.dart      # Firebase Auth wrapper + friendly error messages
│   │   └── firestore_service.dart # Firestore read/write for `users` collection
│   ├── screens/
│   │   ├── login_screen.dart
│   │   ├── signup_screen.dart
│   │   └── profile_screen.dart
│   ├── widgets/
│   │   ├── custom_text_field.dart
│   │   └── primary_button.dart
│   └── theme/
│       └── app_theme.dart         # Colors, gradients, typography, component themes
├── firestore.rules                # Security rules: users can only access their own doc
├── analysis_options.yaml
├── pubspec.yaml
└── README.md
```

---

## 🔧 Prerequisites

- Flutter SDK 3.22+ (`flutter --version`)
- A free [Firebase](https://console.firebase.google.com/) account
- Node.js (only needed for the Firebase CLI)

---

## 🚀 Firebase Setup

This repo ships with a **placeholder** `lib/firebase_options.dart` so the project structure is complete, but you must connect it to your own Firebase project before running the app.

1. **Create a Firebase project**
   Go to the [Firebase Console](https://console.firebase.google.com/) → *Add project* → follow the wizard.

2. **Enable Email/Password Authentication**
   In the console: *Build → Authentication → Sign-in method → Email/Password → Enable*.

3. **Create a Firestore database**
   In the console: *Build → Firestore Database → Create database* → start in **test mode** for development (tighten rules before shipping — see `firestore.rules`).

4. **Install the CLI tools** (one-time):
   ```bash
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   firebase login
   ```

5. **Generate your real `firebase_options.dart`**
   From the project root:
   ```bash
   flutterfire configure
   ```
   Select your Firebase project and the platforms you want (Android/iOS/Web). This **overwrites** the placeholder `lib/firebase_options.dart` with your real project credentials and registers the app in Firebase.

6. **Deploy the security rules** (optional but recommended):
   ```bash
   firebase deploy --only firestore:rules
   ```

---

## ▶️ Running the App

```bash
flutter pub get
flutter run
```

Pick a connected device or emulator when prompted. On first run:

1. Tap **Sign Up**, enter your name, email, and a password (6+ characters).
2. The app creates the Firebase Auth account **and** a matching `users/{uid}` document in Firestore with your name and email.
3. You're routed straight to the **Profile screen**, which streams your saved data live from Firestore.
4. Use the logout icon in the app bar to sign out and return to Login.

---

## 🗄️ Firestore Data Model

```
users (collection)
└── {uid} (document, one per authenticated user)
    ├── name: string
    ├── email: string
    └── createdAt: string (ISO-8601 timestamp)
```

Security rules (`firestore.rules`) restrict every document so **only the owning user** can read or write it:

```js
match /users/{userId} {
  allow read, write: if request.auth != null && request.auth.uid == userId;
}
```

---

## 🧪 Error Handling

`AuthService.friendlyError()` maps raw `FirebaseAuthException` codes (e.g. `wrong-password`, `email-already-in-use`, `weak-password`, `network-request-failed`) to human-readable messages shown via toast, so the UI never surfaces raw Firebase error strings to the user.

---

## 📦 Key Dependencies

| Package | Purpose |
|---|---|
| `firebase_core`, `firebase_auth`, `cloud_firestore` | Firebase Authentication + Firestore |
| `google_fonts` | Poppins typography |
| `flutter_animate` | Entrance/transition animations |
| `fluttertoast` | Non-blocking error/status toasts |

---
