import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hive/hive_database.dart';
import 'package:flutter_hive/models/movie_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'blocs/movie/movie_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favorite Movies'),
        actions: [
          IconButton(
            onPressed: () {
              BlocProvider.of<MovieBloc>(context).add(DeleteAllMovies());
            },
            icon: const Icon(Icons.clear),
          )
        ],
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is MovieLoaded) {
            return ListView.builder(
              itemCount: state.movies.length,
              itemBuilder: (context, index) {
                Movie movie = state.movies[index];
                return ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: Image.network(
                    movie.imageUrl,
                    fit: BoxFit.cover,
                    width: 100,
                  ),
                  title: Text(movie.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.watch_later_sharp,
                          color: movie.addedToWatchlist
                              ? Colors.grey
                              : Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          context.read<MovieBloc>().add(
                                UpdateMovie(
                                  movie: movie.copyWith(
                                    addedToWatchlist: !movie.addedToWatchlist,
                                  ),
                                ),
                              );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showModalBottomSheet(context: context, movie: movie);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<MovieBloc>().add(
                                DeleteMovie(movie: movie),
                              );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Text('Something went wrong.');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showModalBottomSheet(context: context),
      ),
    );
  }

  void _showModalBottomSheet({
    required BuildContext context,
    Movie? movie,
  }) async {
    Random random = Random();
    TextEditingController nameController = TextEditingController();
    TextEditingController imageUrlController = TextEditingController();

    if (movie != null) {
      nameController.text = movie.name;
      imageUrlController.text = movie.imageUrl;
    }

    showModalBottomSheet(
      isDismissible: true,
      elevation: 5,
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(labelText: 'Movie'),
            ),
            TextField(
              controller: imageUrlController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (movie != null) {
                  context.read<MovieBloc>().add(
                        UpdateMovie(
                          movie: movie.copyWith(
                            name: nameController.text,
                            imageUrl: imageUrlController.text,
                          ),
                        ),
                      );
                } else {
                  Movie movie = Movie(
                    id: '${random.nextInt(10000)}',
                    name: nameController.text,
                    imageUrl: imageUrlController.text,
                    addedToWatchlist: false,
                  );

                  context.read<MovieBloc>().add(AddMovie(movie: movie));
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}
