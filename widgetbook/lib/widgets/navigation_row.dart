import 'package:flutter/material.dart';
import 'package:tinder_for_movies/widgets/navigation_row.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;


@widgetbook.UseCase(name: 'Default', type: NavigationRow)
Widget buildNavigationRowUseCase(BuildContext context) {
  return NavigationRow(isFromSignIn: true,);
}
