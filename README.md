# Open Path

A mobile learning management system (LMS) built with **Flutter**. Open Path lets learners browse courses, enroll, watch video lessons, take quizzes, and track their learning progress — all from a single, polished cross-platform app.

> **Mission:** accessible, high-quality education for everyone. Knowledge should be free and easy to reach.

---

## Goals

- Deliver a fast, intuitive mobile LMS experience on Android, iOS, and web.
- Provide a complete learning loop: **discover → enroll → learn → assess → track**.
- Keep authentication simple and secure with JWT tokens that auto-refresh.
- Make course content easy to consume with YouTube-hosted video lessons.
- Keep learners engaged with interactive quizzes, progress tracking, and push notifications.
- Lay a foundation for monetization (paid courses) via payment-gateway integration.

## Use Cases

| Who | What they can do |
|-----|------------------|
| New visitor | Browse the course catalog, view course details, sign up for an account |
| Registered learner | Log in, enroll in courses, watch lessons, mark lessons complete |
| Active student | Take quizzes, see quiz scores and past attempts, track progress per course |
| Returning user | See "My Courses", trending courses, continue learning, get notified |
| Any user | Edit profile, manage notifications, read about the app, log out |

## Current Features

- **Auth** — register, login, logout with JWT stored in `flutter_secure_storage`
- **Course catalog** — browse all courses, trending courses, and search
- **Enrollment** — enroll in a course with an `APPROVED`/`PENDING` status workflow
- **Video lessons** — YouTube-powered playback with lesson content and completion tracking
- **Quizzes** — radio-list questions, score review, and attempt history
- **Progress** — profile stats (enrolled vs. actively learning) and "Currently Learning" rail
- **Notifications** — Firebase Cloud Messaging + local notifications, in-app history
- **Theming** — full light/dark mode with system theme detection
- **UX polish** — skeleton loading, slide/fade route transitions, floating bottom bar

---

## Tech Specs

### Platform & Tooling

| Area | Choice |
|------|--------|
| Language / SDK | Dart SDK `^3.12.2`, Flutter framework |
| Minimum target | Android, iOS, Web |
| State management | `StatefulWidget` + `setState()` (no external state lib) |
| Navigation | `go_router ^17.3.0` |
| HTTP client | `dio ^5.10.0` (+ `cookie_jar`, `dio_cookie_manager`) |
| Serialization | `json_annotation` + `json_serializable` / `build_runner` |
| Linting | `flutter_lints ^6.0.0` |

### Dependencies (from `pubspec.yaml`)

| Package | Version | Purpose |
|---------|---------|---------|
| `dio` | ^5.10.0 | HTTP requests with interceptors |
| `go_router` | ^17.3.0 | Declarative routing & navigation |
| `skeletonizer` | ^2.1.3 | Skeleton loading placeholders |
| `youtube_player_flutter` | ^10.0.1 | YouTube video player |
| `flutter_secure_storage` | ^10.3.1 | Secure JWT storage |
| `font_awesome_flutter` | ^11.0.0 | Icon set |
| `flutter_styled_toast` | ^2.3.0 | Toast notifications |
| `flutter_floating_bottom_bar` | ^2.0.2 | Floating bottom nav bar |
| `cookie_jar` / `dio_cookie_manager` | ^4.0.9 / ^3.4.0 | Cookie persistence |
| `firebase_core` | ^4.12.1 | Firebase bootstrap |
| `firebase_messaging` | ^16.4.3 | Push notifications (FCM) |
| `flutter_local_notifications` | ^22.1.0 | Local notification display |
| `image_picker` | ^1.1.2 | Profile image picking |
| `path_provider` | ^2.1.6 | Filesystem paths |
| `flutter_launcher_icons` | ^0.14.4 | App icon generation |
| `cupertino_icons` | ^1.0.8 | iOS-style icons |

### Security

- JWT access token stored in **Keychain/Keystore** via `flutter_secure_storage`.
- Automatic `401 → /auth/refresh` flow; failed refresh redirects to `/login`.
- No secrets or credentials committed to the repository.

---

## Design & Architecture

### Layered architecture

```
Views (UI) → Controllers → Repositories → APIService (Dio) → Backend API
```

- **Views** (`lib/views/`) — screens and pages, pure Flutter UI with `setState()`.
- **Controllers** (`lib/controllers/`) — orchestrate UI logic and call repositories.
- **Repositories** (`lib/repositories/`) — map HTTP responses into models.
- **APIService** (`lib/core/services/api_service.dart`) — Dio wrapper that injects the JWT header and transparently retries once after a token refresh on `401`.
- **Models** (`lib/models/`) — `json_serializable` DTOs (plus plain manual parsing where needed).

### App boot flow

1. `main()` initializes Firebase (`firebase_options.dart`).
2. `NotificationService` requests permission, sets up local notifications, and registers FCM handlers.
3. `appRouter` (`go_router`) redirects `/` → `/login` or `/home` based on stored token.
4. `Home` hosts a 3-tab floating bottom bar (My Courses / Browse / Profile).

### Routing model

`go_router` with `CustomTransitionPage` builders: slide+fade for pushes, fade for the auth/home shell. Deep-linking is supported from push notifications via a `route` payload.

### Key flows

- **Token refresh** — any `GET/POST/PUT/PATCH/DELETE` returning `401` calls `/auth/refresh`, saves the new token, and retries the original request.
- **Notifications** — FCM foreground messages show a local notification; tapping any notification (foreground/background/terminated) routes the user via the `route` data payload.

### Project structure

