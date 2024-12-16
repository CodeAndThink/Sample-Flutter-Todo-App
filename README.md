# Todo App

This is Todo App using Provider to manager states

## How to dev

Type this command in terminal

```sh
  - chmod +x runner.sh
  - ./runner.sh
```

Or

```sh
  flutter pub get
  flutter gen-l10n
  flutter run
```

Using this command when you want to add some assets (image, font,, etc.)

```sh
  flutter pub run build_runner build --delete-conflicting-outputs
```

## App Running

While running app

<p align="center">
  <img src="screenshots/AppRecord.gif" alt="App Running Record" width="200">
</p>
ScreenShot of app

<p align="center">
  <img src="screenshots/LoginScreen.png" alt="Signin Screen" width="200">
  <img src="screenshots/RegisterScreen.png" alt="Sign up Screen" width="200">
  <img src="screenshots/HomeScreen.png" alt="Home Screen" width="200">
</p>

<p align="center">
  <img src="screenshots/AddNewTaskScreen.png" alt="Detail / Create Screen" width="200">
  <img src="screenshots/HomeScreenVnLanguage.png" alt="Home Screen VN" width="200">
  <img src="screenshots/AddNewTaskScreenVnLanguage.png" alt="Detail / Create Screen VN" width="200">
</p>

### Project Structure

```
$PROJECT_ROOT
├── lib                  # Main application code
│   ├── common           # Reusable UI components (widgets)
│   ├── configs          # Folder stores static variables (e.g., color of buttons)
│   ├── gen              # Folder for generated code (e.g., from build_runner)
│   ├── l10n             # Localization files
│   ├── local            # Folder for communicate with local storages
│   ├── manager          # Folder for managing information (e.g., token, user's last login information)
│   ├── models           # Data models (e.g., User, Note, etc.)
│   ├── network          # Folder for communicate with remote storages
│   ├── theme            # Folder for custom app theme
│   ├── utils            # Folder for reused functions
│   └── views            # Folder for views
├── assets               # Static resources (images, gifs, etc.)
└── pubspec.yaml         # Flutter project configuration file
```
