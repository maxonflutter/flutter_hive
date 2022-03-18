import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hive/models/movie_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Movie> movieBox;

  @override
  void initState() {
    super.initState();
    movieBox = Hive.box('favorite_movies');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favorite Movies'),
        actions: [
          IconButton(
            onPressed: () {
              movieBox.clear();
            },
            icon: const Icon(Icons.clear),
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: movieBox.listenable(),
        builder: (context, Box<Movie> box, _) {
          List<Movie> movies = box.values.toList().cast<Movie>();

          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              Movie movie = movies[index];
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
                        movieBox.put(
                          movie.id,
                          movie.copyWith(
                            addedToWatchlist: !movie.addedToWatchlist,
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showModalBottomSheet(
                          context: context,
                          movieBox: movieBox,
                          movie: movies[index],
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        box.delete(movies[index].id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showModalBottomSheet(
          context: context,
          movieBox: movieBox,
        ),
      ),
    );
  }

  void _showModalBottomSheet({
    required BuildContext context,
    required Box movieBox,
    Movie? movie,
  }) {
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
                  movieBox.put(
                    movie.id,
                    movie.copyWith(
                      name: nameController.text,
                      imageUrl: imageUrlController.text,
                    ),
                  );
                } else {
                  Movie movie = Movie(
                    id: '${random.nextInt(10000)}',
                    name: nameController.text,
                    imageUrl: imageUrlController.text,
                    addedToWatchlist: false,
                  );
                  movieBox.put(movie.id, movie);
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
