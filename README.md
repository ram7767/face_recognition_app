# Face Recognition Flutter App

A Flutter application that provides face registration and verification functionality using a FastAPI backend.

## Features

- **User Registration**: Register new users with their face image and personal details
- **Face Verification**: Verify user identity using face recognition
- **Clean Architecture**: Follows clean architecture principles with proper separation of concerns
- **Permission Handling**: Proper camera and storage permissions
- **Image Selection**: Support for both camera and gallery image selection
- **Error Handling**: Comprehensive error handling and user feedback
- **Loading States**: User-friendly loading indicators

## Architecture

The app follows Clean Architecture with the following layers:

- **Presentation Layer**: UI components, providers, and widgets
- **Domain Layer**: Business logic, entities, and use cases  
- **Data Layer**: Data sources, repositories, and models
- **Core Layer**: Shared utilities, constants, and configurations

## Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (2.17 or higher)
- Android Studio / VS Code
- Running FastAPI backend server

## Setup

1. Run the setup script:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```

2. Update the API base URL in `lib/core/constants/api_constants.dart`:
   ```dart
   static const String baseUrl = 'http://YOUR_API_IP:8000';
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## API Configuration

Make sure your FastAPI server is running and accessible. Update the `baseUrl` in `api_constants.dart` to match your server's IP address.

## Permissions

The app requires the following permissions:
- Camera access for taking photos
- Storage access for selecting images from gallery
- Internet access for API communication

## Dependencies

- `http`: HTTP client for API calls
- `dio`: Advanced HTTP client with interceptors
- `image_picker`: Image selection from camera/gallery
- `permission_handler`: Runtime permission handling
- `provider`: State management
- `get_it`: Dependency injection

## Project Structure

```
lib/
├── core/
│   ├── constants/     # API constants and configurations
│   ├── errors/        # Custom exceptions and failures
│   ├── network/       # Network utilities
│   ├── utils/         # Helper utilities
│   └── di/           # Dependency injection setup
├── data/
│   ├── datasources/   # Remote data sources
│   ├── models/        # Data models
│   └── repositories/  # Repository implementations
├── domain/
│   ├── entities/      # Business entities
│   ├── repositories/  # Repository interfaces
│   └── usecases/      # Business use cases
└── presentation/
    ├── pages/         # UI pages
    ├── providers/     # State management
    └── widgets/       # Reusable widgets
```
