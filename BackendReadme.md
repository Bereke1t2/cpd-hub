# CPD Hub — Backend API Reference

Base URL: `http://localhost:8000/api`

All endpoints require an `Authorization: Bearer <token>` header unless stated otherwise.

---

## Authentication

### POST `/auth/login`

Authenticate an existing user.

**Request Body:**

```json
{
  "email": "user@example.com",
  "password": "secret123"
}
```

**Response `200`:**

```json
{
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "username": "bereket",
    "fullName": "Bereket Lemma",
    "email": "user@example.com"
  }
}
```

---

### POST `/auth/signup`

Register a new user.

**Request Body:**

```json
{
  "fullName": "Bereket Lemma",
  "email": "user@example.com",
  "password": "secret123",
  "confirmPassword": "secret123"
}
```

**Response `201`:**

```json
{
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "username": "bereket",
    "fullName": "Bereket Lemma",
    "email": "user@example.com"
  }
}
```

---

## Problems

### GET `/problems`

Retrieve all problems.

**Response `200`:**

```json
[
  {
    "id": "p1",
    "title": "Two Sum",
    "difficulty": "Easy",
    "topic_tags": ["Array", "Hash Table"],
    "likes": 245,
    "dislikes": 12,
    "deep_link": "https://...",
    "isLiked": false,
    "isDisliked": false,
    "solved": true
  }
]
```

> **Note:** The Flutter client also accepts `numberOfLikes`/`numberOfDislikes` and `url`/`problemUrl` as aliases.

---

### GET `/problems/:id`

Get a single problem with full description, examples, and constraints.

**Response `200`:**

```json
{
  "id": "p1",
  "title": "Two Sum",
  "difficulty": "Easy",
  "topic_tags": ["Array", "Hash Table"],
  "likes": 245,
  "dislikes": 12,
  "deep_link": "https://...",
  "isLiked": false,
  "isDisliked": false,
  "solved": true,
  "description": "Given an array of integers `nums` and an integer `target`, return indices of the two numbers such that they add up to `target`.",
  "examples": [
    {
      "input": "nums = [2,7,11,15], target = 9",
      "output": "[0,1]",
      "explanation": "Because nums[0] + nums[1] == 9, we return [0, 1]."
    }
  ],
  "constraints": [
    "2 <= nums.length <= 10^4",
    "-10^9 <= nums[i] <= 10^9"
  ]
}
```

---

### GET `/problems/daily`

Get the daily challenge problem.

**Response `200`:**

```json
{
  "title": "Longest Common Subsequence",
  "difficulty": "Medium",
  "tags": ["Dynamic Programming", "String"],
  "problemUrl": "https://...",
  "problemId": "dp1",
  "isLiked": false,
  "isDisliked": false,
  "isSolved": false,
  "numberOfLikes": 342,
  "numberOfDislikes": 18,
  "numberOfSolvedPeople": 1250
}
```

---

### POST `/problems/:id/like`

Like a problem. No request body required.

**Response `200`:** empty or `{ "success": true }`

---

### POST `/problems/:id/dislike`

Dislike a problem. No request body required.

**Response `200`:** empty or `{ "success": true }`

---

### POST `/problems/:id/solve`

Mark a problem as solved.

**Response `200`:** empty or `{ "success": true }`

---

### DELETE `/problems/:id/solve`

Unmark a problem as solved.

**Response `200`:** empty or `{ "success": true }`

---

## Contests

### GET `/contests`

Retrieve all contests.

**Response `200`:**

```json
[
  {
    "id": "c1",
    "title": "Global Round #26",
    "contestUrl": "https://...",
    "startTime": "2026-02-15T10:00:00Z",
    "duration": "2h 30m",
    "platform": "CPD Hub",
    "numberOfProblems": 6,
    "numberOfContestants": 1240,
    "date": "Feb 15, 2026",
    "isPast": false,
    "isParticipating": true
  }
]
```

---

### GET `/contests/:id/leaderboard`

Get the leaderboard for a specific contest.

**Response `200`:**

```json
[
  {
    "rank": 1,
    "username": "tourist",
    "rating": 3800,
    "score": 600,
    "penalty": 45,
    "problemsSolved": ["A", "B", "C", "D", "E", "F"]
  }
]
```

---

## Users

### GET `/users`

Retrieve all users.

**Response `200`:**

```json
[
  {
    "username": "bereket",
    "fullName": "Bereket Lemma",
    "bio": "Competitive programmer",
    "avatarUrl": "https://...",
    "rating": 1750,
    "rank": "Expert",
    "division": "Div 1",
    "solvedProblems": 120,
    "contributions": 45,
    "globalRank": 1204,
    "attendedContestsCount": 24,
    "socialLinks": [
      {
        "platform": "LeetCode",
        "url": "https://leetcode.com/bereket",
        "handle": "bereket"
      }
    ]
  }
]
```

---

### GET `/users/profile/:username`

