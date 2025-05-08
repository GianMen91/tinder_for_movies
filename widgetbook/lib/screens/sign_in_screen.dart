import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Import the widget from your app
import 'package:tinder_for_movies/screens/sign_in_screen.dart';

@widgetbook.UseCase(name: 'Default', type: SignInScreen)
Widget buildSignInScreenUseCase(BuildContext context) {
  return SignInScreen();
}
