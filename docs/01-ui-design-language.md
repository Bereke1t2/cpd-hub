# UI Design Language — read before building any screen (phases 9–11)

> This is the visual contract. Phase 0 defines the *tokens*; this defines how to *compose* them so every
> new screen looks like it belongs to the same app and feels modern. If you build a screen without reading
> this, it will drift. The reusable widgets in [`templates/ui_kit.dart`](./templates/ui_kit.dart) encode
> these rules — **compose them, don't reinvent them.**

---

## 1. The look in one paragraph

Dark app (`backgroundColor #121212`). Content lives on **cards**: a dark surface (`infoBackgroundColor
#1A2A3A`) with a *faint* gradient tint pulled from an **accent colour that means something**, a large
corner radius, a soft shadow, and a hairline border. Accent is never decorative — it encodes state
(rating tier, topic status, difficulty, streak heat). Generous spacing, rounded everything, one accent per
card. Think "fintech dashboard," not "form."

## 2. Non-negotiable rules

1. **Compose the kit.** Surfaces = `GradientCard`. Headings = `SectionHeader`. Stats = `StatPill`. Ratios =
   `ProgressRing`. Enum-state = `StatusChip`. Async = `AsyncView`. Never hand-roll a `Container` +
   `BoxDecoration` card in a feature widget.
2. **Tokens only.** Spacing from `AppSpacing`, radii from `AppRadii`, text from `AppTextStyles`, colour from
   `UiConstants`. Zero magic numbers — no literal `EdgeInsets.all(16)`, no `Color(0xFF...)` in feature code.
3. **One accent per card.** Each card picks a single accent and tints its gradient/border/icons with it.
   Don't rainbow a card.
4. **Colour has meaning, and never stands alone.** Every colour-coded thing also carries an icon or word
   (a11y, Phase 6.6). `StatusChip` already does this — use it.
5. **State via `AsyncView`.** Loading / error+retry / empty / data on every BLoC screen. No bare spinners,
   no silent empty lists.
6. **Responsive.** Wrap list/grid bodies in `LayoutBuilder`; switch columns at ~600 / ~900 px (the app
   targets web + mobile). Single column < 600, 2 up to 900, 3 beyond — match `UsersPage`/`ProblemsPage`.
7. **Motion is subtle.** 150–250 ms implicit animations (`AnimatedContainer`, `AnimatedOpacity`) on state
   change; no bounce, no long flourishes. Solving something can pulse the relevant ring once.

## 3. Colour = meaning (the semantic palette)

| Meaning | Token | Used for |
|---------|-------|----------|
| Primary / success / "done" | `primaryButtonColor` (green) | completed topics, solved rungs, met goals, primary CTAs |
| Heat / "act now" | `ratingTextColor` (gold) | streaks, "Up next", today's ladder rung, available topics |
| Info / secondary | `problemTextColor` (blue) | freezes, neutral metadata, links |
| Muted / locked / disabled | `subtitleTextColor` (gray) | locked topics, captions, secondary text |
| Stat accent | `statTextColor` (teal) | numeric stats in progress contexts |
| Rating tier | `UiConstants.getUserRatingColor(rating)` | user avatars, rating chips, leaderboard names |
| Difficulty | easy/medium/hard colours | problem difficulty badges |

**Topic status mapping** (single source of truth — `TopicStatusStyle` in `skill_tree_widgets.dart`):
`completed → green/check`, `available → gold/play`, `locked → gray/lock`. Reuse it everywhere a topic
state appears so the language never contradicts itself.

## 4. The card recipe (already in `GradientCard`)

```
radius:  AppRadii.lg (cards) / AppRadii.md (dense list rows)
padding: AppSpacing.card (16)
border:  accent @ 16% (6% when dimmed/locked)
shadow:  UiConstants.cardShadow
fill:    LinearGradient(topLeft→bottomRight) [accent @ 9%, infoBackgroundColor]
dimmed:  whole card to 55% opacity for locked/inactive
```
Locked/inactive items use `GradientCard(dimmed: true)` — never a different widget.

## 5. Page skeleton (every new page)

