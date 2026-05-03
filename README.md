# HabitHop — Ultimate Habit Tracker

A cross-platform habit tracking app built with Flutter. Dark, glassy, iOS-inspired UI. Vibe coded. Does exactly what it needs to.

---

## ✨ Features

- 🎯 **Create & manage habits** — add a name, optional description, and pick a color
- ✅ **Daily check-off** — toggle habits complete with a single tap via an adaptive switch
- 🎨 **Color-coded habits** — 8 preset colors to visually distinguish your habits at a glance
- 📊 **Weekly bar chart** — see how many habits you completed each day over the last 7 days
- 🗓️ **Per-habit heatmap calendar** — 6-month scrollable heatmap showing consistency for each habit individually
- 💾 **Local storage with Hive** — all data stored on-device, no account, no cloud, no nonsense
- 🌙 **Dark violet glassmorphism theme** — deep `#1A1625` background, blurred glass cards, gradient text
- 🐰 **Animated splash screen** — bouncing bunny logo with rotating background circles on launch
- ↔️ **Swipe to edit or delete** — `flutter_slidable` for quick habit management
- 📱 **Cross-platform** — runs on Android, iOS, Web, macOS, Linux, and Windows

---

## 📱 Screens

**Habits Tab** — your full habit list for today. Each card shows the habit name, description, color indicator, and a toggle switch. Swipe left to reveal Edit and Delete actions.

**Analytics Tab** — a weekly bar chart at the top showing total completions per day, followed by a scrollable heatmap calendar for each habit individually over the last 180 days.

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.27.0`
- Dart SDK `>=3.7.0 <4.0.0`

### Installation

```bash
git clone https://github.com/Themahattava/HabitHop---Ultimate-Habit-tracker.git
cd HabitHop---Ultimate-Habit-tracker/habit_tracker
flutter pub get
```

### Generate Hive adapters

```bash
dart run build_runner build
```

### Run

```bash
flutter run
```

---

## 🗂️ Project Structure

```
lib/
├── main.dart                    # App entry point, Hive init, bottom nav
├── models/
│   ├── habit.dart               # Habit model — id, title, description, color, completedDates
│   └── habit.g.dart             # Hive TypeAdapter (generated)
├── screens/
│   ├── home_screen.dart         # Habit list with daily toggles + slidable cards
│   ├── analytics_screen.dart    # Weekly bar chart + per-habit heatmaps
│   ├── add_edit_habit_screen.dart  # Form to create/edit a habit + color picker
│   └── splash_screen.dart       # Animated bunny splash
└── theme/
    └── app_theme.dart           # Dark violet theme, glassmorphism helpers, gradient text
```

---

## 📦 Dependencies

| Package | Purpose |
|---|---|
| `hive` + `hive_flutter` | Local data storage |
| `fl_chart` | Weekly bar chart in Analytics |
| `flutter_heatmap_calendar` | Per-habit 6-month heatmap |
| `flutter_slidable` | Swipe-to-edit/delete on habit cards |
| `google_fonts` | Inter font throughout the app |
| `path_provider` | Required by Hive for file paths |
| `intl` | Date formatting |
| `cupertino_icons` | Icon set |

**Dev dependencies:** `hive_generator`, `build_runner`, `flutter_lints`

---

## 🎨 Design

The whole app runs on a single dark violet theme defined in `app_theme.dart`:

- **Background:** `#1A1625`
- **Surface / Cards:** `#2D253A` with `BackdropFilter` blur for glassmorphism
- **Primary accent:** `#9C27B0` (deep violet) with `#E1BEE7` (light violet)
- **Typography:** Inter via Google Fonts
- **Gradient text** on the home screen title using `ShaderMask`

Habit cards use `enhancedGlassContainer` — a double-layered glass effect with a subtle violet glow shadow. The splash screen has a custom-painted bunny logo (`BunnyPainter`) with `elasticOut` bounce animation and animated loading dots.

---

## 🙋 Made by

**Mahattva** — [@Themahattava](https://github.com/Themahattava)

B.Tech (CSE - Data Science) | Bhilai Institute of Technology, Durg

> *Built for personal use. Vibe coded. Ships on 6 platforms because Flutter said why not.*

---

## 📄 License

MIT — do whatever you want with it.
