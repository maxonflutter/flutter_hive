import 'package:flutter_hive/models/movie_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  String boxName = 'movies_box';
  Type boxType = Movie;

  Future<Box> openBox() async {
    Box box = await Hive.openBox<Movie>(boxName);
    return box;
  }

  Future<void> getMovie(Box box) async {
    await box.get('movie');
  }

  Future<void> addMovie(Box box, int key, Movie movie) async {
    // await box.add(key, movie);
    await box.put(key, movie);
  }

  Future<void> updateMovie(Box box, Movie movie, int index) async {
    await box.putAt(index, movie);
  }

  Future<void> deleteMovie(Box box, Movie movie) async {
    await box.add(movie);
  }

  Future<void> deleteAllMovies(Box box) async {
    await box.clear();
  }
}
