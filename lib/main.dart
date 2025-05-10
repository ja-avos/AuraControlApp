import 'package:aura_control/presentation/categories_screen.dart';
import 'package:aura_control/presentation/logs_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'presentation/connectivity_notifier.dart';
import 'data/connectivity_repository_impl.dart';
import 'domain/ping_robot_usecase.dart';
import 'core/logger.dart';
import 'presentation/categories_notifier.dart';
import 'data/categories_repository_impl.dart';
import 'presentation/command_details_screen.dart';
import 'presentation/settings_screen.dart';
import 'presentation/settings_notifier.dart';
import 'data/settings_repository_impl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize the logger
  await Logger().init();
  // Log initialization
  Logger().log('Info', 'App started');

  final connectivityRepository = ConnectivityRepositoryImpl(Connectivity());
  final pingRobotUseCase = PingRobotUseCase(connectivityRepository);
  final categoriesRepository = CategoriesRepositoryImpl(
    FirebaseFirestore.instance,
  );

  final settingsNotifier = SettingsNotifier(
    SettingsRepositoryImpl(FirebaseFirestore.instance),
  );

  // Initialize the settings notifier
  await settingsNotifier.fetchSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) =>
                  ConnectivityNotifier(pingRobotUseCase, settingsNotifier)
                    ..startMonitoring(),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoriesNotifier(categoriesRepository),
        ),
        ChangeNotifierProvider(create: (_) => settingsNotifier),
      ],
      child: const MainApp(),
    ),
  );

  Logger().log(
    'Info',
    'App initialized with providers',
    metadata: {
      'connectivityProvider': 'Initialized',
      'categoriesProvider': 'Initialized',
    },
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/categories',
          builder: (context, state) => const CategoriesScreen(),
        ),
        GoRoute(
          path: '/categories/:categoryId',
          builder: (context, state) {
            final categoryId = state.pathParameters['categoryId']!;
            return CommandsScreen(categoryId: categoryId);
          },
        ),
        GoRoute(
          path: '/commands/:commandId',
          builder: (context, state) {
            final commandId = state.pathParameters['commandId']!;
            return CommandDetailsScreen(commandId: commandId);
          },
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(path: '/logs', builder: (context, state) => const LogsScreen()),
      ],
    );

    return Consumer<SettingsNotifier>(
      builder: (context, settingsNotifier, child) {
        return MaterialApp.router(
          routerConfig: _router,
          theme:
              settingsNotifier.isDarkMode
                  ? ThemeData.dark()
                  : ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode:
              settingsNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('es')],
          locale: Locale(settingsNotifier.language == 'English' ? 'en' : 'es'),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isConnected = context.watch<ConnectivityNotifier>().isConnected;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.appTitle)),
      drawer: SafeArea(
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.settings),
                onTap: () {
                  context.push('/settings');
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.logs),
                onTap: () {
                  context.push('/logs');
                },
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child:
            isConnected
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => context.push('/categories'),
                      child: const Text('Go to Categories'),
                    ),
                    ElevatedButton(
                      onPressed: () => context.push('/settings'),
                      child: const Text('Go to Settings'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<ConnectivityNotifier>()
                            .checkConnectivity();
                      },
                      child: const Text('Check Connection'),
                    ),
                  ],
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.noConnection),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<ConnectivityNotifier>()
                            .checkConnectivity();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.retryConnection,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
