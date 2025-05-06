import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:tinder_for_movies/swipeable_stack_controller.dart';

class SwipeableStack extends StatefulWidget {
  const SwipeableStack({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.onSwipeFn,
    this.onLeftSwipe,
    this.onRightSwipe,
    this.onUpSwipe,
    this.onDownSwipe,
    this.loop = false,
    this.cardDisplayCount = 3,
    this.scale = 0.9,
    this.controller, // Added controller parameter
  });

  final Widget Function(BuildContext, int) itemBuilder;
  final int itemCount;

  final Function(int)? onSwipeFn;
  final Function(int)? onLeftSwipe;
  final Function(int)? onRightSwipe;
  final Function(int)? onUpSwipe;
  final Function(int)? onDownSwipe;
  final bool loop;
  final int cardDisplayCount;
  final double scale;
  final SwipeableStackController? controller; // Controller for programmatic swipes

  @override
  SwipeableStackState createState() => SwipeableStackState();
}

class SwipeableStackState extends State<SwipeableStack> {
  // Create a CardSwiperController
  late CardSwiperController _cardSwiperController;

  @override
  void initState() {
    super.initState();
    _cardSwiperController = CardSwiperController();

    // Connect the controller if provided
    if (widget.controller != null) {
      widget.controller!.setCardSwiperController(_cardSwiperController);
    }
  }

  @override
  void dispose() {
    _cardSwiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CardSwiper(
      controller: _cardSwiperController, // Pass the controller to CardSwiper
      cardsCount: widget.itemCount,
      cardBuilder: (context, index, percentThresholdX, percentThresholdY) =>
          widget.itemBuilder(context, index),
      onSwipe: (int previousIndex, int? currentIndex,
          CardSwiperDirection direction) {
        widget.onSwipeFn?.call(previousIndex);

        switch (direction) {
          case CardSwiperDirection.left:
            widget.onLeftSwipe?.call(previousIndex);
            break;
          case CardSwiperDirection.right:
            widget.onRightSwipe?.call(previousIndex);
            break;
          case CardSwiperDirection.top:
            widget.onUpSwipe?.call(previousIndex);
            break;
          case CardSwiperDirection.bottom:
            widget.onDownSwipe?.call(previousIndex);
            break;
          default:
            break;
        }

        return true;
      },
      isLoop: widget.loop,
      numberOfCardsDisplayed: widget.cardDisplayCount,
      scale: widget.scale,
      backCardOffset: const Offset(0, 0),
    );
  }
}