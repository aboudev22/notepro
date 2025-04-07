# notepro

**notepro** is a web application that allows users to share reviews and ratings about services and products offered by companies in Cameroon. The goal of this project is to provide a platform where users can consult and publish feedback to assist in decision-making.

## Features

- Share reviews and ratings about services and products.
- Browse reviews published by other users.
- User management with Firebase Authentication.
- Data storage using Firebase Firestore.
- Modern and responsive user interface powered by Flutter.

## Technologies Used

- **[Flutter](https://flutter.dev/)**: Framework for cross-platform development.
- **[Firebase](https://firebase.google.com/)**:
  - **Firebase Core**: Firebase initialization.
  - **Firebase Authentication**: User management.
  - **Cloud Firestore**: NoSQL database for storing reviews.
- **[Flutter Riverpod](https://riverpod.dev/)**: State management.
- **[GoRouter](https://pub.dev/packages/go_router)**: Navigation management.

## Installation and Setup

1. Clone this repository:
   `git clone https://github.com/your-username/notepro.git`
   `cd notepro`

2. Install Flutter dependencies:
   `flutter pub get`

3. Configure Firebase:

   - Follow the instructions in `FlutterFire` to set up Firebase for your project.
   - Populate the `firebase_options.dart` file generated automatically.

4. Run the application:
   `flutter run -d chrome`

## Project Structure

    - lib/main.dart : Entry point of the application.
    - lib/firebase_options.dart : Firebase configuration file.
    - web/ : Files specific to the web version.
    - pubspec.yaml : List of project dependencies.
