# Open Path

A mobile learning management system (LMS) built with Flutter. Browse courses, enroll, watch video lessons, take quizzes, and track progress.

## Tech Stack

- **Framework:** Flutter (Dart SDK ^3.12.2)
- **HTTP Client:** Dio
- **Routing:** go_router
- **Auth:** JWT (stored via flutter_secure_storage) with automatic token refresh
- **Video:** youtube_player_flutter
- **Push:** Firebase Cloud Messaging + flutter_local_notifications
- **Code Gen:** json_serializable / build_runner

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Firebase project](https://console.firebase.google.com/) with Android & iOS apps configured

### Installation

```bash
flutter pub get
```

### Firebase Setup

Place the Firebase config files in their respective locations:
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

The Dart initialization config is already in `lib/firebase_options.dart`.

### API Configuration

The app connects to a backend at `https://mxs008p0-3001.asse.devtunnels.ms/api` (configured in `lib/core/services/api_service.dart`). To point to a different server, update the `baseUrl` in that file.

### Run

```bash
flutter run
```

For web:

```bash
flutter run -d chrome
```

## Architecture

```
Views (UI) → Controllers → Repositories → APIService (Dio) → Backend API
```

- **Views** — screens and pages (under `lib/views/`)
- **Controllers** — orchestrate UI logic and call repositories
- **Repositories** — make HTTP requests via `APIService`
- **APIService** — Dio wrapper with automatic JWT injection and 401 refresh

All state is managed locally with `StatefulWidget` + `setState()` (no external state management).

## Routes

| Path | View | Description |
|------|------|-------------|
| `/login` | Login | Email/password sign in |
| `/signup` | SignUp | User registration |
| `/home` | Home | Shell with 3-tab bottom bar |
| `/home` (tab 0) | HomePage | My Courses + Trending |
| `/home` (tab 1) | CoursePage | Browse all courses |
| `/home` (tab 2) | ProfilePage | Profile, enrollments, settings |
| `/course/:courseId` | CourseDetail | Course info + lessons + quiz |
| `/lesson/:lessonId` | LessonDetail | YouTube player + content |
| `/quiz/:quizId` | Quiz | Quiz with radio-list questions |
| `/edit_profile` | EditProfile | Update name/email/password |
| `/notifications` | NotificationPage | Push notification history |
| `/about_us` | AboutUs | App info |

## Project Structure

```
lib/
├── main.dart
├── firebase_options.dart
├── controllers/       # Auth, Course, Lesson, User controllers
├── core/
│   ├── configs/routes/  # go_router route definitions
│   ├── constants/       # API base URL constant
│   ├── services/        # APIService, NotificationService, SecureStorageService
│   └── widgets/         # Reusable CourseCard, LessonCard
├── models/             # AuthModel, UserModel, CourseModel, LessonModel (JSON serializable)
├── repositories/       # CourseAPI, LessonAPI, NotificationAPI, UserAPI
└── views/              # All screens and pages
    └── pages/          # HomePage, CoursePage, ProfilePage (tab bodies)
```

## Scripts

| Command | Description |
|---------|-------------|
| `flutter pub get` | Install dependencies |
| `flutter run` | Run on connected device/emulator |
| `dart run build_runner build` | Generate JSON serialization code |
| `dart run flutter_launcher_icons` | Generate app icons |

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
| GET | `/courses` | All courses |
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
