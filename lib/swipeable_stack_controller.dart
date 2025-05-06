import 'package:flutter_card_swiper/flutter_card_swiper.dart';

// Controller class for SwipeableStack
class SwipeableStackController {
  CardSwiperController? _cardSwiperController;

  // Connect to the CardSwiperController
  void setCardSwiperController(CardSwiperController controller) {
    _cardSwiperController = controller;
  }

  // Methods to trigger swipes programmatically
  void swipeLeft() {
    if (_cardSwiperController != null) {
      try {
        _cardSwiperController!.swipeLeft();
      } catch (e) {
        print("Error swiping left: $e");
      }
    }
  }



  void swipeRight() {
    if (_cardSwiperController != null) {
      try {
        _cardSwiperController!.swipeRight();
      } catch (e) {
        print("Error swiping right: $e");
      }
    }
  }

  void swipeUp() {
    if (_cardSwiperController != null) {
      try {
        _cardSwiperController!.swipeTop();
      } catch (e) {
        print("Error swiping up: $e");
      }
    }
  }

  void swipeDown() {
    if (_cardSwiperController != null) {
      try {
        _cardSwiperController!.swipeBottom();
      } catch (e) {
        print("Error swiping down: $e");
      }
    }
  }

  // Method to check if controller is ready
  bool get isReady => _cardSwiperController != null;

  // Clean up
  void dispose() {
    _cardSwiperController = null;
  }
}