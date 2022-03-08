import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/movie_model.dart';

const moviesBox = 'watchlist_movies';
List<Movie> movies = Movie.movies;

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MovieAdapter());
  await Hive.openBox<Movie>(moviesBox);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Box<Movie> watchlistMoviesBox;

  @override
  void initState() {
    super.initState();
    watchlistMoviesBox = Hive.box(moviesBox);
  }

  Widget getIcon(int index) {
    if (watchlistMoviesBox.containsKey(index)) {
      return const Icon(Icons.favorite, color: Colors.red);
    }
    return const Icon(Icons.favorite_border);
  }

  void onFavoritePress(int index) {
    if (watchlistMoviesBox.length > 0) {
      print('Keys: ${watchlistMoviesBox.keys}');
      print('Values: ${watchlistMoviesBox.values}');
      print('Name: ${watchlistMoviesBox.name}');
      print('Path: ${watchlistMoviesBox.path}');
    }

    if (watchlistMoviesBox.containsKey(index)) {
      watchlistMoviesBox.delete(index);
      return;
    }
    watchlistMoviesBox.put(index, movies[index]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies Watchlist',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Movies Watchlist'),
        ),
        body: ValueListenableBuilder(
          valueListenable: watchlistMoviesBox.listenable(),
          builder: (context, Box<Movie> box, _) {
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, listIndex) {
                return ListTile(
                  title: Text(movies[listIndex].name),
                  trailing: IconButton(
                    icon: getIcon(listIndex),
                    onPressed: () => onFavoritePress(listIndex),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
