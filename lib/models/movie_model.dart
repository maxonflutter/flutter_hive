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
  final bool addedToWatchlist;

  Movie({
    required this.id,
    required this.name,
    required this.addedToWatchlist,
  });

  Movie copyWith({
    String? id,
    String? name,
    bool? addedToWatchlist,
  }) {
    return Movie(
      id: id ?? this.id,
      name: name ?? this.name,
      addedToWatchlist: addedToWatchlist ?? this.addedToWatchlist,
    );
  }

  static List<Movie> movies = [
    Movie(id: '0', name: 'Movie 1', addedToWatchlist: false),
    Movie(id: '1', name: 'Movie 2', addedToWatchlist: false),
    Movie(id: '2', name: 'Movie 3', addedToWatchlist: false),
  ];

  @override
  List<Object?> get props => [id, name, addedToWatchlist];
}
