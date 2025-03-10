import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:ticketbox/firebase_options.dart';
import 'package:ticketbox/routing/go_routes.dart';

import 'config/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Skjuler statusbaren
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  injectionInit();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'TicketBox',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

GoRouter _router = goRoutes;
