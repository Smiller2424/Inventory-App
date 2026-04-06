# inventory_app

# Task Management App (Firebase)

## Overview
This application is a task management app built using Flutter and Firebase. Users can create, update, and delete tasks with real-time synchronization using Firestore.

## Features
- Add new tasks
- Mark tasks as completed using a checkbox
- Delete tasks
- Real-time updates using StreamBuilder
- User authentication (login, register, logout)

## Technologies Used
- Flutter
- Firebase Firestore (NoSQL database)
- Firebase Authentication

## How It Works
The app uses Firestore to store task data. A StreamBuilder listens to changes in the database and updates the UI automatically. Firebase Authentication ensures that users can securely log in and manage their tasks.

## Validation
Input validation is implemented to prevent users from adding empty tasks.

## How to Run
1. Clone the repository
2. Run `flutter pub get`
3. Run `flutter run`

## APK
The APK file is included for testing on Android devices.

## Reflection
This project helped me understand how to integrate Firebase with Flutter, manage real-time data using streams, and structure an application using models and service layers. I also learned how to implement user authentication and validate user input.