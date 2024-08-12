import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_project/firebase_options.dart';
import 'package:flutter_project/presentation/auth/pages/register/pages/register_pages.dart';
import 'package:flutter_project/presentation/on_boarding/on_boarding.dart';
import 'package:provider/provider.dart';

import 'presentation/auth/pages/login/pages/login.dart';
import 'presentation/cart/provider.dart';
import 'presentation/cashier/pages/cashier_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnBoarding(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
      },
    );
  }
}
