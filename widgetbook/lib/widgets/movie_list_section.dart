import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Import the widget from your app
import 'package:tinder_for_movies/widgets/movie_list_section.dart';

@widgetbook.UseCase(name: 'Default', type: MovieListSection)
Widget buildMovieListSectionUseCase(BuildContext context) {
  return MovieListSection(title: 'test', movieReferences: [],);
}
