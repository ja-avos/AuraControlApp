// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Aura Control';

  @override
  String get settings => 'Configuración';

  @override
  String get language => 'Idioma';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get robotIp => 'IP del Robot';

  @override
  String get logs => 'Registros';

  @override
  String get categories => 'Categorías';

  @override
  String get commands => 'Comandos';

  @override
  String get execute => 'Ejecutar';

  @override
  String get info => 'Información';

  @override
  String get warning => 'Advertencia';

  @override
  String get error => 'Error';

  @override
  String get all => 'Todo';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get noConnection => 'No se puede conectar al robot. Por favor, verifica la dirección IP y asegúrate de que el robot esté encendido.';

  @override
  String get retryConnection => 'Reintentar Conexión';

  @override
  String get editRobotIp => 'Editar IP del Robot';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get sshUser => 'Usuario SSH';

  @override
  String get sshPassword => 'Contraseña SSH';

  @override
  String get editSshUser => 'Editar Usuario SSH';

  @override
  String get editSshPassword => 'Editar Contraseña SSH';

  @override
  String get remoteCommandsDir => 'Directorio Remoto de Comandos';

  @override
  String get editRemoteCommandsDir => 'Editar Directorio Remoto de Comandos';

  @override
  String get resetToDefaults => 'Restablecer a valores predeterminados';

  @override
  String get resetConfirmation => '¿Está seguro de que desea restablecer todas las configuraciones a sus valores predeterminados?';

  @override
  String get confirm => 'Confirmar';

  @override
  String get pingInterval => 'Intervalo de Ping';

  @override
  String get enterPingInterval => 'Ingrese el Intervalo de Ping';
}
