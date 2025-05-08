import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Import the widget from your app
import 'package:tinder_for_movies/widgets/movie_section.dart';

@widgetbook.UseCase(name: 'Default', type: MovieSection)
Widget buildMovieSectionUseCase(BuildContext context) {
  return MovieSection(
    title: 'Action',
    queryBuilder: (q) => q.where('genre', isEqualTo: 'Action'),
    bottomPadding: 20,
  );
}
