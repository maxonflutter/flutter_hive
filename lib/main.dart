import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'blocs/movie/movie_bloc.dart';
import 'models/movie_model.dart';
import 'hive_database.dart';
import 'screens/home_screen.dart';

const moviesBox = 'Movie_movies';
List<Movie> movies = Movie.movies;

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MovieAdapter());
  await Hive.openBox<Movie>(moviesBox);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieBloc(hiveDatabase: HiveDatabase())
        ..add(
          LoadMovies(movies: Movie.movies),
        ),
      child: MaterialApp(
        title: 'Movies Movie',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
