# ecommerce_app


Ecommerce App
A Flutter-based ecommerce application built using Clean Architecture. It demonstrates clear separation of concerns and a modular, testable codebase.

 Architecture Overview
This project follows Clean Architecture to separate responsibilities across three layers:
Presentation Layer – Handles UI components.
Domain Layer – Contains business logic and use cases.
Data Layer – Manages data operations such as fetching and storing product information.
Each feature is self-contained, promoting scalability and maintainability.

 Project Structure
lib/
├── core/                # Shared utilities and constants
├── features/            # Feature modules
│   └── products/        # Product-related logic and UI
└── main.dart            # Application entry point


 Data Flow
The user interacts with the UI.The UI forwards actions to the corresponding use case in the Domain Layer.
The use case communicates with a repository that abstracts the data source.The result is passed back to the UI for display.This simple, linear flow helps keep logic predictable and easy to trace.


 Key Components
Product Entity: Represents each product with fields like ID, name, description, image URL, and price.
Use Cases: Includes Create, Read (all and specific), Update, and Delete operations.
Repository Abstraction: Decouples data sources from business logic, allowing flexibility and testability.

 Testing
The project includes unit tests for use cases and models using mock JSON data to ensure functionality and stability.

Getting Started
git clone https://github.com/hilinaz/2025-project-phase-mobile-tasks/tree/task_10
cd ecommerce_app
flutter pub get
flutter run














## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



