import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/movies_record.dart';
import 'movie_thumbnail.dart';

class MovieListView extends StatelessWidget {
  final List<MoviesRecord> movies;

  const MovieListView({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      scrollDirection: Axis.horizontal,
      itemCount: movies.length,
      separatorBuilder: (_, __) => const SizedBox(width: 10),
      itemBuilder: (context, index) {
        return MovieThumbnail(movie: movies[index]);
      },
    );
  }
}