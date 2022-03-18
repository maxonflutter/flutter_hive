import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_hive/hive_database.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/movie_model.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final HiveDatabase hiveDatabase;

  MovieBloc({required this.hiveDatabase}) : super(MovieLoading()) {
    on<LoadMovies>(_onLoadMovies);
    on<AddMovie>(_onAddMovie);
    on<UpdateMovie>(_onUpdateMovie);
    on<DeleteMovie>(_onDeleteMovie);
  }

  void _onLoadMovies(
    LoadMovies event,
    Emitter<MovieState> emit,
  ) async {
    Box box = await hiveDatabase.openBox();
    if (box.length > 0) {
      List<Movie> movies = box.values.toList() as List<Movie>;
      emit(MovieLoaded(movies: movies));
    } else {
      Future<void>.delayed(const Duration(seconds: 1));
      box.addAll(event.movies);
      emit(MovieLoaded(movies: event.movies));
    }
  }

  void _onUpdateMovie(
    UpdateMovie event,
    Emitter<MovieState> emit,
  ) async {
    Box box = await hiveDatabase.openBox();
    if (state is MovieLoaded) {
      final state = this.state as MovieLoaded;
      box.getAt(event.index);
      box.putAt(event.index, event.movie);
      List<Movie> movies = state.movies.map((movie) {
        return movie.id == event.movie.id ? event.movie : movie;
      }).toList();
      emit(MovieLoaded(movies: movies));
    }
  }

  void _onAddMovie(
    AddMovie event,
    Emitter<MovieState> emit,
  ) async {
    Box box = await hiveDatabase.openBox();
    if (state is MovieLoaded) {
      final state = this.state as MovieLoaded;
      Movie movie = event.movie.copyWith(id: state.movies.length.toString());
      box.putAt(int.parse(movie.id), movie);
      emit(
        MovieLoaded(
          movies: List.from(state.movies)..add(movie),
        ),
      );
    }
  }

  void _onDeleteMovie(
    DeleteMovie event,
    Emitter<MovieState> emit,
  ) {}
}
