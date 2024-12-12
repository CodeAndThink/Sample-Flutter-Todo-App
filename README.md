# Todo App

This is Todo App using Provider to manager states

## How to dev
type this command in terminal
```sh
  - chmod +x runner.sh
  - ./runner.sh
```
or 
```sh
  flutter pub get
  flutter gen-l10n
  flutter run
```
using this command when you want to add some assets (image, font,, etc.)
```sh
  flutter pub run build_runner build --delete-conflicting-outputs
```

## App Running

While running app

<img src="screenshots/AppRecord.gif" alt="App Running Record" width="400">

ScreenShot of app

<img src="screenshots/LoginScreen.png" alt="Signin Screen" width="400">
<img src="screenshots/RegisterScreen.png" alt="Sign up Screen" width="400">
<img src="screenshots/HomeScreen.png" alt="Home Screen" width="400">
<img src="screenshots/AddNewTaskScreen.png" alt="Detail / Create Screen" width="400">
<img src="screenshots/HomeScreenVnLanguage.png" alt="Home Screen" width="400">
<img src="screenshots/AddNewTaskScreenVnLanguage.png" alt="Detail / Create Screen" width="400">

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
│   ├── utilities        # Folder for reused functions
│   └── views            # Folder for views
├── assets               # Static resources (images, gifs, etc.)
└── pubspec.yaml         # Flutter project configuration file
```
