# CPD Hub

A modern **Flutter + Go** application for the **Competitive Programming Division (CPD)** — track problems, contests, leaderboards, user profiles, daily challenges, attendance, and performance insights all in one place.  
Used by **30+ CPD members** and **100+ community users**.

## Features

- **Home Dashboard** — Welcome greeting, upcoming contests carousel, daily challenge, live activity feed, and trending problems
- **Problems** — Browse, search, and filter problems by difficulty (Easy / Medium / Hard) with like/dislike and solved status
- **Contests** — View upcoming and past contests with details (date, duration, problem count, participants) and contest leaderboards
- **Community** — Search members, sort by rating/name/rank, view top contributors, and visit any user's profile
- **Profile** — Personal stats (rating, rank, division, solved count), coding heatmap, rating history graph, attendance tracking, recent submissions, social links, and settings
- **Activity Tracking** — Monitor daily problem-solving consistency and contest performance
- **Event Reminders** — Get notified about upcoming contests, meetings, and coding events
- **Proportional Scaling** — Three display sizes (Small, Normal, Large) that scale all UI elements proportionally
- **Floating Nav Bar** — Glassmorphic bottom navigation with blur effect, animated icon transitions, and active state pill
- **SVG Brand System** — Custom vector logo (mark + full wordmark) rendered with `flutter_svg`
- **Dark Theme** — Fully dark UI with green accent (`#28C76F`)

## Architecture

The project follows **Clean Architecture** with the BLoC pattern:

```
lib/
├── core/                   # Shared utilities, theme, constants, DI
│   ├── theme/              # AppTheme, ThemeCubit, scaling extensions
│   ├── widgets/            # Reusable widgets (AppLogo)
│   ├── injection.dart      # Dependency injection
│   ├── ui_constants.dart   # Colors, styles
│   └── url_constants.dart  # API endpoints
├── future/
│   ├── auth/               # Authentication (login, signup)
│   │   └── presentation/
│   └── main/               # Core app features
│       ├── data/           # Models, data sources, repository impl
│       ├── domain/         # Entities, repository contracts, use cases
│       └── presentation/   # BLoC/Cubit, pages, widgets
└── main.dart
```

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter (Dart) |
| Backend | Go (REST API) |
| Database | PostgreSQL |
| Auth & Hosting | Supabase |
| State Management | `flutter_bloc` |
| Functional Programming | `dartz` |
| Charts | `fl_chart` |
| Networking | `http` |
| SVG Rendering | `flutter_svg` |
| Connectivity | `internet_connection_checker` |
| Internationalization | `intl` |

---

## Getting Started

### Prerequisites

- Flutter SDK `^3.8.1`
- Dart SDK `^3.8.1`

### Installation

```bash
git clone https://github.com/Bereke1t2/CPD_HUB.git
cd CPD_HUB
flutter pub get
flutter run
```

## Screenshots

| Home | Problems | Contests | Profile |
|---|---|---|---|
| Dashboard with daily challenge & activity | Search & filter by difficulty | Upcoming & past contests | Stats, heatmap, rating graph |

## Project Stats

- **97 Dart files** across data, domain, and presentation layers
- **Clean Architecture** with separated concerns
- **6 BLoC/Cubits** — Home, Problems, Contests, Leaderboard, Users, Profile
- **Proportional scaling** across every widget and page

## Author

**Bereket** — [github.com/Bereke1t2](https://github.com/Bereke1t2)

## License

This project is for educational and personal use.
