
# CS310 Project Step 1 Proposal: SUrvivor

## 1. Project Title and Group Details

**Application name:** SUrvivor

**Group number:** 12

**Step 1 coordinator:** Asude Betül Öztürk

**Members:**
- Zeynep Altundal: 31978
- Asude Betül Öztürk: 34170
- Esra Yağışan: 34212
- İkranur Toksöz: 33928

**GitHub repository:** https://github.com/ikranurtoksoz/CS310

## 2. App Overview

SU Campus Companion is a Flutter-based mobile application that centralizes transportation and dining information at Sabancı University.

**Problem:** Transportation schedules and campus dining information are distributed across multiple sources, requiring users to consult separate platforms for essential daily information.

**Solution:** The application provides a unified interface displaying shuttle and KM18 schedules, destinations, fares, and daily menus and prices across campus dining facilities.

**Target Users:** Sabancı University students, faculty

## 3. Core Features and Optional Features

### Core Features

1. **Transport timetable:** Shuttle and KM18 departures, with time and fare, and weekday/weekend schedules.
2. **Next departure:** The next 2–3 departures from campus and from each destination, based on the current time.
3. **Daily menus:** Today's menu and prices for Yemekhane, Küçükev, and Piazza, one tab per location.
4. **Search and filter:** By destination, time window, and menu item name.

### Optional Features

- Weekly menu view
- Cleaning and bed linen change schedules for the dormitories
- Turkish/English toggle

## 4. Data Requirements

| Data | Fields | Storage |
|---|---|---|
| Shuttle & KM18 timetable | route, departure time, day type, fare | Firebase Firestore |
| Daily menus | location, date, meal, item name, price | Firebase Firestore |

**Database:** Firebase Firestore.

**External API:** None required; no suitable public API has been identified yet.

**Data entry:** Firestore is the single source the app reads from. It will be filled in two ways: (1) a small Python script that parses the university's public shuttle and menu pages where their format allows it, and (2) a manual update path (a simple admin form or direct Firestore edit) for cafés whose menus are only posted on-site or published as images. Data sources will be verified during Step 2; the app works regardless of which path is used. Durations are team estimates and will be labelled as approximate.

## 5. Potential Challenges

1. **Unverified data sources.** Pages may change layout, publish menus as PDFs/images, or update late. *Mitigation:* Manual update path (Section 4); validate data before writing; show the record's date in the app.

2. **Fares and durations.** Fares change each semester; durations are not published. *Mitigation:* Editable fields, estimates labelled as approximate.

3. **Time logic.** Weekday/weekend schedules, holidays, and device local time in "next departure". *Mitigation:* Unit tests with fixed timestamps.

4. **Offline caching.** Keeping cached data and "last updated" state consistent. *Mitigation:* Cache-first read with background refresh.

5. **Coordination.** One Flutter codebase, four members. *Mitigation:* Feature branches, pull requests, GitHub project board.

## 6. Team Coordination and Responsibilities

**Step 1 coordinator:** Asude Betül Öztürk organizes meetings, assigns tasks, and communicates with the assigned TA.

| Member | Step 1 tasks |
|---|---|
| Zeynep Altundal | App overview, core/optional feature scope, data-source survey |
| İkranur Toksöz | GitHub repository setup (collaborators, README, Flutter .gitignore, initial commit) |
| Esra Yağışan | Data requirements and Firebase/Firestore data model |
| Asude Betül Öztürk | Potential challenges, proposal formatting and final PDF, submission on SUCourse |
