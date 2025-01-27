import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riverpod_app/home.dart';
import 'package:riverpod_app/services/dio_service.dart';

final getit = GetIt.instance;
void main() async {
  await _setupDependencies();
  runApp(const MyApp());
}

Future<void> _setupDependencies() async {
  GetIt.instance.registerSingleton<DioService>(DioService());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.quattrocentoSansTextTheme(),
        ),
        home: const Home(),
      ),
    );
  }
}
