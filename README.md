# RunSight

[![Flutter](https://img.shields.io/badge/Flutter-3.9-blue.svg)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A smart running assistant Flutter mobile app with AI powered voice guidance and route tracking designed to provide a seamless user experience on both Android and iOS platforms.

---

## Table of Contents

- [About](#about)
- [Features](#features)
- [Screenshots](#screenshots)
- [Getting Started](#getting-started)
- [Installation](#installation)
- [Usage](#usage)
- [Architecture](#architecture)
- [Technologies](#technologies)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

---

## About

RunSight is a cross-platform mobile application built with Flutter, focusing on enhancing running experiences with AI-powered voice guidance, real-time route tracking, and performance analytics. It leverages Flutter’s fast rendering engine to deliver smooth animations and responsive UI.

---

## Features

- Cross-platform support (iOS & Android)
- AI-powered voice guidance using Text-to-Speech
- Real-time route tracking with maps integration
- Performance analytics with charts and statistics
- Image capture for run photos
- User authentication and data synchronization
- Responsive and adaptive UI with custom fonts (Poppins)
- Offline mode support for core features

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

This project follows a modular architectural pattern using:

* `Get` for state management and routing
* `Provider` for additional state management
* `Get_it` for dependency injection
* `pbp_django_auth` for backend authentication
* Modular codebase with separate modules for controllers, presentation, and widgets

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
