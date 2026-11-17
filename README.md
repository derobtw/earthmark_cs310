# 🌍 Earthmark

*CS310 – Mobile Application Development | Sabancı University*

*Group 27 | Fall 2026*

## About the Project

Earthmark is a Flutter-based mobile application that helps users track and visualize their travel experiences on a world map.

With Earthmark, users build a personal travel map by marking the countries they have already visited (*Been*) and the ones they hope to visit in the future (*Wish*).

The application makes travel tracking easy, visual, and accessible through an interactive 2D world map, continent-based views, and personal travel notes. All data is stored locally on the device.

## ✨ Features

### 1. Country Tracking
- Mark any of the **195 countries** as *Been* (visited) or *Wish* (want to visit).
- A country can only be in one list at a time; saving it again replaces its previous status.
- Change a country's status or remove it at any time.
- Search countries by name (also works without special letters, e.g. `turkiye` → Türkiye, `cote` → Côte d'Ivoire).

### 2. Interactive 2D World Map
- World map with country boundaries, drawn with `countries_world_map`.
- *Been* countries are **green**, *Wish* countries are **blue**, unselected countries stay **grey**.
- Zoom with the **+ / −** buttons or with pinch gestures.
- Map colors update immediately whenever a status is added, changed, or removed.

### 3. Travel Statistics
- **Countries Visited:** number of unique *Been* countries (*Wish* is not counted).
- **World Explored:** *Been* countries ÷ 195 countries in the app's dataset, shown as a percentage.
- Statistics, filter counts and the summary strip update automatically.

### 4. Continent-Based Views
- Choose Africa, Asia, Europe, North America, South America, or Oceania from a dropdown.
- The map focuses on the selected continent and keeps the same colors as the world map.

### 5. Personal Travel Notes
- Add a short note (max. **200 characters**, with a live counter) to *Been* countries.
- Edit or clear the note; the date of the last edit is shown.

### 6. Local Data Storage
- Country selections, statuses, notes, and note dates are saved on the device with `shared_preferences`.
- Data is kept between application sessions; no account or cloud database is used.

---

## 📱 Screens

| # | Screen | Main elements | File | Developer |
|---|---|---|---|---|
| 1 | Home / World Map | World map, zoom buttons, legend, statistic cards | `home_screen.dart` | Arda Kalyoncu |
| 2 | Country Selection | Searchable country list, Been / Wish cards, validation, save dialog | `country_selection_screen.dart` | Nil Kadakal |
| 3 | Continent Map | Continent dropdown, focused map, legend | `continent_map_screen.dart` | Arda Kalyoncu |
| 4 | Country Details | Country image, Wikipedia link, status buttons, notes, remove | `country_details_screen.dart` | Nil Kadakal |
| 5 | My Countries | Country cards, All / Been / Wish filter, search, summary strip | `my_countries_screen.dart` | Derin Alaçal |

**Screen states:** inline validation errors (Screen 2), save confirmation dialog (Screen 2), remove confirmation dialog (Screens 4 and 5), and the note editor bottom sheet (Screen 4).

**Navigation:** a bottom navigation bar (*World · Continents · My Countries*) is available on Screens 1, 3, 4, and 5. The *+ Add Country* buttons on Screens 1, 3, and 5 open Screen 2; tapping a country card opens Screen 4.

---

## 🛠️ Technologies

| Technology | Purpose |
|---|---|
| Flutter | Mobile application development |
| Dart | Programming language |
| [countries_world_map](https://pub.dev/packages/countries_world_map) | 2D world map rendering and country coloring |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | Saving country selections and personal notes on the device |
| [url_launcher](https://pub.dev/packages/url_launcher) | Opening a country's Wikipedia page from Country Details |
| Git & GitHub | Version control and team collaboration |

### Map Implementation

Earthmark uses the **[countries_world_map](https://pub.dev/packages/countries_world_map)** package to display its 2D world map. Countries are identified by their ISO two-letter codes and colored individually based on their *Been* or *Wish* status.

The package provides a world map but no separate continent maps, so the continent views use the **same world map data** and zoom the view to the selected continent's area. This keeps colors and data identical on both screens.

*No external map API, remote database, or user authentication is used.*

**Known limitations**
- Seven very small countries (Andorra, Kiribati, Liechtenstein, Monaco, San Marino, Singapore, Vatican City) are not drawn by the map package. They can still be saved and are counted in the statistics.
- The header image on Country Details shows the country's flag (loaded from the network) instead of a photo.

---

## 📱 Application Workflow

1. The user opens Earthmark and sees the world map with the travel statistics.
2. The user taps *+ Add Country*, searches for a country, and marks it as *Been* or *Wish*.
3. The country is highlighted on the world and continent maps, and the statistics update.
4. If the country is marked as *Been*, the user can add a short travel note.
5. In *My Countries*, the user can filter, search, open a country's details, change its status, or remove it.
6. All selections and notes are saved locally and are available the next time the app is opened.

---

## 📂 Project Structure

```
lib/
├── main.dart                     # App entry point, loads saved data
├── data/                         # Country dataset (195) and TravelData (state + local storage)
├── models/                       # Country, SavedCountry
├── navigation/                   # MainShell (bottom navigation), AppNavigator
├── screens/                      # The five screens
├── utils/                        # AppTheme / AppColors, search, continents, dates
└── widgets/                      # Map, cards, dialogs, note editor, bottom navigation…
assets/images/                    # App logo
test/                             # Unit tests
```

---

## 🚀 Getting Started

**Requirements:** Flutter SDK (stable, 3.47 or newer) and Android Studio with the Flutter and Dart plugins.

```bash
git clone https://github.com/derobtw/earthmark_cs310
cd earthmark_cs310
flutter create . --project-name earthmark --org com.example
flutter pub get
flutter run
```

`flutter create .` generates the platform build files (Gradle etc.) that are not stored in this repository; it does not overwrite the existing source code, logo, or app icons.

On **Windows**, enable *Developer Mode* first (`start ms-settings:developers`); Flutter plugins need it.

Run the tests with:

```bash
flutter test
```

---

## 📌 Project Status

*Status: In development — all five screens implemented*

- ✅ Step 1 – Project proposal
- ✅ Step 2.1 – Wireframes and navigation flow (see `project_steps/`)
- ✅ Implementation of all five screens, dialogs, maps, and local storage

---

## 👥 Team Members

*Group Number: 27*

| Name | Student ID | Contribution |
|---|---|---|
| Derin Alaçal | 35835 | My Countries screen, country cards, app theme, bottom navigation, shared navigation |
| Nil Kadakal | 33796 | Country Selection and Country Details screens, dialogs, note editor |
| Arda Kalyoncu | 34043 | Home / World Map and Continent Map screens, map widget |

---

## 📌 Repository

This repository contains the source code and documentation for the Earthmark mobile application.

Developed for *CS310 – Mobile Application Development*, Sabancı University, Fall 2026.
