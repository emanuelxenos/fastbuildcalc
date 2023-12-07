import 'package:xenoscalculadoram2/view/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:xenoscalculadoram2/view/service_general/service_general_view.dart';
import 'package:xenoscalculadoram2/view/splash/spalsh_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    OutlineInputBorder inputBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
    );

    return MaterialApp(
      title: 'Calculadora m2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xff7437bc),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          isDense: true,
          contentPadding: const EdgeInsets.all(10),
          border: inputBorder,
          focusedBorder: inputBorder,
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/home': (context) => const HomePage(),
        '/splash': (context) => const SpalshView(),
        '/servicegeneral': (context) => const ServiceGeneralView(),
      },
    );
  }
}
