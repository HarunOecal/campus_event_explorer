# Campus Event Explorer

## BIM493 - Mobile Programming I
**Assignment #1 | 2026–2027**

## Project Overview

Campus Event Explorer is a Flutter mobile application designed to help university students discover campus events, save their favorite events, and manage their participation.

The application works offline using fictional event data stored locally in Dart.

## Features

- Six campus events across Technology, Arts, and Sports categories
- Event search with case-insensitive matching
- Combined search and category filtering
- Explore, Favorites, and My Events navigation
- Adding and removing favorite events
- Detailed event information
- Double-tap image enlargement
- Event participation and cancellation with confirmation dialogs
- Automatic capacity updates
- Prevention of participation in full events
- Empty-state messages and event counters
- Local images and Poppins custom font

## Technologies

- Flutter 3.47.6 (Stable)
- Dart 3.13.5
- Material Design 3
- Local Dart event data
- In-memory state management using setState

## Project Structure

```text
lib/
├── main.dart
├── models/
│   └── event.dart
├── data/
│   └── events.dart
├── screens/
│   └── event_details.dart
└── widgets/
    └── event_card.dart

assets/
├── images/
└── fonts/

screenshots/
```

## Installation

Install Flutter 3.47.6 Stable and configure the development environment.

From the project root, run:

```bash
flutter pub get
flutter run
```

For browser testing:

```bash
flutter run -d chrome
```

To build an Android debug APK:

```bash
flutter build apk --debug
```

## Flutter Version

```text
Flutter 3.47.6 • channel stable
Dart 3.13.5
DevTools 2.60.0
```

The full `flutter --version` output should also be included here.

## Team Members and Contributions

**Student 1:** Harun Halil Öcal  
**Student ID:** 23063487564
**Contribution:** Everything 



## Screenshots

- `screenshots/localhost_51560_(Pixel 7) (1)`
- `screenshots/localhost_51560_(Pixel 7) (2)`
- `screenshots/localhost_51560_(Pixel 7) (3)`
- `screenshots/localhost_51560_(Pixel 7) (4)`
- `screenshots/localhost_51560_(Pixel 7) (5)`

## Testing Checklist

- [] Full events cannot be joined.
- [] The last available place can be joined.
- [] Cancellation restores the available place.
- [] Confirmation dialog cancellation does not change participation.
- [] Empty searches display a message.
- [] Search and category filters work together.
- [] Favorites remain consistent between screens.
- [] Image enlargement and Back navigation work.
- [] Android debug APK builds successfully.

## Asset Credits

- Technology image: Google Photos and ChatGPT5.5
- Arts image: Google Photos and ChatGPT5.5
- Sports image: Google Photos and ChatGPT5.5
- Poppins font: Google Fonts, SIL Open Font License 1.1

Include the relevant image and font license files when redistribution requires them.

## Known Limitations

- Event data is fictional.
- Favorites and participation are stored in memory and may reset after restarting.
- No backend, database, authentication or internet connection is required.
- Android APK compilation succeeded, but physical-device testing has not yet been confirmed.