```
lib/
├── main.dart                        # App entry, Firebase init, router config
├── firebase_options.dart            # Platform Firebase config
├── controllers/                     # Auth, Course, Lesson, User controllers
├── core/
│   ├── configs/routes/              # go_router route definitions & transitions
│   ├── constants/                   # API base URL constant
│   ├── services/                    # APIService, NotificationService, SecureStorageService
│   ├── theme/                       # AppTheme light/dark + AppColors
│   └── widgets/                     # CourseCard, LessonCard, ShimmerLoading
├── models/                          # AuthModel, UserModel, CourseModel, LessonModel
├── repositories/                    # CourseAPI, LessonAPI, NotificationAPI, UserAPI
└── views/                           # All screens & pages
    └── pages/                       # HomePage, CoursePage, ProfilePage (tab bodies)
```

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart SDK `^3.12.2`)
- [Firebase project](https://console.firebase.google.com/) with Android & iOS apps configured

### Installation

```bash
flutter pub get
```

### Firebase setup

Place the platform config files in their respective locations:

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

The Dart initialization config is already generated in `lib/firebase_options.dart`.

### API configuration

The app connects to a backend at:

```
https://mxs008p0-3001.asse.devtunnels.ms/api
```

Configured in `lib/core/services/api_service.dart`. To point to a different server, update the `baseUrl` field in that file.

### Run

```bash
flutter run
```

For web:

```bash
flutter run -d chrome
```

---

## Scripts

| Command | Description |
|---------|-------------|
| `flutter pub get` | Install dependencies |
| `flutter run` | Run on connected device/emulator |
| `flutter analyze` | Static analysis & linting |
| `flutter test` | Run the test suite |
| `dart run build_runner build --delete-conflicting-outputs` | Regenerate JSON serialization code |
| `dart run flutter_launcher_icons` | Generate app icons |

---

## Routes

| Path | View | Description |
|------|------|-------------|
| `/` | — | Auth guard; redirects to `/login` or `/home` |
| `/login` | Login | Email/password sign in |
| `/signup` | SignUp | User registration |
| `/home` | Home | Shell with 3-tab floating bottom bar |
| `/home` (tab 0) | HomePage | My Courses + Trending + Search |
| `/home` (tab 1) | CoursePage | Browse all courses |
| `/home` (tab 2) | ProfilePage | Profile, stats, enrollments, settings |
| `/course/:courseId` | CourseDetail | Course info + lessons + quiz |
| `/lesson/:lessonId` | LessonDetail | YouTube player + content |
| `/quiz/:quizId` | Quiz | Quiz with radio-list questions |
| `/quiz_scores/:quizId` | QuizScores | Past quiz attempts & scores |
| `/edit_profile` | EditProfile | Update name/email/password/avatar |
| `/notifications` | NotificationPage | Push notification history |
| `/about_us` | AboutUs | App info & mission |

---

## API Endpoints Consumed

| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/auth/register` | Register |
| POST | `/auth/login` | Login |
| POST | `/auth/logout` | Logout |
| POST | `/auth/refresh` | Refresh JWT |
| GET | `/user/profile` | Get profile |
| PUT | `/user/profile` | Update profile |
| PUT | `/user/fcm-token` | Register FCM token |
| GET | `/courses` | All courses (supports `?search=`) |
| GET | `/courses/trending` | Trending courses |
| GET | `/courses/:id` | Course detail |
| GET | `/courses/enrollments` | My enrollments |
| POST | `/courses/enroll/:courseId` | Enroll |
| GET | `/lessons/course/:courseId` | Course lessons |
| GET | `/lessons/:lessonId` | Lesson detail |
| POST | `/lessons/:lessonId/complete` | Mark complete |
| PUT | `/lessons/:lessonTrackId` | Update progress |
| GET | `/quizzes/:quizId` | Get quiz |
| POST | `/quizzes/submit/:quizId` | Submit quiz |
| GET | `/quizzes/attempts/:quizId` | Quiz attempt history |

---

## Roadmap & Future Plan

### Payment integration (planned)

Courses already carry a `price` field, so monetization is the next big milestone.

1. **Gateway selection & checkout**
   - Add a payments layer supporting **Stripe** (Cards, Apple Pay, Google Pay) and **PayPal**.
   - For local markets, evaluate **Khalti**, **eSewa**, and other regional wallets.
   - Server-side checkout session → client confirmation flow (keep card data off-device).

2. **Paid enrollment**
   - Wire enrollment to payment success: auto-approve enrollments after a confirmed purchase.
   - Handle pending/unpaid enrollments with clear status messaging in the UI.

3. **Receipts & order history**
   - New models/screens for order history, receipts, and downloadable invoices.

4. **Free vs. paid courses**
   - UI badges for `FREE` vs. paid courses; lock lessons/quizzes behind a `PURCHASED` check.

### Other planned work

- **Offline learning** — cache lessons/quiz content for offline viewing with `drift`/`sqflite` or local JSON.
- **Watch-time progress** — persist lesson playback position and auto-complete lessons at threshold.
- **Certificates** — generate and share course completion certificates.
- **Social learning** — discussion threads, Q&A, and reviews per course/lesson.
- **Admin/authoring tooling** — a companion web dashboard for managing courses, lessons, quizzes, and payments.
- **Robust state management** — migrate from `setState()` to Riverpod/Bloc as the app grows.
- **Push notification preferences** — per-category opt-in/out for notifications.
- **CI/CD** — GitHub Actions for lint, test, build, and store deployment (App Store Connect / Play Console).
