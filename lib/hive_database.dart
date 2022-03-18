import 'package:flutter_hive/models/movie_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  String boxName = 'favorite_movies';
  Type boxType = Movie;

  Future<Box> openBox() async {
    Box box = await Hive.openBox<Movie>(boxName);
    return box;
  }

  List<Movie> getMovies(Box box) {
    return box.values.toList() as List<Movie>;
  }

  Future<void> addMovie(Box box, Movie movie) async {
    await box.put(movie.id, movie);
  }

  Future<void> updateMovie(Box box, Movie movie) async {
    await box.put(movie.id, movie);
  }

  Future<void> deleteMovie(Box box, Movie movie) async {
    await box.delete(movie.id);
  }

  Future<void> deleteAllMovies(Box box) async {
    await box.clear();
  }
}
