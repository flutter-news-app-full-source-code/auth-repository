<div align="center">
  <img src="https://avatars.githubusercontent.com/u/202675624?s=400&u=dc72a2b53e8158956a3b672f8e52e39394b6b610&v=4" alt="Flutter News App Toolkit Logo" width="220">
  <h1>Auth Repository</h1>
  <p><strong>A repository that provides an abstraction layer over authentication operations for the Flutter News App Toolkit.</strong></p>
</div>

<p align="center">
  <img src="https://img.shields.io/badge/coverage-100%25-green?style=for-the-badge" alt="coverage">
  <a href="https://flutter-news-app-full-source-code.github.io/docs/"><img src="https://img.shields.io/badge/LIVE_DOCS-VIEW-slategray?style=for-the-badge" alt="Live Docs: View"></a>
  <a href="https://github.com/flutter-news-app-full-source-code"><img src="https://img.shields.io/badge/MAIN_PROJECT-BROWSE-purple?style=for-the-badge" alt="Main Project: Browse"></a>
</p>

This `auth_repository` package contains the `AuthRepository` class, which acts as an abstraction layer over an `AuthClient` implementation (from the `auth_client` package) within the [**Flutter News App Full Source Code Toolkit**](https://github.com/flutter-news-app-full-source-code). Its primary purpose is to provide a clean, business-focused interface for authentication flows, ensuring standardized exception propagation, and handling authentication token persistence using `KvStorageService`. This repository effectively decouples the application's core logic from the specifics of authentication mechanisms and token storage.

## ⭐ Feature Showcase: Business-Focused Authentication Management

This package offers a comprehensive set of features for managing authentication operations.

<details>
<summary><strong>🧱 Core Functionality</strong></summary>

### 🚀 `AuthRepository` Class
- **`AuthRepository`:** Provides a clean, business-focused interface for authentication-related tasks, abstracting the underlying `AuthClient` implementation.
- **Complete Authentication Lifecycle:** Offers methods for a full authentication lifecycle, including `authStateChanges` (stream of user authentication state), `getCurrentUser` (retrieves current user), `requestSignInCode` (initiates email+code sign-in), `verifySignInCode` (verifies code, saves token, returns user), `signInAnonymously` (signs in anonymously, saves token, returns user), and `signOut` (signs out user, clears token).

### 🌐 Token Persistence Management
- **`KvStorageService` Integration:** Manages authentication token persistence internally using an injected `KvStorageService`.
- **Direct Token Access:** Exposes `saveAuthToken(String token)`, `getAuthToken()`, and `clearAuthToken()` for direct token manipulation, though these are typically handled by the main authentication flow methods.

### 🛡️ Standardized Error Handling
- **Exception Propagation:** Propagates standardized `HttpException`s (from `core`) from the underlying client and `StorageException`s (from `kv_storage_service`), ensuring consistent and predictable error management across the application layers.

### 💉 Dependency Injection Ready
- **`AuthClient` & `KvStorageService` Dependencies:** Requires instances of `AuthClient` (from `auth_client`) and `KvStorageService` (from `kv_storage_service`) via its constructor, promoting loose coupling and testability.

> **💡 Your Advantage:** This package provides a business-focused abstraction for authentication operations, simplifying the integration of user authentication into your application logic. It ensures consistent error handling, manages token persistence, and decouples your core application from specific authentication and storage implementations, enhancing maintainability and flexibility.

</details>

## 🔑 Licensing

This `auth_repository` package is an integral part of the [**Flutter News App Full Source Code Toolkit**](https://github.com/flutter-news-app-full-source-code). For comprehensive details regarding licensing, including trial and commercial options for the entire toolkit, please refer to the main toolkit organization page.
