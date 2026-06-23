import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';                          // ← ajouter
import 'features/auth/view_model/auth_view_model.dart';
import 'firebase_options.dart';
import 'core/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Erreur lors de l'initialisation de Firebase : $e");
  }

  runApp(const ZygoApp());
}

class ZygoApp extends StatelessWidget {
  const ZygoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: MaterialApp.router(
        title: 'Zygo',
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      ),
    );
  }
}