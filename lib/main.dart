import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labmino_app/presentation/authentication/login.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'controller/auth_controller.dart';
import 'controller/run_controller.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<CookieRequest>(create: (_) => CookieRequest()),
        ChangeNotifierProxyProvider<CookieRequest, AuthController>(
          create: (context) =>
              AuthController(request: context.read<CookieRequest>()),
          update: (context, request, authController) =>
              AuthController(request: request),
        ),
        ChangeNotifierProxyProvider<CookieRequest, RunController>(
          create: (context) =>
              RunController(request: context.read<CookieRequest>()),
          update: (context, request, runController) =>
              RunController(request: request),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Labmino',
      theme: ThemeData(useMaterial3: true),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
