import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Import the widget from your app
import 'package:tinder_for_movies/screens/swipe_screen.dart';

@widgetbook.UseCase(name: 'Default', type: SwipeScreen)
Widget buildSwipeScreenUseCase(BuildContext context) {
  return SwipeScreen();
}