```dart
BlocProvider(
  create: (_) => getIt<XBloc>()..add(const XStarted()),
  child: BasePage(            // keeps bottom nav + header consistent
    title: '...', subtitle: '...', selectedIndex: N,
    body: LayoutBuilder(builder: (context, c) {
      return BlocBuilder<XBloc, XState>(
        builder: (context, state) => AsyncView<T>(
          isLoading: ..., error: ..., data: ..., onRetry: ...,
          builder: (data) => /* compose ui_kit widgets */,
        ),
      );
    }),
  ),
)
```
Detail pages that aren't tabs use `BasePage(selectedIndex: <parent tab>)` so the nav highlight stays sane.
Horizontal padding is always `AppSpacing.pageH`.

---

## 6. Screen specs

ASCII mockups below are layout intent, not pixel truth. Each names the kit widgets to use.

### Phase 9 — Skill Tree (`skill_tree_page.dart`)

```
┌─ Learn ───────────────────────────────── [overall ◔ 42%] ┐  ← SectionHeader + ProgressRing
│  ⚡ Up next                                                │  ← UpNextStrip (gold cards, scroll →)
│  ┌─────────┐ ┌─────────┐ ┌─────────┐                      │
│  │ DP      │ │ Graphs  │ │ Strings │  …                   │
│  │ ▶ Start │ │ ▶ Start │ │ ▶ Start │                      │
│  └─────────┘ └─────────┘ └─────────┘                      │
│                                                            │
│  SEARCHING                                                 │  ← category swimlane (SectionHeader)
│  ◉ Binary Search        12/12 · ✓ Completed                │  ← TopicNode (green)
│  ◑ Two Pointers          4/8 · ▶ Start now                 │  ← TopicNode (gold, available)
│  ○ BS on Answer          0/6 · 🔒 Locked                    │  ← TopicNode (gray, dimmed)
│        Needs: Two Pointers                                 │     unmet-prereq hint
│                                                            │
│  DYNAMIC PROGRAMMING                                       │
│  ◉ DP Intro …                                              │
└────────────────────────────────────────────────────────────┘
```
- Group topics by `category` into swimlanes (`SectionHeader` per lane, `TopicNode` rows). Full DAG layout
  is a later stretch — lanes read cleanly and ship fast.
- Top of page: overall `ProgressRing` + the `UpNextStrip`. This rail is the most important pixels on screen.
- Locked nodes stay tappable (→ detail) but show "Needs: X, Y".

### Phase 9 — Topic Detail (`topic_detail_page.dart`)

```
┌─ Binary Search ───────────────────  ▶ Start now ──┐  ← header GradientCard, status accent
│  Searching · difficulty 2 · 4/8 solved   ◑        │  ← StatPill row + ProgressRing
├───────────────────────────────────────────────────┤
│  Concept                                          │  ← SectionHeader; flutter_markdown body
│  Binary search halves the search space…           │
│  • Monotonic predicate  • O(log n)  • off-by-one  │  ← keyIdeas bullets
├───────────────────────────────────────────────────┤
│  References                              ↗         │  ← external links (url_launcher)
│  → cp-algorithms: Binary search                   │
├───────────────────────────────────────────────────┤
│  Practice                               4/8 ◑      │  ← SectionHeader + ProgressRing
│  ✓ Easy   — Guess the number                      │  ← reuse ProblemCard, ordered easy→hard
│  ✓ Easy   — First bad version                     │
│  ○ Medium — Capacity to ship …                    │
├───────────────────────────────────────────────────┤
│  Prerequisites:  [Sorting ✓]  [Basics ✓]          │  ← StatusChip / prereq chips, tappable
└───────────────────────────────────────────────────┘
```

### Phase 9 — Tracks (`tracks_page.dart` / `track_detail_page.dart`)

```
TRACKS                                  TRACK DETAIL — Div 2 A–C Survival Kit
┌──────────────────────────┐           ① ✓ Basics
│ Div 2 A–C Survival Kit   │  60%       ② ✓ Sorting
│ ███████░░░  6/10 topics  │  ◑         ③ ▶ Greedy        ← current step (gold), highlighted
└──────────────────────────┘           ④ ○ Prefix Sums   ← upcoming (dimmed)
┌──────────────────────────┐           ⑤ ○ Binary Search
│ Graph Mastery            │  20%
└──────────────────────────┘           (vertical stepper; first non-completed = current)
```
- `TrackCard` = `GradientCard` + a `LinearProgressIndicator` (same style as `GoalBar`) + % `StatPill`.
- Track detail = vertical stepper; first non-completed topic highlighted gold as "current step".

