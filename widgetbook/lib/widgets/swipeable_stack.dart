import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tinder_for_movies/widgets/swipeable_stack_controller.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Import the widget from your app
import 'package:tinder_for_movies/widgets/swipeable_stack.dart';

@widgetbook.UseCase(name: 'Default', type: SwipeableStack)
Widget buildSwipeableStackUseCase(BuildContext context) {
  final SwipeableStackController swipeController = SwipeableStackController();
  return SwipeableStack(
    controller: swipeController,
    itemCount: 3,
    itemBuilder: (context, index) => Container(
      color: Colors.primaries[index % Colors.primaries.length],
      child: Center(
        child: Text(
          'Card $index',
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    ),
    loop: true,
    onSwipeFn: (_) {},
    onLeftSwipe: (index) {
      if (kDebugMode) {
        print('Left swipe on card: $index');
      }
    },
    onRightSwipe: (_) {
      if (kDebugMode) {
        print('Right swipe on card');
      }
    },
    onUpSwipe: (_) {},
    onDownSwipe: (_) {},
  );
}
