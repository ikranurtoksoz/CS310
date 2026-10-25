# SUrvivor

**Your Campus, Simplified.**

SUrvivor is a Flutter-based mobile application designed to simplify daily life at Sabancı University by bringing campus transportation and dining information together in one place.

The application allows students, faculty, and staff to access shuttle schedules, upcoming departures, campus menus, and prices through a single, user-friendly interface.

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

## Project Status

**Under Development**

SUrvivor is currently in development. Features and implementation details may be updated as the project progresses.

---

Developed for the Sabancı University community.
