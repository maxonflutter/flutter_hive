import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hive/hive_database.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'blocs/movie/movie_bloc.dart';
import 'models/movie_model.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MovieAdapter());

  final hiveDatabase = HiveDatabase();
  await hiveDatabase.openBox();
  runApp(MyApp(
    hiveDatabase: hiveDatabase,
  ));
}

class MyApp extends StatelessWidget {
  final HiveDatabase _hiveDatabase;

  const MyApp({
    Key? key,
    required HiveDatabase hiveDatabase,
  })  : _hiveDatabase = hiveDatabase,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _hiveDatabase,
      child: BlocProvider(
        create: (context) => MovieBloc(
          hiveDatabase: _hiveDatabase,
        )..add(
            LoadMovies(),
          ),
        child: MaterialApp(
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
        ),
      ),
    );
  }
}
