import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/movies_record.dart';
import '../screens/movie_details_screen.dart';

class MovieThumbnail extends StatelessWidget {
  final MoviesRecord movie;

  const MovieThumbnail({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailsScreen(movieReference: movie.reference),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          movie.image,
          width: 100,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}