### Phase 10 — Consistency Hub (Home card + `consistency_page.dart`)

```
┌─ ◔ 5  ── Current streak ──────────────────┐   ← StreakRing (gold ring, big number)
│  days   [Longest 12] [❄ Freezes 2]        │
├───────────────────────────────────────────┤
│ Problems this week            3 / 5        │   ← GoalBar (teal track)
│ ██████████░░░░░░                           │
├───────────────────────────────────────────┤
│ Today's rung                    ⚡ Today   │   ← LadderRungTile (first unsolved)
│ [1300] Two Sum II              Two Pointers │
└───────────────────────────────────────────┘
```
Keep this compact and above the fold on Home — it's the daily-return surface.

### Phase 10 — Ladder (`ladder_page.dart`)

```
┌─ Climb: 1200 → 1400 ───────────  7/20 ◑ ─┐  ← header GradientCard + ProgressRing
├──────────────────────────────────────────┤
│ ✓ [1200] Watermelon            (green)    │  ← LadderRungTile, solved=filled green
│ ✓ [1250] Way Too Long Words               │
│ ⚡ [1300] Two Sum II      ⚡Today (gold)    │  ← first unsolved = today's rung
│ ○ [1350] Theatre Square        (dimmed)   │  ← upcoming, dimmed
│ ○ [1400] …                                │
└──────────────────────────────────────────┘
```
A vertical climb. Solving the gold rung advances the ladder and pings the streak.

### Phase 10 — Consistency Leaderboard
Reuse `ContestLeaderboardPage`'s row/card widgets verbatim; only the metric changes (streak / weekly
solves instead of rating delta). Rank avatars by `getUserRatingColor`. Add a segmented toggle
(Streak | This week) styled like the existing `SegmentedButton` on `ProfilePage`.

### Phase 11 — "For You" (`for_you_page.dart`)

```
┌─ Recommended for you ─────────────────────┐
│ [DP] Coin Change            ~1300         │  ← RecommendationCard = GradientCard + reason line
│ Weakest topic at your level · prereqs ✓   │     (reason ALWAYS shown — explainable)
├───────────────────────────────────────────┤
│ Due for review (3)                        │  ← SectionHeader; spaced-repetition queue
│ ↻ Sliding Window Maximum   due today      │  ← review tile, StatusChip 'Review'
├───────────────────────────────────────────┤
│ Upsolve from Round 24 (2)                 │
│ ○ Problem D   pending      ○ Problem E    │  ← StatusChip pending/resolved
└───────────────────────────────────────────┘
```
- Each recommendation **must** show its `reason` — no black-box "trust me" cards.
- Strength on Profile: a `strength_radar` (or per-category `GoalBar` rows) — "strong at graphs, weak at DP".
- Degrade gracefully: thin history → fall back to the Phase-9 frontier / Phase-10 ladder, never fabricate.

---

## 7. What "modern" means here (do / don't)

**Do:** soft gradients, rounded corners (`lg`/`xl`), accent-tinted icon chips, pill badges, progress rings,
generous whitespace, a single confident accent per card, snappy 150–250 ms transitions, skeleton/`AsyncView`
loading.

**Don't:** flat gray boxes, hard black borders, multiple competing accents on one card, dense ungrouped
lists, colour-only signaling, raw `CircularProgressIndicator` floating in space, magic numbers, or a new
bespoke card style per feature.

## 8. Definition of Done (per new screen)
- [ ] Built only from `ui_kit` + `AsyncView` + `BasePage` — no bespoke card decoration.
- [ ] All spacing/radii/text/colour come from tokens; `flutter analyze` clean.
- [ ] Loading / error+retry / empty states present.
- [ ] Responsive at 360 / 768 / 1280 px.
- [ ] Every colour-coded element also has an icon or label.
- [ ] Matches the relevant ASCII spec above in structure and accent usage.
