import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habit_forge/auth/login_screen.dart';
import 'package:habit_forge/auth/signup_screen.dart';
import 'package:habit_forge/profile_screen.dart';
import 'package:habit_forge/progress_screen.dart';
import 'package:habit_forge/reminders_screen.dart';
import 'package:habit_forge/screens/home_screen.dart';
import 'package:habit_forge/screens/tasks_screen.dart';
import 'package:habit_forge/screens/add_task_screen.dart';
import 'package:habit_forge/screens/habit_improvement_screen.dart';
import 'package:habit_forge/providers/habit_provider.dart';
import 'package:habit_forge/providers/auth_provider.dart';
import 'package:habit_forge/providers/analytics_provider.dart';
import 'package:habit_forge/providers/notification_provider.dart';
import 'package:habit_forge/providers/reward_provider.dart';
import 'package:habit_forge/utils/constants.dart';
import 'screens/stats_screen.dart';
import 'screens/rewards_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  // Initialize shared preferences
  final prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(prefs)),
        ChangeNotifierProvider(create: (_) => HabitProvider()),
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(flutterLocalNotificationsPlugin),
        ),
        ChangeNotifierProvider(create: (_) => RewardProvider()),
        ChangeNotifierProxyProvider<HabitProvider, AnalyticsProvider>(
          create: (context) => AnalyticsProvider(context.read<HabitProvider>()),
          update: (context, habitProvider, analyticsProvider) =>
              AnalyticsProvider(habitProvider),
        ),
      ],
      child: MaterialApp(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey[50],
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            elevation: 0,
            foregroundColor: Colors.white,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey[600],
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            elevation: 8,
            type: BottomNavigationBarType.fixed,
          ),
          cardTheme: CardTheme(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        home: const AuthWrapper(),
        routes: {
          '/signup': (context) => const SignupScreen(),
          '/home': (context) => const HomeScreen(),
          '/tasks': (context) => const TasksScreen(),
          '/add-task': (context) => AddTaskScreen(
                habitId: ModalRoute.of(context)?.settings.arguments as String? ?? '',
              ),
          '/habit-improvement': (context) => const HabitImprovementScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/progress': (context) => const ProgressScreen(),
          '/reminders': (context) => const RemindersScreen(),
          '/stats': (context) => const StatsScreen(),
          '/rewards': (context) => const RewardsScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.checkAuthState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isAuthenticated) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
