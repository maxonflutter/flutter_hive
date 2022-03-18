import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/movie/movie_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies Movie'),
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
                return ListTile(
                  title: Text(state.movies[index].name),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.watch_later_sharp,
                      color: state.movies[index].addedToWatchlist
                          ? Colors.grey
                          : Colors.blue,
                    ),
                    onPressed: () {
                      context.read<MovieBloc>().add(
                            UpdateMovie(
                              index: index,
                              movie: state.movies[index].copyWith(
                                addedToWatchlist:
                                    !state.movies[index].addedToWatchlist,
                              ),
                            ),
                          );
                    },
                  ),
                );
              },
            );
          } else {
            return const Text('Something went wrong');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showModalBottomSheet(context),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      elevation: 5,
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              keyboardType: TextInputType.name,
              decoration: InputDecoration(labelText: 'Movie'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}
