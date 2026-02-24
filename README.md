# 🛒 E-Commerce App

![CI](https://github.com/JohnsonChong0123/e_commerce_client/actions/workflows/flutter_ci.yml/badge.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.38.9-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-blue?logo=dart)

> ⚠️ **Work in Progress** — Actively under development.

A Flutter e-commerce mobile application built with **Clean Architecture** and **BLoC** state management, following **Test-Driven Development (TDD)** methodology.

---

## 🎯 Project Purpose

This project is a hands-on practice of production-level Flutter engineering:

- **Clean Architecture** — strict separation of `data`, `domain`, and `presentation` layers
- **Test-Driven Development (TDD)** — tests written before implementation
- **CI/CD** — automated testing, signed APK builds, and artifact uploads via GitHub Actions

---

## ✨ Features

| Feature | Status |
|---|---|
| Firebase Authentication (Email/Password) | ✅ Done |
| Google Sign-In | ✅ Done |
| Facebook Sign-In | ✅ Done |
| CI/CD Pipeline | ✅ Done |
| Product Listing | ✅ Done |
| Shopping Cart | ⏳ In Progress |
| Order Management | 📋 Planned |

---

## 🔧 Tech Stack

| Category | Package |
|---|---|
| State Management | `flutter_bloc` ^9.1.1 |
| Dependency Injection | `get_it` ^9.2.0 |
| Networking | `dio` ^5.9.1, `http` ^1.6.0 |
| Navigation | `go_router` ^17.1.0 |
| Auth | `google_sign_in`, `flutter_facebook_auth` |
| Secure Storage | `flutter_secure_storage` ^10.0.0 |
| Functional Programming | `fpdart` ^1.2.0 |
| Environment Variables | `flutter_dotenv` ^6.0.0 |
| Testing | `mocktail`, `bloc_test` |

---

## 🧪 Testing

This project strictly follows TDD — every feature starts with a failing test.

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

Test types covered:
- Unit tests (use cases, repositories)
- BLoC tests (`bloc_test`)

---

## 🚀 CI/CD Pipeline

Every push to `main` and every pull request triggers the full pipeline:

1. **Install Dependencies** — `flutter pub get` with dependency caching
2. **Run Tests** — `flutter test`
3. **Build Signed Release APK** — signed with release keystore via GitHub Secrets
4. **Upload APK** — artifact uploaded and available for download from GitHub Actions

Secrets managed in GitHub Actions:
- `RELEASE_KEYSTORE_BASE64` — Android signing keystore
- `KEYSTORE_PASSWORD`, `KEY_PASSWORD`, `KEY_ALIAS` — signing credentials
- `FACEBOOK_APP_ID`, `FACEBOOK_CLIENT_TOKEN` — Facebook Auth
- `GOOGLE_CLIENT_ID` — Google Sign-In
- `SERVER_URL` — Backend API endpoint

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `3.38.9`
- Dart SDK `^3.10.8`
- Android Studio / Xcode (for emulator)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/JohnsonChong0123/e_commerce_client.git
cd e_commerce_client

# 2. Set up environment variables
cp .env.example .env
# Fill in your credentials in .env

# 3. Install dependencies
flutter pub get

# 4. Run the app
flutter run
```

### Environment Variables

```env
GOOGLE_CLIENT_ID=your_google_client_id
SERVER_URL=your_backend_api_url
```

---

## 📝 Note

This is a **learning and portfolio project** — built to practice real-world Flutter architecture and engineering best practices. Feel free to explore the code and tests!