import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_suitmedia/providers/FirstScreen_provider.dart';
import 'package:test_suitmedia/providers/ThirdScreen_provider.dart';
import 'package:test_suitmedia/screens/FirstScreen.dart'; 
import 'package:test_suitmedia/screens/SecondScreen.dart';
import 'package:test_suitmedia/screens/SplashScreen.dart';
import 'package:test_suitmedia/screens/ThirdScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FirstScreenProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()), 
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aplikasi Palindrom',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: GoogleFonts.poppins().fontFamily,
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme.apply(bodyColor: Colors.black, displayColor: Colors.black),
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.black,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              elevation: 5,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            hintStyle: TextStyle(color: Colors.grey.shade600),
          ),
        ),
        routes: {
          '/': (context) => const FirstScreen(),
          '/splash': (context) => const SplashScreen(),
          '/second': (context) => const SecondScreen(),
          '/third': (context) => ThirdScreen(),
        },
        initialRoute: '/splash',
      ),
    );
  }
}