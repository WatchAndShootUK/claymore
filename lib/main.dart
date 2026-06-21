
import 'package:claymore/pages/home_page.dart';
import 'package:claymore/pages/login_page.dart';
import 'package:claymore/services/login_cache.dart';
import 'package:claymore/state/app_data.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final appData = AppData();
  appData.startListening();

  runApp(ChangeNotifierProvider.value(value: appData, child: const MainApp()));

  
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool checkedCache = false;
  bool loggedIn = false;

  @override
  Widget build(BuildContext context) {
    final appData = context.watch<AppData>();
    if (appData.users.isEmpty) {
      return _material(
        const Scaffold(
          backgroundColor: Colors.black,
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (!checkedCache) {
      checkedCache = true;

      Future.microtask(() async {
        final cachedUserId = await LoginCache.getUserId();

        final user = appData.users.firstWhereOrNull(
          (u) => u.id == cachedUserId,
        );

        if (user != null) {
          appData.currentUser = user;
          appData.selectedJtac = user;

          if (!mounted) return;
          setState(() {
            loggedIn = true;
          });
        }
      });
    }
    return _material(loggedIn ? const HomePage() : LoginPage());
  }

  Widget _material(Widget home) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: home,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF3B82F6),
          secondary: Color(0xFF60A5FA),
          surface: Color(0xFF252525),
        ),
      ),
    );
  }
}
