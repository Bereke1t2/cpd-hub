# CPD Hub — Backend API Reference

> **Base URL** `https://api.cpdhub.io/api`  
> **Auth** Bearer JWT — attach to every authenticated request:  
> `Authorization: Bearer <access_token>`  
> All request/response bodies are `application/json`.  
> All timestamps are ISO 8601 UTC strings (e.g. `"2026-06-23T14:00:00Z"`).

---

## Table of Contents

1. [Authentication](#1-authentication)
2. [Problems](#2-problems)
3. [Contests](#3-contests)
4. [Users & Profiles](#4-users--profiles)
5. [Consistency — Streaks & Goals](#5-consistency--streaks--goals)
6. [Ladders (Problem Ladder)](#6-ladders)
7. [Learning — Topics & Tracks](#7-learning--topics--tracks)
8. [Courses](#8-courses)
9. [Smart Practice (Spaced Repetition + Upsolving)](#9-smart-practice)
10. [Articles Feed](#10-articles-feed)
11. [Activity & Info](#11-activity--info)
12. [Error Responses](#12-error-responses)

---

## 1. Authentication

### POST `/auth/login`

Sign in with email and password.

**Request**
```json
{
  "email": "bereket@example.com",
  "password": "secret123"
}
```

**Response `200`**
```json
{
  "token": "eyJhbGci...",
  "refresh": "eyJhbGci...",
  "user": {
    "id": "usr_abc",
    "username": "bereke1t2",
    "fullName": "Bereket Aschalew",
    "email": "bereket@example.com"
  }
}
```

---

### POST `/auth/signup`

Register a new account.

**Request**
```json
{
  "fullName": "Bereket Aschalew",
  "email": "bereket@example.com",
  "password": "secret123",
  "confirmPassword": "secret123"
}
```

> `username` is optional in the request; the backend may derive it from the email  
> or accept it as an additional field once the schema is extended.

**Response `201`**
```json
{
  "token": "eyJhbGci...",
  "refresh": "eyJhbGci...",
  "user": {
    "id": "usr_abc",
    "username": "bereke1t2",
    "fullName": "Bereket Aschalew",
    "email": "bereket@example.com"
  }
}
```

---

### POST `/auth/logout`

Invalidate the current token server-side.

**Request** — no body, auth header required.

**Response `204`** — no body.

---

### GET `/auth/me`

Return the currently authenticated user.  
_(Currently not implemented in the Go backend — the app reads from local cache.  
Add this endpoint to eliminate the local-cache dependency.)_

**Response `200`**
```json
{
  "id": "usr_abc",
  "username": "bereke1t2",
  "fullName": "Bereket Aschalew",
  "email": "bereket@example.com",
  "codeforcesHandle": "bereke1t2",
  "avatarUrl": "https://cdn.cpdhub.io/avatars/usr_abc.png",
  "rating": 1450,
  "rank": "Expert",
  "division": "2"
}
```

---

### POST `/auth/refresh`

Exchange a refresh token for a new access token.

**Request**
```json
{ "refresh": "eyJhbGci..." }
```

**Response `200`**
```json
{
  "token": "eyJhbGci...",
  "refresh": "eyJhbGci..."
}
```

---

## 2. Problems

### GET `/problems`

Return all problems visible to the authenticated user.  
Auth-aware: `isLiked`, `isDisliked`, `isSolved` reflect the current user's state.

**Query params**

| Param | Type | Description |
|-------|------|-------------|
| `difficulty` | `string` | Filter by `Easy`, `Medium`, `Hard` |
| `tag` | `string` | Filter by topic tag (e.g. `dp`, `graphs`) |
| `search` | `string` | Full-text search on title |
| `page` | `int` | 1-based page number (default `1`) |
| `limit` | `int` | Items per page (default `20`, max `100`) |

**Response `200`**
```json
[
  {
    "problemId": "cf-1234A",
    "title": "Two Sum",
    "difficulty": "Easy",
    "topicTags": ["arrays", "hash-table"],
    "problemUrl": "https://codeforces.com/problemset/problem/1234/A",
    "numberOfLikes": 142,
    "numberOfDislikes": 5,
    "numberOfSolvedPeople": 3812,
    "isLiked": false,
    "isDisliked": false,
    "solved": false
  }
]
```

---

### GET `/problems/daily`

Return today's featured problem. Rotates at midnight UTC.

**Response `200`** — same shape as a single problem object above.

---

### POST `/problems/:id/like`

Toggle a like on the problem. If already liked, removes the like.

**Params** `:id` = `problemId` (e.g. `cf-1234A`)

**Response `200`**
```json
{ "numberOfLikes": 143, "isLiked": true }
```

---

### POST `/problems/:id/dislike`

Toggle a dislike on the problem.

**Response `200`**
```json
{ "numberOfDislikes": 6, "isDisliked": true }
```

---

### POST `/problems/:id/solve`

Mark the problem as solved by the current user.

**Response `200`**
```json
{ "solved": true, "numberOfSolvedPeople": 3813 }
```

---

### DELETE `/problems/:id/solve`

Unmark the problem as solved.

**Response `200`**
```json
{ "solved": false, "numberOfSolvedPeople": 3812 }
```

---

### GET `/problems/:id`

Return a single problem with its full description.

**Response `200`**
```json
{
  "problemId": "cf-1234A",
  "title": "Two Sum",
  "difficulty": "Easy",
  "topicTags": ["arrays", "hash-table"],
  "problemUrl": "https://codeforces.com/problemset/problem/1234/A",
  "description": "Given an array of integers...",
  "numberOfLikes": 142,
  "numberOfDislikes": 5,
  "numberOfSolvedPeople": 3812,
  "isLiked": false,
  "isDisliked": false,
  "solved": false
}
```

---

## 3. Contests

### GET `/contests`

Return all contests (upcoming, live, and recent past).

**Response `200`**
```json
[
  {
    "id": "codeforces-1932",
    "title": "Codeforces Round 921 (Div. 2)",
    "contestUrl": "https://codeforces.com/contest/1932",
    "startTime": "2026-06-25T14:35:00Z",
    "duration": "02:15:00",
    "platform": "Codeforces",
    "numberOfProblems": 6,
    "isPast": false,
    "isParticipating": false
  }
]
```

**Field notes**  
- `startTime` — ISO 8601 UTC; the app converts to local time.  
- `duration` — `HH:MM:SS` string; the app parses into a `Duration`.  
- `isPast` — `true` when the contest has fully ended.  
- `isParticipating` — `true` when the current user is registered.

---

### POST `/contests/:id/register`

Register the current user for a contest.

**Response `200`**
```json
{ "isParticipating": true }
```

---

### GET `/contests/:id/leaderboard`

Return the leaderboard for a specific contest.

**Params** `:id` = `contest.id` (e.g. `codeforces-1932`)

**Response `200`**
```json
[
  {
    "rank": 1,
    "username": "tourist",
    "score": 6,
    "penalty": 120,
    "oldRating": 3850,
    "newRating": 3867
  }
]
```

---

## 4. Users & Profiles

### GET `/users`

Return all users, sorted by rating descending by default.

**Query params**

| Param | Type | Description |
|-------|------|-------------|
| `search` | `string` | Filter by username or fullName |
| `division` | `string` | Filter by division (`1`, `2`, `3`) |
| `page` | `int` | 1-based (default `1`) |
| `limit` | `int` | Max `100` (default `50`) |

**Response `200`**
```json
[
  {
    "username": "bereke1t2",
    "fullName": "Bereket Aschalew",
    "bio": "CP enthusiast from Ethiopia",
    "avatarUrl": "https://cdn.cpdhub.io/avatars/bereke1t2.png",
    "rating": 1450,
    "rank": "Expert",
    "division": "2",
    "solvedProblems": 312,
    "contributions": 5
  }
]
```

---

### GET `/users/profile/:username`

Return the full public profile for a user.

**Response `200`** — same shape as a single user object above.

---

### PUT `/users/profile/:username`

Update the current user's own profile.  
_(Authenticated user can only update their own profile.)_

**Request**
```json
{
  "fullName": "Bereket Aschalew",
  "bio": "CP enthusiast from Ethiopia 🇪🇹",
  "avatarUrl": "https://cdn.cpdhub.io/avatars/bereke1t2.png",
  "codeforcesHandle": "bereke1t2"
}
```

**Response `200`** — updated user profile object.

---

### GET `/users/profile/:username/analytics/heatmap`

Return the submission heatmap (daily solve counts) for the past year.

**Response `200`**
```json
[
  { "date": "2026-06-23", "count": 4 },
  { "date": "2026-06-22", "count": 2 }
]
```

---

### GET `/users/profile/:username/analytics/rating-history`

Return the user's rating history across contests.

**Response `200`**
```json
[
  {
    "contestId": "codeforces-1932",
    "contestTitle": "Codeforces Round 921 (Div. 2)",
    "date": "2026-06-10T14:35:00Z",
    "oldRating": 1400,
    "newRating": 1450,
    "rank": 312
  }
]
```

---

### GET `/users/profile/:username/attendance`

Return the user's contest attendance history.

**Response `200`**
```json
[
  {
    "contestId": "codeforces-1932",
    "contestTitle": "Codeforces Round 921 (Div. 2)",
    "date": "2026-06-10T14:35:00Z",
    "rank": 312,
    "solved": 4,
    "totalProblems": 6
  }
]
```

---

### GET `/users/profile/:username/submissions`

Return recent problem submissions for a user.

**Response `200`**
```json
[
  {
    "problemId": "cf-1234A",
    "problemTitle": "Two Sum",
    "verdict": "Accepted",
    "language": "C++17",
    "submittedAt": "2026-06-22T10:15:00Z"
  }
]
```

---

## 5. Consistency — Streaks & Goals

### GET `/consistency/streak`

Return the current user's streak data.

**Response `200`**
```json
{
  "current": 14,
  "longest": 30,
  "last_active_day": "2026-06-22",
  "freezes_available": 2,
  "active_days": [
    "2026-06-09",
    "2026-06-10",
    "2026-06-22"
  ]
}
```

---

### PUT `/consistency/streak`

Save updated streak state after the user solves a problem.

**Request**
```json
{
  "current": 15,
  "longest": 30,
  "last_active_day": "2026-06-23",
  "freezes_available": 2,
  "active_days": ["2026-06-09", "2026-06-23"]
}
```

**Response `200`** — updated streak object.

---

### GET `/consistency/goal`

Return the current user's weekly practice goal.

**Response `200`**
```json
{
  "id": "weekly-problems",
  "type": "problemsPerWeek",
  "target": 5,
  "progress": 3,
  "period_start": "2026-06-17T00:00:00Z"
}
```

**`type` values** — `problemsPerWeek`, `contestsPerMonth`, `minutesPerDay`

---

### PUT `/consistency/goal`

Save the user's updated goal (target or progress).

**Request**
```json
{
  "id": "weekly-problems",
  "type": "problemsPerWeek",
  "target": 7,
  "progress": 3,
  "period_start": "2026-06-17T00:00:00Z"
}
```

**Response `200`** — updated goal object.

---

## 6. Ladders

A **ladder** is a curated sequence of problems ordered by rating — the user climbs the rungs by solving each one.

### GET `/ladders`

Return all available ladders (base definitions without user solve state).

**Response `200`**
```json
[
  {
    "id": "ladder-1000-1200",
    "title": "Beginner Ladder (1000–1200)",
    "from_rating": 1000,
    "to_rating": 1200,
    "rungs": [
      {
        "problem_id": "cf-1A",
        "rating": 1000,
        "solved": false,
        "topic_id": "sorting"
      }
    ]
  }
]
```

---

### GET `/ladders/:id`

Return a single ladder with the current user's solve state merged in.

**Response `200`** — same shape as one ladder above, with `solved` reflecting actual state.

---

### PUT `/ladders/:id`

Save the user's updated solve state for a ladder.

**Request**
```json
{
  "id": "ladder-1000-1200",
  "title": "Beginner Ladder (1000–1200)",
  "from_rating": 1000,
  "to_rating": 1200,
  "rungs": [
    { "problem_id": "cf-1A", "rating": 1000, "solved": true, "topic_id": "sorting" }
  ]
}
```

**Response `200`** — updated ladder object.

---

## 7. Learning — Topics & Tracks

### GET `/learning/topics`

Return all CP curriculum topics with their dependency graph.

**Response `200`**
```json
[
  {
    "id": "binary-search",
    "name": "Binary Search",
    "category": "Algorithms",
    "summary": "Search a sorted array in O(log n) by halving the search space each step.",
    "difficulty": 2,
    "prerequisite_ids": ["sorting"],
    "problem_ids": ["cf-702C", "cf-1353C"],
    "reference_urls": ["https://cp-algorithms.com/num_methods/binary_search.html"]
  }
]
```

**`difficulty`** — 1 (easy) → 5 (advanced)

---

### GET `/learning/topics/:id/lesson`

Return the full lesson content for a topic — body text, key ideas, videos, and code snippet.

**Response `200`**
```json
{
  "topic_id": "binary-search",
  "body": "Binary search works by...",
  "key_ideas": [
    "Always maintain a valid search range [lo, hi]",
    "Use lo + (hi - lo) / 2 to avoid integer overflow"
  ],
  "code": "int lo = 0, hi = n - 1;\nwhile (lo <= hi) { ... }",
  "code_lang": "cpp",
  "videos": [
    {
      "title": "Binary Search Explained — Errichto",
      "url": "https://youtube.com/watch?v=...",
      "duration": "18:42"
    }
  ]
}
```

---

### GET `/learning/tracks`

Return curated learning tracks (ordered sequences of topics).

**Response `200`**
```json
[
  {
    "id": "track-foundations",
    "title": "CP Foundations",
    "description": "Master the core techniques every competitive programmer needs.",
    "topic_ids": ["sorting", "binary-search", "two-pointers", "prefix-sums"],
    "icon_name": "school"
  }
]
```

---

### POST `/learning/topics/:id/complete`

Mark a topic as completed for the current user.

**Response `200`**
```json
{ "topic_id": "binary-search", "completed": true }
```

---

## 8. Courses

Courses are structured learning modules with video, article, and PDF lessons. Progress is persisted per-user.

### GET `/courses`

Return all courses with their modules and lessons (progress merged for the current user).

**Response `200`**
```json
[
  {
    "id": "course-graph-algorithms",
    "title": "Graph Algorithms A–Z",
    "summary": "From BFS/DFS to network flow, covered with problems and code.",
    "level": "Intermediate",
    "modules": [
      {
        "id": "mod-traversal",
        "title": "Graph Traversal",
        "lessons": [
          {
            "id": "lesson-bfs",
            "title": "Breadth-First Search",
            "kind": "video",
            "contentUrl": "https://youtube.com/watch?v=...",
            "durationSec": 1122,
            "completed": false
          },
          {
            "id": "lesson-bfs-article",
            "title": "BFS — Theory & Implementation",
            "kind": "article",
            "contentUrl": "",
            "inlineText": "## BFS\n\nBreadth-first search explores...",
            "completed": false
          }
        ]
      }
    ]
  }
]
```

**`kind`** — `video`, `article`, `pdf`

---

### GET `/courses/:id`

Return a single course with full lesson detail and user progress.

**Response `200`** — same shape as one course object above.

---

### POST `/courses/:courseId/lessons/:lessonId/complete`

Mark a lesson as complete for the current user.

**Response `200`**
```json
{ "lessonId": "lesson-bfs", "completed": true }
```

---

## 9. Smart Practice

Two sub-features: **Spaced Repetition** (review queue) and **Upsolving** (problems to retry from contests).

### GET `/practice/review-queue`

Return the current user's spaced-repetition review queue — problems due today.

**Response `200`**
```json
[
  {
    "problem_id": "cf-1234A",
    "due_date": "2026-06-23T00:00:00Z",
    "interval": 3,
    "ease": 2.5,
    "repetitions": 2
  }
]
```

**SM-2 fields**

| Field | Description |
|-------|-------------|
| `interval` | Days until next review |
| `ease` | Ease factor (starts at 2.5, minimum 1.3) |
| `repetitions` | How many times this card has been reviewed |

---

### POST `/practice/review-queue`

Add a problem to the review queue (first time).

**Request**
```json
{
  "problem_id": "cf-1234A",
  "due_date": "2026-06-23T00:00:00Z",
  "interval": 1,
  "ease": 2.5,
  "repetitions": 0
}
```

**Response `201`** — created review item.

---

### PUT `/practice/review-queue/:problemId`

Update a review item after the user rates their recall (SM-2 algorithm result).

**Request**
```json
{
  "problem_id": "cf-1234A",
  "due_date": "2026-06-26T00:00:00Z",
  "interval": 3,
  "ease": 2.6,
  "repetitions": 3
}
```

**Response `200`** — updated review item.

---

### DELETE `/practice/review-queue/:problemId`

Remove a problem from the review queue.

**Response `204`** — no body.

---

### GET `/practice/upsolves`

Return problems the user flagged for upsolving from past contests.

**Response `200`**
```json
[
  {
    "contest_id": "codeforces-1932",
    "contest_title": "Codeforces Round 921 (Div. 2)",
    "problem_id": "cf-1932D",
    "problem_title": "XOR-Subsequence",
    "resolved": false
  }
]
```

---

### POST `/practice/upsolves`

Add a problem to the upsolve list.

**Request**
```json
{
  "contest_id": "codeforces-1932",
  "contest_title": "Codeforces Round 921 (Div. 2)",
  "problem_id": "cf-1932D",
  "problem_title": "XOR-Subsequence",
  "resolved": false
}
```

**Response `201`** — created upsolve item.

---

### PUT `/practice/upsolves/:problemId`

Mark an upsolve problem as resolved (or unresolved).

**Request**
```json
{ "resolved": true }
```

**Response `200`** — updated upsolve item.

---

## 10. Articles Feed

The app fetches CP articles from the **Codeforces public API** directly (no backend proxy needed). Include these endpoints for when CPD Hub aggregates its own editorial content or caches external feeds.

### External: Codeforces Recent Blog Entries

```
GET https://codeforces.com/api/recentActions?maxCount=100
```

The app calls this directly, filters items where `blogEntry != null && comment == null`, deduplicates by `blogEntry.id`, and maps to `ArticleEntity`.

---

### GET `/articles` _(future — CPD Hub–authored content)_

Return CPD Hub's own editorial articles and tutorials.

**Query params**

| Param | Type | Description |
|-------|------|-------------|
| `limit` | `int` | Items per page (default `10`) |
| `offset` | `int` | Pagination offset (default `0`) |
| `source` | `string` | `codeforces`, `leetcode`, `cpdhub` |
| `tag` | `string` | Topic tag filter |

**Response `200`**
```json
[
  {
    "id": "cf_130001",
    "title": "The Ultimate Segment Tree Tutorial",
    "author": "tourist",
    "source": "Codeforces",
    "sourceUrl": "https://codeforces.com/blog/entry/130001",
    "excerpt": "Segment trees are one of the most powerful...",
    "fullContent": "Segment trees are one of the most powerful...\n\nWe start with...",
    "publishedAt": "2026-06-21T10:00:00Z",
    "tags": ["data structures", "trees", "tutorial"],
    "rating": 342
  }
]
```

---

## 11. Activity & Info

### GET `/activity`

Return the current user's recent activity feed (problems solved, contests joined, streaks reached).

**Response `200`**
```json
[
  {
    "type": "problem_solved",
    "timestamp": "2026-06-23T09:00:00Z",
    "payload": {
      "problemId": "cf-1234A",
      "title": "Two Sum",
      "difficulty": "Easy"
    }
  },
  {
    "type": "streak_milestone",
    "timestamp": "2026-06-22T23:59:00Z",
    "payload": { "days": 14 }
  }
]
```

**`type` values** — `problem_solved`, `contest_joined`, `streak_milestone`, `rating_change`, `course_lesson_complete`

---

### GET `/info`

Return platform-wide informational items (announcements, tips, upcoming events).

**Response `200`**
```json
[
  {
    "title": "New Contest Series Starting",
    "description": "Weekly rated contests begin June 28."
  }
]
```

---

## 12. Error Responses

All errors follow this envelope:

```json
{
  "error": "Short machine-readable code",
  "message": "Human-readable explanation shown in the app."
}
```

| HTTP Status | `error` code | When |
|-------------|-------------|------|
| `400` | `validation_failed` | Invalid request body or params |
| `401` | `unauthorized` | Missing or expired token |
| `403` | `forbidden` | Valid token but insufficient permission |
| `404` | `not_found` | Resource does not exist |
| `409` | `conflict` | Duplicate resource (e.g. email already registered) |
| `422` | `unprocessable` | Business rule violation (e.g. passwords don't match) |
| `429` | `rate_limited` | Too many requests; respect `Retry-After` header |
| `500` | `server_error` | Unexpected server failure |

---

## Summary Table

| Method | Path | Auth | Feature |
|--------|------|------|---------|
| `POST` | `/auth/login` | ✗ | Sign in |
| `POST` | `/auth/signup` | ✗ | Register |
| `POST` | `/auth/logout` | ✓ | Sign out |
| `GET` | `/auth/me` | ✓ | Current user |
| `POST` | `/auth/refresh` | ✗ | Refresh token |
| `GET` | `/problems` | ✓ | Problem list |
| `GET` | `/problems/daily` | ✓ | Daily problem |
| `GET` | `/problems/:id` | ✓ | Problem detail |
| `POST` | `/problems/:id/like` | ✓ | Like problem |
| `POST` | `/problems/:id/dislike` | ✓ | Dislike problem |
| `POST` | `/problems/:id/solve` | ✓ | Mark solved |
| `DELETE` | `/problems/:id/solve` | ✓ | Unmark solved |
| `GET` | `/contests` | ✓ | Contest list |
| `POST` | `/contests/:id/register` | ✓ | Register for contest |
| `GET` | `/contests/:id/leaderboard` | ✓ | Contest leaderboard |
| `GET` | `/users` | ✓ | User leaderboard |
| `GET` | `/users/profile/:username` | ✓ | User profile |
| `PUT` | `/users/profile/:username` | ✓ | Update profile |
| `GET` | `/users/profile/:username/analytics/heatmap` | ✓ | Solve heatmap |
| `GET` | `/users/profile/:username/analytics/rating-history` | ✓ | Rating history |
| `GET` | `/users/profile/:username/attendance` | ✓ | Contest attendance |
| `GET` | `/users/profile/:username/submissions` | ✓ | Submissions |
| `GET` | `/consistency/streak` | ✓ | Get streak |
| `PUT` | `/consistency/streak` | ✓ | Save streak |
| `GET` | `/consistency/goal` | ✓ | Get goal |
| `PUT` | `/consistency/goal` | ✓ | Save goal |
| `GET` | `/ladders` | ✓ | All ladders |
| `GET` | `/ladders/:id` | ✓ | Single ladder |
| `PUT` | `/ladders/:id` | ✓ | Save ladder progress |
| `GET` | `/learning/topics` | ✓ | Curriculum topics |
| `GET` | `/learning/topics/:id/lesson` | ✓ | Topic lesson |
| `GET` | `/learning/tracks` | ✓ | Learning tracks |
| `POST` | `/learning/topics/:id/complete` | ✓ | Complete topic |
| `GET` | `/courses` | ✓ | Course list |
| `GET` | `/courses/:id` | ✓ | Course detail |
| `POST` | `/courses/:courseId/lessons/:lessonId/complete` | ✓ | Complete lesson |
| `GET` | `/practice/review-queue` | ✓ | Spaced repetition queue |
| `POST` | `/practice/review-queue` | ✓ | Add to review |
| `PUT` | `/practice/review-queue/:problemId` | ✓ | Update review item |
| `DELETE` | `/practice/review-queue/:problemId` | ✓ | Remove from review |
| `GET` | `/practice/upsolves` | ✓ | Upsolve list |
| `POST` | `/practice/upsolves` | ✓ | Add upsolve |
| `PUT` | `/practice/upsolves/:problemId` | ✓ | Resolve upsolve |
| `GET` | `/articles` | ✓ | Articles feed |
| `GET` | `/activity` | ✓ | Activity feed |
| `GET` | `/info` | ✗ | Platform info |
