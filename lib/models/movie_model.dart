import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 0)
class Movie extends Equatable with HiveObjectMixin {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final bool addedToWatchlist;

  Movie({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.addedToWatchlist,
  });

  Movie copyWith({
    String? id,
    String? name,
    String? imageUrl,
    bool? addedToWatchlist,
  }) {
    return Movie(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      addedToWatchlist: addedToWatchlist ?? this.addedToWatchlist,
    );
  }

  @override
  List<Object?> get props => [id, name, imageUrl, addedToWatchlist];
}