Get a user's full profile.

**Response `200`:**

```json
{
  "username": "bereket",
  "fullName": "Bereket Lemma",
  "bio": "Competitive programmer | CPD Hub enthusiast",
  "avatarUrl": "https://...",
  "rating": 1750,
  "rank": "Expert",
  "division": "Div 1",
  "solvedProblems": 120,
  "contributions": 45,
  "globalRank": 1204,
  "attendedContestsCount": 24,
  "socialLinks": [
    {
      "platform": "LeetCode",
      "url": "https://leetcode.com/bereket",
      "handle": "bereket"
    },
    {
      "platform": "Codeforces",
      "url": "https://codeforces.com/profile/bereket",
      "handle": "bereket_cf"
    }
  ]
}
```

---

## Profile Analytics

### GET `/users/profile/:username/analytics/heatmap`

Get the user's coding heatmap for a given month.

**Query Parameters:**

| Param | Type | Description |
|-------|------|-------------|
| `month` | int | Month number (1-12) |
| `year` | int | Four-digit year |

**Response `200`:**

```json
[
  { "date": "2026-02-01", "solveCount": 0 },
  { "date": "2026-02-02", "solveCount": 3 },
  { "date": "2026-02-03", "solveCount": 1 }
]
```

---

### GET `/users/profile/:username/analytics/rating-history`

Get the user's rating over time.

**Response `200`:**

```json
[
  { "date": "2025-08-01", "rating": 1000 },
  { "date": "2025-09-01", "rating": 1200 },
  { "date": "2026-01-01", "rating": 1750 }
]
```

---

### GET `/users/profile/:username/attendance`

Get the user's attendance records for a given month.

**Query Parameters:**

| Param | Type | Description |
|-------|------|-------------|
| `month` | int | Month number (1-12) |
| `year` | int | Four-digit year |

**Response `200`:**

```json
[
  { "date": "2026-02-01", "status": "Present" },
  { "date": "2026-02-02", "status": "Absent" },
  { "date": "2026-02-03", "status": "Excused" }
]
```

Possible `status` values: `"Present"`, `"Absent"`, `"Excused"`

---

### GET `/users/profile/:username/submissions`

Get the user's recent submissions.

**Response `200`:**

```json
[
  {
    "id": "s1",
    "problemId": "p1",
    "problemTitle": "Two Sum",
    "status": "Accepted",
    "language": "Python",
    "executionTime": "45ms",
    "memoryUsed": "14.2MB",
    "timestamp": "2 hours ago"
  }
]
```

Possible `status` values: `"Accepted"`, `"Wrong Answer"`, `"Time Limit Exceeded"`, `"Runtime Error"`, `"Compilation Error"`

---

## Activity Feed

### GET `/activity`

Get the global activity feed.

**Response `200`:**

```json
[
  {
    "id": "a1",
    "username": "abel",
    "action": "solved 'Two Sum' in 3 min",
    "type": "Solve",
    "timestamp": "2 min ago"
  }
]
```

Possible `type` values: `"Solve"`, `"Rating"`, `"Badge"`

---

## Info / Announcements

### GET `/info`

Get announcements and system info. Can return a single object or an array.

**Response `200` (array):**

```json
[
  {
    "title": "System Maintenance",
    "description": "Scheduled maintenance on Feb 20th from 2-4 AM"
  },
  {
    "title": "New Feature: Heatmaps",
    "description": "Track your coding consistency with the new heatmap feature!"
  }
]
```

---

## Error Responses

All endpoints return errors in this format:

```json
{
  "error": "Short error code",
  "message": "Human-readable description"
}
```

| Status | Meaning |
|--------|---------|
| `400` | Bad request / validation error |
| `401` | Unauthorized (missing or invalid token) |
| `403` | Forbidden (insufficient permissions) |
| `404` | Resource not found |
| `500` | Internal server error |

---

## Endpoint Summary

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/auth/login` | Login |
| POST | `/auth/signup` | Register |
| GET | `/problems` | List all problems |
| GET | `/problems/:id` | Problem detail with description |
| GET | `/problems/daily` | Daily challenge |
| POST | `/problems/:id/like` | Like a problem |
| POST | `/problems/:id/dislike` | Dislike a problem |
| POST | `/problems/:id/solve` | Mark solved |
| DELETE | `/problems/:id/solve` | Unmark solved |
| GET | `/contests` | List all contests |
| GET | `/contests/:id/leaderboard` | Contest leaderboard |
| GET | `/users` | List all users |
| GET | `/users/profile/:username` | User profile |
| GET | `/users/profile/:username/analytics/heatmap` | Coding heatmap |
| GET | `/users/profile/:username/analytics/rating-history` | Rating history |
| GET | `/users/profile/:username/attendance` | Attendance records |
| GET | `/users/profile/:username/submissions` | Recent submissions |
| GET | `/activity` | Activity feed |
| GET | `/info` | Announcements |
