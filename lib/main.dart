import 'package:flutter/material.dart';
import 'core/router.dart';

void main() {
  runApp(const ZygoApp());
}

class ZygoApp extends StatelessWidget {
  const ZygoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // On utilise .router pour injecter GoRouter
    return MaterialApp.router(
      title: 'Zygo',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
