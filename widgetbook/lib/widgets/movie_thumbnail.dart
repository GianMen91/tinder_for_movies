import 'package:flutter/material.dart';
import 'package:tinder_for_movies/models/movies_record.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Import the widget from your app
import 'package:tinder_for_movies/widgets/movie_thumbnail.dart';

@widgetbook.UseCase(name: 'Default', type: MovieThumbnail)
Widget buildMovieThumbnailUseCase(BuildContext context) {
  return MovieThumbnail(
    movie: MoviesRecord(
        title: 'Fight Club',
        description:
            'Un impiegato che soffre di insonnia e un fabbricante di sapone menefreghista formano un club di combattimenti clandestino che si trasforma in qualcosa molto di più grande',
        image: 'https://i.ebayimg.com/images/g/4jsAAOSwM0FXIRDO/s-l1200.jpg',
        length: '2h 19min',
        year: 1999,
        trailerLink: 'https://www.youtube.com/watch?v=qtRKdVHc-cE',
        likedByUsers: [],
        reference: null),
  );
}
