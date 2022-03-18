part of 'movie_bloc.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

class LoadMovies extends MovieEvent {
  final List<Movie> movies;

  const LoadMovies({this.movies = const <Movie>[]});

  @override
  List<Object> get props => [movies];
}

class UpdateMovie extends MovieEvent {
  final Movie movie;
  final int index;

  const UpdateMovie({
    required this.movie,
    required this.index,
  });

  @override
  List<Object> get props => [movie, index];
}

class AddMovie extends MovieEvent {
  final Movie movie;

  const AddMovie({
    required this.movie,
  });

  @override
  List<Object> get props => [movie];
}

class DeleteMovie extends MovieEvent {}
