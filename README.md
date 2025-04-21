# WorkWave

A Flutter-based freelancing platform that connects clients with skilled freelancers.

## Features

- User Authentication (Freelancer & Client)
- Profile Management
- Job Posting and Bidding
- Real-time Messaging
- Payment Integration
- Activity Tracking
- Portfolio Management

## Getting Started

### Prerequisites

- Flutter SDK (version 3.7.2 or higher)
- Dart SDK (version 3.7.2 or higher)
- Android Studio / VS Code
- Firebase Account

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/workwave.git
cd workwave
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Create a new Firebase project
   - Add Android app with package name `com.example.workwave`
   - Download `google-services.json` and place it in `android/app/`
   - Enable Authentication and Firestore in Firebase Console

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── models/         # Data models
├── screens/        # UI screens
├── widgets/        # Reusable widgets
├── providers/      # State management
├── services/       # Business logic
├── utils/          # Utility functions
└── routes.dart     # Navigation routes
```

## Dependencies

- `provider`: State management
- `get`: Navigation and dependency injection
- `firebase_core`: Firebase initialization
- `firebase_auth`: Authentication
- `cloud_firestore`: Database
- `flutter_secure_storage`: Secure storage
- `image_picker`: Image selection
- `cached_network_image`: Image caching
- `flutter_svg`: SVG support
- `url_launcher`: URL handling
- `intl`: Internationalization
- `fl_chart`: Charts and graphs

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
