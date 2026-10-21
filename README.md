
# SUrvivor

### Your Ultimate Sabancı University Campus Companion

**SUrvivor** is a Flutter-based mobile application designed to make everyday campus life easier for Sabancı University students and faculty.

From catching the next shuttle to deciding what to eat, SUrvivor brings essential campus information together in one convenient place.

## About the Project

Campus life shouldn't require checking multiple websites and platforms just to plan your day.

SUrvivor provides a centralized platform where users can easily access transportation schedules, dining menus, and other useful campus information.

Our goal is to create a simple, accessible, and user-friendly mobile application that helps the Sabancı University community navigate daily campus life more efficiently.

## Features

### Transportation

- **Shuttle & KM18 Schedules:** View departure times, routes, destinations, and fares.
- **Next Departures:** Quickly check the next 2–3 departures based on the current time.
- **Weekday & Weekend Schedules:** Access schedules according to the day.
- **Search & Filter:** Find transportation options by destination and departure time.

### Campus Dining

- **Daily Menus:** Explore today's food options across campus.
- **Dining Locations:** Access menus from:
  - Yemekhane
  - Küçükev
  - Piazza
- **Menu Prices:** Check available food items and their prices.
- **Search:** Find specific menu items easily.

### Planned Additional Features

- Weekly dining menus
- Dormitory cleaning and bed linen change schedules
- Turkish/English language support

## Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform mobile application development |
| Dart | Application programming language |
| Firebase Firestore | Cloud database for transportation and dining information |
| Python | Parsing publicly available university schedule and menu data |
| Git & GitHub | Version control and team collaboration |

## Data Management

SUrvivor uses **Firebase Firestore** to store and manage campus information.

| Data | Fields | Storage |
|---|---|---|
| Shuttle & KM18 Timetables | Route, departure time, day type, fare | Firebase Firestore |
| Daily Menus | Location, date, meal, item name, price | Firebase Firestore |

### Data Sources

Campus information is planned to be collected through two methods:

1. **Automated Data Collection:** Python scripts to retrieve transportation schedules and dining information from publicly available university sources where possible.
2. **Manual Updates:** Direct Firestore updates or an admin interface for information that cannot be collected automatically.

This approach aims to keep the application flexible and its information up to date.

## Project Goals

- Simplify everyday campus life.
- Centralize essential university information.
- Reduce the time spent searching across different platforms.
- Provide an intuitive and accessible mobile experience.
- Build a scalable application that can support additional campus services in the future.

## Development Team

| Team Member |
|---|
| Zeynep Altundal |
| Asude Betül Öztürk |
| Esra Yağışan |
| İkranur Toksöz |

## Project Status

**Under Development**

SUrvivor is currently being developed as part of the **CS310 Mobile Application Development** course at Sabancı University.

Features and functionality will be expanded throughout the development process.
