import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

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

  @override
  _SwipeableStackState createState() => _SwipeableStackState();
}

class _SwipeableStackState extends State<SwipeableStack> {
  @override
  Widget build(BuildContext context) {
    return CardSwiper(

      cardsCount: widget.itemCount,
      allowedSwipeDirection: const AllowedSwipeDirection.all(),
      cardBuilder: (context, index, percentThresholdX, percentThresholdY) => widget.itemBuilder(context, index),
      onSwipe: (int previousIndex, int? currentIndex, CardSwiperDirection direction) {
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