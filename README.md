# Ramein Mobile

A modern, cross-platform event management application built with Flutter. Ramein Mobile provides a seamless experience for participants to discover events and for administrators to manage attendance and analytics in real-time.

## System Capabilities

### Participant Module
* **Secure Authentication:** User registration with asynchronous OTP email verification and encrypted credential management.
* **Event Discovery:** Real-time event catalog featuring keyword search and chronological sorting.
* **Token-Based Attendance:** A dual-validation system using unique 10-digit tokens and time-window restrictions to ensure physical presence.
* **Digital Certification:** Automated certificate generation with QR Code verification and local storage integration.

### Administrative Module
* **Data Analytics:** Dynamic dashboard featuring interactive charts for monthly participant trends and top-performing events.
* **Event Lifecycle Management:** Full CRUD operations for event scheduling with business logic validation (e.g., H-3 creation policy).
* **Reporting Engine:** Data export capabilities to XLS/CSV and bulk participant management tools.

## Tech Stack

* **Framework:** Flutter 3.x (Material 3 Design)
* **State Management:** Riverpod 2.x (Reactive programming)
* **Navigation:** GoRouter (Declarative routing)
* **Networking:** Dio (with Interceptors for JWT management)
* **Local Database:** Hive (NoSQL for high-performance caching)
* **Visualizations:** FL Chart (Custom interactive analytics)
* **Animations:** Flutter Animate (Micro-interactions)

## Architecture & Design

### Directory Structure
```text
lib/
├── core/               # App-wide configurations, themes, and routing
├── features/           # Domain-driven modules (Auth, Events, Admin)
│   ├── [feature]/
│   │   ├── domain/     # Business logic & models
│   │   ├── data/       # Repositories & API services
│   │   └── presentation/ # UI components & State providers
├── shared/             # Reusable widgets and common utilities
└── main.dart           # Dependency injection and app entry
```

### Design Principles
* **Atomic Design:** Reusable UI components for consistent look and feel.
* **Responsiveness:** Fluid layout system compatible with various aspect ratios.
* **Clean Architecture:** Separation of concerns between UI, business logic, and data layers.

## Development Setup

### Prerequisites
* Flutter SDK 3.7.0+
* Dart 3.0.0+
* Postman/Swagger (for API testing)

### Installation
1.  **Clone the Repository**
    ```bash
    git clone https://github.com/OwlDane/ramein-mobile.git
    cd ramein-mobile
    ```
2.  **Sync Dependencies**
    ```bash
    flutter pub get
    ```
3.  **Environment Setup**
    Configure your API base URL in `lib/core/config/env.dart`.
4.  **Run Application**
    ```bash
    flutter run
    ```

## Quality Assurance
```bash
# Execute unit and widget tests
flutter test

# Static analysis check
flutter analyze
```

## Deployment
Untuk melakukan *build* ke tahap produksi, gunakan perintah berikut:
* **Android:** `flutter build apk --release`
* **iOS:** `flutter build ios --release`

## License
Project ini dilisensikan di bawah **MIT License**.
