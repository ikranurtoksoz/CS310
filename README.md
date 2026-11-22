# SUrvivor

SUrvivor is a Flutter-based mobile application designed to simplify daily life at Sabancı University by bringing campus transportation and dining information together in one place.

The application allows students, faculty, and staff to access shuttle schedules, upcoming departures, campus menus, and prices through a single, user-friendly interface.

## Getting Started 

**Flutter version:** 3.50.0 (stable) · Dart 3.14.0 (requires Dart ^3.13.5)

```bash
git clone https://github.com/ikranurtoksoz/CS310.git
cd CS310/survivor_app
flutter pub get
flutter run            # pick a connected device / emulator
# or, in the browser:
flutter run -d chrome
```

The app starts with a splash screen, then Welcome → Log In / Sign Up → main screens. Authentication is UI-only in this step; any valid e-mail and a 6+ character password open the app.

All data (timetables, menus, favourites) is placeholder data kept in memory. An internet connection is needed for the Plus Jakarta Sans font (`google_fonts`) and the dish photos (Wikipedia thumbnails); without it the app falls back to the default font and icon tiles.

Run the tests with `flutter test`.

### Project structure

```
survivor_app/lib/
├── main.dart               app entry, routes
├── theme/app_theme.dart    shared palette, typography, widgets (BrandMark, GradientBackground)
├── models/                 Meal, FavouriteItem, TransportRoute
├── data/                   mock menu and transport data, Wikipedia titles for dish photos
├── services/               FavouritesStore (meals), FavoriteService (routes), MealImageService
├── utils/                  departures (next-departure and countdown helpers)
├── widgets/                MealCard, MealThumb, InfoCard / SettingRow / ActionButton
└── screens/                splash, welcome, login, signup, forgot_password,
                            main_shell (bottom navigation, 5 tabs), home, transport,
                            route_detail, menus, favourites, profile, admin_update
```

### Design system

All screens share one theme (`AppTheme`). Use its constants instead of hard-coded colours:

| Token | Hex | Use |
|---|---|---|
| `AppTheme.primaryColor` | `#20345C` Sabancı Navy | app bars, titles, primary buttons |
| `AppTheme.accent` | `#E8A6BD` Sakura Pink | selected chips, nav indicator, favourites |
| `AppTheme.accentStrong` | `#DB7FA0` | pink text/icons, focused inputs |
| `AppTheme.highlight` | `#F7DCE6` Petal Blush | soft highlights, gradients |
| `AppTheme.backgroundColor` | `#FDF7FA` Soft Ivory | page background |
| `AppTheme.coolGray` | `#A9ADBA` | inactive icons |
| `AppTheme.textSecondary` | `#7D8298` Muted Slate | secondary text |


### Team workflow

- One branch per member (`feature/auth`, `feature/transport`, `feature/dining-favourites`, `feature/home-profile-admin-v2`); changes reach `main` through pull requests.
- After pulling, run `flutter pub get` (dependencies: `google_fonts`, `http`).
- Conventional Commits (`feat(dining): …`, `style(theme): …`).

## Features

### Campus Transportation
- View shuttle and KM18 schedules, routes, and fares.
- Check upcoming departures based on the current time.
- Filter schedules by destination and departure time.
- Save favourite routes for quick access.
- Set reminders before selected departures.

### Campus Dining
- Browse daily menus from Yemekhane, Küçükev, and Piazza.
- View meal options and prices.
- Search for specific menu items.
- Save favourite meals.

### User Accounts and Personalization
- Secure login using Firebase Authentication.
- User profiles and preferences.
- Locally stored favourites for convenient access.

### Data Management
- Admin interface for updating schedules and menus.
- Centralized data storage using Cloud Firestore.
- Data collection from publicly available sources where possible.
- Manual data entry when automated collection is unavailable.
- Last-updated timestamps for schedules and menus.
- Local caching for offline access to previously loaded information.

## Technology Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform mobile development |
| Dart | Application programming language |
| Firebase Authentication | User authentication |
| Cloud Firestore | Database management |
| Local Storage | Favourites and cached data |
| Python | Data collection and processing |

## Data Sources

SUrvivor aims to integrate transportation and dining information from available university and public sources.

| Data | Source | Approach |
|---|---|---|
| Shuttle schedules | mySU | University access if available; otherwise manual updates |
| KM18 schedules | IETT | Explore automated data retrieval; otherwise manual updates |
| Yemekhane menus | University sources | Publicly available information or manual updates |
| Küçükev and Piazza menus | Restaurant websites and campus sources | Website data collection where possible or manual updates |

All application data will be maintained in Firestore to provide a consistent source of information.

## Future Improvements

- Weekly dining menus
- Dormitory cleaning schedules
- Turkish and English language support

## Target Users

SUrvivor is designed for the Sabancı University community, including:

- Commuting students who regularly use campus transportation.
- Dormitory students who want quick access to dining information.
- Faculty and staff who need transportation and dining updates.

## Development Team

This project is developed as part of the **CS310 - Mobile Application Development** course at Sabancı University.

**Group 12**

| Team Member | Student ID |
|---|---|
| Zeynep Altundal | 31978 |
| Asude Betül Öztürk | 34170 |
| Esra Yağışan | 34212 |
| İkranur Toksöz | 33928 |

---

Developed for the Sabancı University community.
