# RunSight

[![Flutter](https://img.shields.io/badge/Flutter-3.9-blue.svg)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A smart running assistant Flutter mobile app with AI powered voice guidance and route tracking designed to provide a seamless user experience on both Android and iOS platforms.

---

## Table of Contents

- [About](#about)
- [Features](#features)
- [Getting Started](#getting-started)
- [Installation](#installation)
- [Usage](#usage)
- [Architecture](#architecture)
- [Technologies](#technologies)
- [Contributing](#contributing)
- [License](#license)

---

## About

RunSight is a smart running assistance system consisting of a Flutter mobile app that pairs with IoT smart glasses for AI-powered running guidance. The system features autonomous IoT devices that provide real-time voice navigation and obstacle detection, while the mobile app serves as a companion for viewing run history, statistics, and device management. The architecture follows an offline-first approach where runs are processed locally on the IoT device and synced to the backend when connectivity is available.

---

## Features

### Mobile App
- Cross-platform support (iOS & Android)
- Device pairing with IoT smart glasses via 6-digit codes
- Run history and performance analytics with charts
- Real-time device status monitoring (battery, sync status)
- User authentication and profile management
- Responsive UI with custom fonts (Poppins)

### IoT Integration
- Autonomous running sessions on smart glasses
- AI-powered obstacle detection and voice guidance
- Local data processing with offline-first architecture
- Automatic data synchronization when connected
- Real-time telemetry and frame processing

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.9 or above)
- Android Studio or VS Code with Flutter & Dart plugins
- An Android/iOS device or emulator

---

### Installation

1. Clone the repo

```bash
git clone https://github.com/labmino/labmino_app.git
cd labmino_app
```

2. Install dependencies

```bash
flutter pub get
```

3. Run the app

```bash
flutter run
```

---

## Usage

After launching the app, you can:

* Register or log in to your account
* Start a run with voice-guided instructions
* Track your route in real-time on the map
* View performance charts and statistics
* Capture and save run photos
* Sync data across devices

---

## Architecture

RunSight follows a distributed architecture with three main components:

### System Components
- **IoT Smart Glasses**: Autonomous devices running local AI models for real-time obstacle detection and voice guidance
- **Mobile App**: Flutter companion app for device management, run history, and analytics
- **Backend API**: RESTful service (http://localhost:8080/api/v1) handling authentication, device pairing, and data synchronization
- **Database**: PostgreSQL for storing user data, device information, and run metrics

### Mobile App Architecture
* `Get` for state management and routing
* `Provider` for additional state management
* `Get_it` for dependency injection
* `pbp_django_auth` for backend authentication
* Modular codebase with separate modules for controllers, presentation, and widgets

### Core Principles
- **IoT Autonomy**: Runs start/stop on device; mobile app not required for sessions
- **Offline-First**: IoT devices store runs locally and sync when network available
- **Stateless Backend**: No persistent server-side sessions
- **Mobile View-Only**: App primarily reads history and manages devices

---

## Technologies

* [Flutter](https://flutter.dev)
* [Dart](https://dart.dev)
* [Get](https://pub.dev/packages/get)
* [Provider](https://pub.dev/packages/provider)
* [Flutter Map](https://pub.dev/packages/flutter_map)
* [Flutter TTS](https://pub.dev/packages/flutter_tts)
* [FL Chart](https://pub.dev/packages/fl_chart)
* [Image Picker](https://pub.dev/packages/image_picker)
* [Cached Network Image](https://pub.dev/packages/cached_network_image)
* [Google Fonts](https://pub.dev/packages/google_fonts)
* [Lottie](https://pub.dev/packages/lottie)

---

## Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please ensure your code follows the existing style and is well-documented.

---

## License

Distributed under the MIT License. See `LICENSE` for more information.
