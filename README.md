# Aura Control App

## Flutter Application for Unitree G1 Robot Control

This Flutter application is designed to control a Unitree G1 humanoid robot via an SSH connection. It adheres to clean architecture principles and incorporates best programming practices. Below are the key features and requirements of the app:

### Features and Requirements

1. **Splash Screen**:
    - The app should display a splash screen during startup.

2. **Connectivity Management**:
    - The app must implement periodic connectivity checks.
    - The robot's IP address (`192.168.123.164`) should respond to a ping to confirm connectivity.
    - A configurable interval should determine how often the ping is sent.
    - The app should display a connection status indicator on the screen.
    - If the robot is not connected:
      - Show a screen informing the user of the disconnection.
      - Prompt the user to switch to the robot's Wi-Fi network.
    - If the robot is connected:
      - Enable the app's control functions.

3. **Navigation**:
    - The app should support seamless navigation between different sections, with proper back navigation.

4. **Command Categories**:
    - The home screen should display categories of commands.
    - Upon selecting a category, the available commands within that category should be displayed.

5. **Command Management**:
    - Commands and categories should be stored in a Firestore collection.
    - Each command should include:
      - A name.
      - A description.
      - A linked file name.
      - A type (basic or advanced).
    - Commands should be displayed as cards:
      - Each card should show the command name and include a "Play" button for quick execution.
      - Tapping the card (outside the "Play" button) should navigate to the command's detail screen.
    - The command detail screen should display:
      - The command name.
      - The category.
      - The description.
      - A floating "Play" button.
      - A placeholder for a video preview (future enhancement).

6. **Logs Section**:
    - The app should include a logs section to display all logs generated from user-app and app-robot interactions.
    - Logs should be meaningful and stored persistently.
    - Provide filtering options for logs.

7. **Settings Section**:
    - The app should include a settings section to configure:
      - Theme (Light/Dark/Auto).
      - Language (English/Spanish).
      - Robot's IP address.
      - Health check interval (ping frequency).
      - Remote directory for command files (with SSH-based folder navigation or plain text input).
      - SSH username and password for robot connection.

8. **File Management**:
    - The app should allow copying local files from the device to a specific directory on the robot (defaulting to the commands directory).

9. **SSH Integration**:
    - Include a button to connect to the robot via SSH, redirecting to Termux.

10. **Command Execution Logic**:
     - Each command is linked to a file.
     - To execute a command:
        - Connect to the robot via SSH.
        - Navigate to the commands directory.
        - Run the following:
          - For basic commands: `python3 <command_file> eth0`.
          - For advanced commands: Execute the file directly (`<command_file>`), which contains the full command.

### Firestore Organization and Firebase Configuration

1. **Firestore Structure**:
    - Use the following structure for storing categories and commands:
      ```
      categories/
         <category_id>/
            name: <category_name>
            commands/
              <command_id>/
                 name: <command_name>
                 description: <command_description>
                 file_name: <file_name>
                 type: <basic|advanced>
      ```

2. **Firebase Configuration**:
    - Follow these steps to configure Firebase for the app:
      - Set up a Firebase project in the [Firebase Console](https://console.firebase.google.com/).
      - Add the app to the Firebase project (for Android, iOS, and Web platforms).
      - Download the `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files and place them in the respective directories.
      - For the web, configure Firebase in the `firebase_options.dart` file.
      - Enable Firestore in the Firebase Console and set up the database rules.

### Future Enhancements

- Add real-time log streaming for debugging.
- Implement video previews for commands in the Command Details screen.
- Integrate advanced analytics to monitor user behavior and app performance.
- Expand support for additional languages and themes.

This application aims to provide a robust and user-friendly interface for controlling the Unitree G1 robot while maintaining high standards of code quality and architecture.

## Clean Architecture
The Aura Control App follows the principles of Clean Architecture to ensure scalability, maintainability, and testability. The architecture is divided into three main layers:

1. **Presentation Layer**:
   - Contains UI components such as screens and widgets.
   - Includes state management using `Provider` for reactive updates.
   - Example: `connectivity_notifier.dart` for managing connectivity state.

2. **Domain Layer**:
   - Contains the business logic of the application.
   - Includes use cases and abstract repositories.
   - Example: `ping_robot_usecase.dart` for handling robot connectivity checks.

3. **Data Layer**:
   - Responsible for data handling and communication with external sources.
   - Includes implementations of repositories, services, and data sources.
   - Example: `connectivity_repository_impl.dart` for managing network connectivity.

## Project Structure
The project is organized into the following directories:

- **core/**: Contains shared utilities and services, such as the `Logger` for logging.
- **data/**: Implements repositories, services, and data sources.
- **domain/**: Contains use cases and abstract repository definitions.
- **presentation/**: Includes UI components and state management.
- **assets/**: Stores static assets like images and icons.
- **android/**, **ios/**, **web/**, **linux/**, **macos/**, **windows/**: Platform-specific configurations and code.

## Good Practices
1. **State Management**:
   - Use `Provider` for managing state across the app.
   - Ensure state changes are reactive and efficient.

2. **Logging**:
   - Use the `Logger` class to log events locally and in Firebase.
   - Follow the defined logging levels: Info, Warning, and Error.

3. **Separation of Concerns**:
   - Keep UI, business logic, and data handling in separate layers.
   - Use dependency injection to decouple components.

4. **Scalability**:
   - Design the app to easily add new features or modify existing ones.
   - Use Firestore for dynamic data storage and retrieval.

5. **Testing**:
   - Write unit tests for use cases and repository implementations.
   - Test UI components to ensure a seamless user experience.

6. **Localization**:
   - Support multiple languages (e.g., English and Spanish).
   - Use a centralized localization file for managing translations.

7. **Theming**:
   - Support Light, Dark, and Auto themes.
   - Use `ThemeData` for consistent styling across the app.

8. **Error Handling**:
   - Handle errors gracefully and provide meaningful feedback to users.
   - Log errors for debugging and analysis.

## Firebase Integration
- Firestore is used for storing categories, commands, and logs.
- Firebase Authentication can be added for user management (future enhancement).
- Follow the steps in `firebase_options.dart` for configuration.
