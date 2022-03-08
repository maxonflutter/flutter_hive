import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 0)
class Movie extends Equatable with HiveObjectMixin {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final bool isInWatchlist;

  Movie({
    required this.id,
    required this.name,
    required this.isInWatchlist,
  });

  static List<Movie> movies = [
    Movie(id: '0', name: 'Movie 1', isInWatchlist: false),
    Movie(id: '1', name: 'Movie 2', isInWatchlist: false),
    Movie(id: '2', name: 'Movie 3', isInWatchlist: false),
  ];

  @override
  List<Object?> get props => [id, name, isInWatchlist];
}
