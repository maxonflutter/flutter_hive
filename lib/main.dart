import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/movie_model.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MovieAdapter());
  await Hive.openBox<Movie>('favorite_movies');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies Movie',
      theme: ThemeData(
        primarySwatch: const MaterialColor(
          0xFF000A1F,
          <int, Color>{
            50: Color(0xFF000A1F),
            100: Color(0xFF000A1F),
            200: Color(0xFF000A1F),
            300: Color(0xFF000A1F),
            400: Color(0xFF000A1F),
            500: Color(0xFF000A1F),
            600: Color(0xFF000A1F),
            700: Color(0xFF000A1F),
            800: Color(0xFF000A1F),
            900: Color(0xFF000A1F),
          },
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
