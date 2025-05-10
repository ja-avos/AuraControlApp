# Aura Control App

Una aplicación de Flutter con buenas prácticas de programación y arquitectura limpia. Esta aplicación es para controlar un robot humanoide Unitree G1 a traves de una conexión SSH al robot. La app debe cumplir con lo siguiente:
    - Debe tener una splash screen.
    - Debe implementar conectividad eventual.
        - En la red de internet conectada, la ip 192.168.123.164 debe responder correctamente un ping. Esto significa que el robot está conectado.
        - Se debe hacer ping a esa IP cada cierto tiempo (configurable) y mantener un indicador en la pantalla del estado de conexión.
        - Si el robot no está conectado, debe aparecer una pantalla que muestre al usuario que no hay conexión e invitar a cambiar de red wifi para escoger la red del robot.
        - Si el robot está conectado, las funciones se habilitan para controlar el robot.
    - Debe ser navegable. Esto debe permitir entrar y salir (con atrás) a las diferentes secciones de la app.
    - Debe tener categorías de comandos en el inicio.
    - Al entrar a una categoría se muestran los comandos disponibles de esa categoría.
    - Las categorías y comandos se extraen de una colección de firestore. Indícame la mejor forma de organizarlo y los pasos para configurar firebase en la web y en la app.
    - Cada comando tiene un nombre, una descripción y un nombre de archivo vinculado, y si es básico o avanzado.
    - Al mostrar los comandos, cada comando debe ser una card donde muestre el nombre y tenga un botón de "Play" rápido. Si se toca Play se ejecuta el comando, si se toca el resto de la card, entra al detalle de la card.
    - En el detalle del comando, se muestra el nombre, la categoría, la descripción, un botón de play (puede ser flotante) y una sección para mostrar el video de lo que hace el comando (esto es un desarrollo futuro).
    - La aplicación debe tener una sección de logs donde se pueden ver todos los logs (y filtros) que se ha generado tanto en la interacción usuario-app y app-robot. Para esto toda la app debe implementar logs significativos y tener un mecanismo de almacenamiento.
    - Debe tener una sección de configuración donde se puede ajustar:
        - Light/Dark/Auto theme.
        - Idioma. En/Es
        - La ip del robot.
        - Tiempo del intervalo del healthcheck al robot (ping a ip).
        - Directorio remoto donde se encuentran los archivos que corresponden a los comandos. Si el robot está conectado, este input debe ser un navegador a la carpeta deseada (utilizando SSH) al robot o permitir la ruta en texto plano.
        - Usuario y contraseña para conexión SSH con el robot.
    - Debe tener una opción de copiar archivos locales del celular al robot a un directorio específico (por defecto el directorio de comandos).
    - Debe tener un botón para conectarse al robot por SSH redireccionando a Termux.
    - Lógica de los comandos:
        - Cada comando tiene un archivo vinculado. Para ejecutar un comando se debe conectar por SSH al robot, dirigirse al directorio de comandos y ejecutar lo siguiente: python3 <archivo_comando> eth0 si es básico. Si es avanzado se ejecuta: <nombre_archivo> que contendría el comando completo.

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

## Future Enhancements
- Add real-time log streaming for debugging.
- Implement video previews for commands in the Command Details screen.
- Integrate advanced analytics for user behavior and app performance.
