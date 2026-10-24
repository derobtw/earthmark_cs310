# 🌍 Earthmark  🌍

**CS310 – Mobile Application Development | Sabancı University**

**Group 30 | Fall 2026**

## About the Project

Earthmark is a Flutter-based mobile application designed to help users track and visualize their travel experiences on a world map.

Inspired by the *Been* application, Earthmark provides a simple way to mark countries users have visited (**Been**) and countries they wish to visit (**Wish**).

The application aims to make travel tracking easy, visual, and accessible through an interactive 2D world map, continent-based views, and personal travel notes.

##  Planned Features

### 1. Country Tracking
- Mark countries as **Been** (visited) or **Wish** (want to visit).
- Update or remove country selections.
- View selected countries on a world map.

### 2. Interactive 2D World Map
- Display a world map with country boundaries.
- Highlight countries using two different colors:
  - **Been:** Green
  - **Wish:** Blue
- Keep unselected countries in a neutral color.
- Automatically update the map when a country's status changes.

### 3. Travel Statistics
- Display the total number of visited countries.
- Calculate the percentage of the world's countries visited.
- Update statistics automatically when users modify their selections.

### 4. Continent-Based Views
- Explore individual continents through a dedicated map screen.
- View visited and wishlist countries within each continent.
- Maintain consistent country colors across world and continent maps.

### 5. Personal Travel Notes
- Add short notes to visited countries.
- Edit or delete existing notes.
- Save personal travel memories alongside country selections.

### 6. Local Data Storage
- Store country selections and travel notes locally on the device.
- Keep saved information available between application sessions.
- Use the application without requiring an account or cloud database.

---

## Technologies

| Technology | Purpose |
|---|---|
| Flutter | Mobile application development |
| Dart | Programming language |
| countries_world_map | 2D world map rendering and country coloring |
| Local Storage | Saving country selections and personal notes |
| Git & GitHub | Version control and team collaboration |

### Map Implementation

Earthmark will use the **[countries_world_map](https://pub.dev/packages/countries_world_map)** Flutter package to display and manage its 2D world map.

The package provides predefined country boundaries, allowing countries to be identified by their country codes and colored individually based on their Been or Wish status.

Continent-based views will be implemented using the same map data, focusing on the selected continent.

**No external map API, remote database, or user authentication is planned.** User information will be stored locally on the device.

---

##  Application Workflow

1. The user opens Earthmark and views the world map.
2. The user selects a country from the country list.
3. The country is marked as **Been** or **Wish**.
4. The selected country is highlighted on the map.
5. If marked as Been, the user can add a short travel note.
6. The application updates the visited country count and world percentage.
7. The user can switch to continent-based views to explore their travel progress.
8. All selections and notes are saved locally.

---

## Project Status

**Status: Planning and Development**

Earthmark is being developed as a semester project for CS310 – Mobile Application Development at Sabancı University.

The project will be implemented progressively throughout the semester using Flutter and Dart.

---

## Team Members

**Group Number: 30**

| Name | Student ID |
|---|---|
| Derin Alaçal | 35835 |
| Nil Kadakal | 33796 |
| Arda Kalyoncu | 34043 |

All team members will contribute to the development, testing, and documentation of the application.

---

##  Repository

This repository contains the source code and documentation for the Earthmark mobile application.

**GitHub:** https://github.com/derobtw/earthmark_cs310

Developed for **CS310 – Mobile Application Development**, Sabancı University, Fall 2026.
