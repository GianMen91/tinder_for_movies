import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Import the widget from your app
import 'package:tinder_for_movies/screens/movie_details_screen.dart';

@widgetbook.UseCase(name: 'Default', type: MovieDetailsScreen)
Widget buildMovieDetailsScreenUseCase(BuildContext context) {
  return MovieDetailsScreen(movieReference: null,);
}
