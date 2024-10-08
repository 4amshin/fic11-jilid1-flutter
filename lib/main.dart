import 'package:fic11_jilid1/core/constants/colors.dart';
// import 'package:fic11_jilid1/presentation/auth/login_page.dart';
import 'package:fic11_jilid1/presentation/home/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FIC11 Jilid1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.quicksandTextTheme(Theme.of(context).textTheme),
        appBarTheme: AppBarTheme(
          color: AppColors.white,
          elevation: 0,
          titleTextStyle: GoogleFonts.quicksand(
            color: AppColors.primary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          iconTheme: const IconThemeData(
            color: AppColors.primary,
          ),
        ),
      ),
      home: const DashboardPage(),
    );
  }
}
