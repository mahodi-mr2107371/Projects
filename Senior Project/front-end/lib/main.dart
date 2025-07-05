// Import necessary packages for Flutter application
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdp/repo/user_repo.dart';
import 'package:sdp/screens/home_page.dart';
import 'package:sdp/screens/shell_screen.dart';
import 'package:sdp/screens/welcome_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

/// Application entry point
/// Initializes Supabase connection and starts the Flutter application
Future<void> main() async {
  // Ensure Flutter widgets are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Supabase client with project URL and anonymous key
    await Supabase.initialize(
      url: 'https://tmutvbrvfdcmzggkrdkf.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRtdXR2YnJ2ZmRjbXpnZ2tyZGtmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU5MzUzMjgsImV4cCI6MjA1MTUxMTMyOH0.HYrReotufP9ZGPiYN2NUA3sp7yUzFPfBBGZETYcdyIM',
    );
  } catch (e) {
    // Supabase already initialized, proceed without error
  }

  // Run the app with Riverpod's ProviderScope for state management
  runApp(const ProviderScope(child: MyApp()));
}

/// Root widget of the application
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

/// State management for the root widget
/// Handles application lifecycle events, particularly for user authentication
class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // Register this object as an observer to receive app lifecycle changes
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Remove this object from the observer list when widget is disposed
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Handles app lifecycle state changes
  /// Specifically manages user logout when app is completely closed
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      _logoutUser(); // Sign out from Supabase when app is closed
      UserRepo.googleSignOut(); // Sign out from Google authentication
    }
  }

  /// Signs out the current user from Supabase
  Future<void> _logoutUser() async {
    await Supabase.instance.client.auth.signOut();
    print("User logged out on app close");
  }

  /// Builds the application UI
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Plant Disease Detection using MultiModal LLM',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // Define application routes
        routes: {
          '/': (context) => const WelcomeScreen(),
          '/home': (context) => const ShellScreen(screen: HomePage()),
        },
        initialRoute: "/", // Set the starting screen to WelcomeScreen
      ),
    );
  }
}
