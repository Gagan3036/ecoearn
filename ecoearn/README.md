# 🌱 EcoEarn Mobile App

> **The client mobile application for the EcoEarn sustainable waste management & rewards platform.**

Built with Flutter 3.27+ and Dart 3.6+, the EcoEarn application enables users to manage their eco-friendly activities, monitor smart dustbins, authenticate securely via Firebase, and earn rewards for active recycling.

---

## 🚀 Features

- **🔐 Authentication & User Onboarding**:
  - Secure login, user registration, and password recovery (`forgot_password.dart`).
  - Form validation with `form_field_validator`.
  - Multi-platform Firebase integration (`firebase_core`, `firebase_options.dart`).
- **📱 Clean Navigation Hub**:
  - Dashboard navigation with drawer and bottom navigation bar (`home_page.dart`).
  - Seamless route management across auth screens and main feed.
- **🎨 Visual Assets**:
  - Built-in eco-friendly branding and custom background artwork (`assets/`).

---

## 📂 Source Code Structure

```text
lib/
├── firebase_options.dart   # Firebase configuration auto-generated via FlutterFire CLI
├── forgot_password.dart    # Password reset view with email recovery input
├── home_page.dart          # Primary home dashboard with navigation drawer & bottom bar
├── login.dart              # User sign-in screen with credential input & routing
├── main.dart               # App entrypoint and named routes ('login', 'register', 'forgot')
└── register.dart           # Registration view for new user sign-up
```

---

## 🛠️ Tech Stack & Dependencies

- **Flutter**: `^3.27.1` (SDK: `^3.6.0`)
- **State & UI**: Material Design 3, Cupertino Icons (`^1.0.8`)
- **Backend / Cloud**: Firebase Core (`^3.13.1`)
- **Validation**: `form_field_validator` (`^1.1.0`)

---

## ⚡ Quick Start

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Configure Firebase (if needed)
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### 3. Run Application
```bash
# Debug mode
flutter run

# Select connected target
flutter run -d chrome
flutter run -d android
```

---

## 🧪 Testing & Linting

```bash
# Run static analysis
flutter analyze

# Run unit and widget tests
flutter test
```

