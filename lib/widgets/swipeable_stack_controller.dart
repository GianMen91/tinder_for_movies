import 'package:flutter/foundation.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class SwipeableStackController {
  CardSwiperController? _cardSwiperController;

  void setCardSwiperController(CardSwiperController controller) {
    _cardSwiperController = controller;
  }

  void swipeLeft() {
    try {
      _cardSwiperController?.swipeLeft();
    } on Exception catch (e) {
      if (kDebugMode) print("Error swiping left: $e");
    }
  }

  void swipeRight() {
    try {
      _cardSwiperController?.swipeRight();
    } on Exception catch (e) {
      if (kDebugMode) print("Error swiping right: $e");
    }
  }

  void swipeUp() {
    try {
      _cardSwiperController?.swipeTop();
    } on Exception catch (e) {
      if (kDebugMode) print("Error swiping up: $e");
    }
  }

  void swipeDown() {
    try {
      _cardSwiperController?.swipeBottom();
    } on Exception catch (e) {
      if (kDebugMode) print("Error swiping down: $e");
    }
  }

  bool get isReady => _cardSwiperController != null;

  void dispose() {
    _cardSwiperController = null;
  }
}
