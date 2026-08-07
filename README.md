# 🧭 CPD Hub — Competitive Programming Management Ecosystem

[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Backend Framework](https://img.shields.io/badge/Backend-Go_%2F_Gin-00ADD8?logo=go&logoColor=white)](https://gin-gonic.com)
[![Database](https://img.shields.io/badge/Database-PostgreSQL_16-4169E1?logo=postgresql&logoColor=white)](https://www.postgresql.org)
[![Architecture](https://img.shields.io/badge/Architecture-Clean_%2F_Hexagonal-ff69b4)](#-architecture--design-patterns)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Status](https://img.shields.io/badge/Status-Active_Development-brightgreen)](#)

> **CPD Hub** is an enterprise-grade, full-stack Competitive Programming management platform engineered for the **Computer Science & Engineering Club (CSEC) Competitive Programming Division (CPD)**. It empowers **30+ core division members** and **100+ active community developers** to streamline daily problem-solving consistency, track rating progressions, monitor live contest leaderboards, and master structured algorithmic learning tracks.

---

## 🌟 Core Capabilities & Features

### 1. 📊 Consistency & Activity Analytics
- **GitHub-Style Contribution Heatmaps**: Visualizes daily problem-solving submissions over a 365-day rolling window.
- **Streak & Goal Engine**: Custom daily target setting (e.g., 2 problems/day) with automatic streak protection and maintenance logic.
- **Rating Progression Graphs**: Interactive historical rating performance charts for competitive programming platforms.
- **Attendance & Event Tracker**: Member check-ins and session attendance recording for division workshops.

### 2. 🏆 Contest Hub & Live Standings
- **Multi-Platform Contest Aggregation**: Syncs upcoming & historical contests from Codeforces, LeetCode, AtCoder, CodeChef, and Kontests API.
- **Real-Time Leaderboard Synchronizer**: High-performance TTL-cached standings fetched live from Codeforces API with rank, penalty, and problem-by-problem status.
- **Participation Manager**: One-tap contest registration, reminders, and post-contest performance reviews.

### 3. 📚 Structured Learning & Course Tracks
- **Curated Algorithmic Topics**: Complete coverage across Data Structures, Dynamic Programming, Graph Theory, String Algorithms, and Mathematics.
- **Prerequisite Graphs**: Directed acyclic graph (DAG) mapping topic dependencies so learners progress logically.
- **Video & Reading Modules**: Embedded video tutorials, CP-Algorithms guides, USACO Guide references, and interactive quizzes.

### 4. 🧠 Smart Practice & Spaced Repetition Queue
- **Spaced Repetition Review Queue**: Algorithm-driven problem review intervals to maximize long-term retention of key concepts.
- **Upsolving Manager**: Automatic queueing of unsolved contest problems for post-contest practice.
- **Problem Bookmark & Tagging**: Organize problems by personal difficulty, rating tags, or custom collections.

### 5. 📰 Articles Feed & Division Announcements
- **Editorial & Tutorial Feed**: Curated articles covering contest solutions, algorithm deep-dives, and division announcements.
- **Codeforces Blog Integration**: Live ingestion of top competitive programming blogs and editorial breakdowns.

---

## 🏗️ System Architecture & Design Patterns

The project is architected following **Clean Architecture (Hexagonal Architecture)** principles on both the frontend and backend to guarantee strict separation of concerns, high testability, and decoupled transport/persistence mechanisms.

```mermaid
flowchart TB
    subgraph Frontend["📱 Mobile Frontend (Flutter + BLoC)"]
        UI["UI Components & Pages"]
        BLoC["BLoC / State Management"]
        DomainFE["FE Domain (Entities & UseCases)"]
        DataFE["FE Data Layer (Repositories & Dio Client)"]
        UI --> BLoC --> DomainFE --> DataFE
    end

    subgraph Backend["⚡ Backend Ecosystem (Go / Gin Framework)"]
        Gateway["REST API Router & Middleware\n(Rate Limiter, CORS, JWT Auth)"]
        Delivery["Delivery Layer (HTTP Handlers)"]
        UseCase["UseCase Layer (Business Rules & Domain Services)"]
        DomainBE["Core Entities & Interfaces"]
        Infra["Infrastructure Layer (PG Drivers & External Clients)"]
        
        Gateway --> Delivery --> UseCase
        UseCase --> DomainBE
        UseCase --> Infra
    end

    subgraph External["🌐 External Integrations & Storage"]
        PG[("PostgreSQL 16\n(Neon DB Serverless)")]
        CF["Codeforces API"]
        Kontests["Kontests API"]
        Cache[("In-Memory TTL Cache")]
    end

    DataFE <== "HTTPS / REST (JSON)" ==> Gateway
    Infra --> PG
    Infra --> CF
    Infra --> Kontests
    Infra --> Cache
```

### Clean Architecture Layers
1. **Domain Layer**: Contains pure business entities, value objects, domain logic, and abstract repository contracts. Has zero external dependencies.
2. **UseCase / Application Layer**: Encapsulates feature-specific business workflows (e.g., user signup, contest ranking recalculation, spaced repetition scheduling).
3. **Data / Infrastructure Layer**: Implements repository contracts, handles SQL database persistence via `pgxpool`, external HTTP client integrations, and secure local token storage.
4. **Presentation / Delivery Layer**: Manages state transitions using BLoC on the client and Gin HTTP route handlers / middleware on the server.

---

## 📱 Mobile Application Tech Stack & Patterns

| Technology / Library | Purpose & Rationale |
|----------------------|---------------------|
| **Flutter 3.x / Dart 3.x** | Cross-platform UI engine targeting Android, iOS, Web, and Desktop with native performance. |
| **`flutter_bloc` (v9.x)** | Predictable, event-driven state management separating UI rendering from business logic. |
| **`get_it`** | High-performance Service Locator for compile-time dependency injection. |
| **`dio` (v5.x)** | Network client configured with Auth interceptors, error mapping, dynamic base URL resolution, and optional HTTP logging. |
| **`flutter_secure_storage`** | Keychain (iOS) and Keystore (Android) encrypted token persistence. |
| **`dartz`** | Functional programming primitives (`Either<Left, Right>`) for explicit, type-safe error handling. |
| **`equatable`** | Value-equality comparisons for immutable BLoC states and domain entities. |

### Mobile Project Structure
```text
lib/
├── core/
│   ├── config/          # Environment configuration (AppConfig, dart-define)
│   ├── error/           # Typed AppException definitions
│   ├── network/         # Dio client, Interceptors, NetworkInfo
│   ├── storage/         # TokenStore & secure local storage
│   └── url_constants.dart # Centralized API route mappings
└── features/
    ├── auth/            # Login, Signup, Token Refresh BLoCs & DataSources
    ├── articles/        # Editorial feeds & Codeforces blog integration
    ├── courses/         # Video lessons & progress tracking
    ├── learning/        # Algorithmic topics & DAG prerequisite viewer
    ├── practice/        # Review queue & Spaced Repetition logic
    └── settings/        # User preferences & Help/Support
```

---

## ⚡ Backend Microservices & Infrastructure

| Layer / Dependency | Technology & Function |
|--------------------|-----------------------|
| **Language / Engine** | **Go 1.22+** delivering high-concurrency, low-latency execution with garbage collection optimized for microservices. |
| **HTTP Web Framework** | **Gin Framework** with custom panic recovery, structured JSON logger, security headers, rate limiting, and CORS middleware. |
| **Database & Pooling** | **PostgreSQL 16 (Neon Serverless)** accessed via `pgxpool` connection pool for efficient query execution. |
| **Security & Auth** | **JWT (HMAC-SHA256)** authentication with access tokens (24h) and refresh tokens (30d) plus Bcrypt password hashing. |
| **External API Ingestion**| Concurrent client fetching from **Kontests API** and **Codeforces Standings API** with in-memory TTL caching. |

### Backend Folder Layout (`cpd-hub-backend`)
```text
cmd/
└── server/             # Entrypoint main.go & environment loader
internal/
├── delivery/
│   └── httpdelivery/   # REST HTTP handlers, routes, middleware, and validation
├── domain/             # Entities, app error definitions, and interface contracts
├── usecase/            # Business logic (Auth, Activity, Contests, Practice)
└── infrastructure/
    ├── config/         # App configuration & env loader
    ├── external/       # Codeforces & Kontests clients + TTL Cache
    ├── postgres/       # SQL queries, migrations, and db connection pool
    └── security/       # JWT token generation, parsing, and bcrypt utilities
```

---

## 🛠️ Prerequisites & System Requirements

Before setting up the environment, verify that your machine satisfies the software dependencies below:

| Requirement | Minimum Version | Installation / Verification Command |
|-------------|-----------------|--------------------------------------|
| **Flutter SDK** | `3.19.0+` | `flutter --version` |
| **Dart SDK** | `3.3.0+` | `dart --version` |
| **Go Compiler** | `1.22.0+` | `go version` |
| **PostgreSQL** | `16.0+` (or Docker) | `psql --version` or `docker compose version` |
| **Android SDK / ADB** | API Level 34 | `adb version` |
| **Git** | `2.40+` | `git --version` |
