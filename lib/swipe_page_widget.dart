import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinder_for_movies/swipeable_stack.dart'; // Original SwipeableStack
import 'package:tinder_for_movies/swipeable_stack_controller.dart'; // Separate controller file

import 'movie_details_widget.dart';
import 'movies_record.dart';


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


class SwipePageWidget extends StatefulWidget {
  const SwipePageWidget({super.key});

  @override
  State<SwipePageWidget> createState() => _SwipePageWidgetState();
}

class _SwipePageWidgetState extends State<SwipePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  // Add a controller for the swipeable stack
  final SwipeableStackController swipeController = SwipeableStackController();

  @override
  void dispose() {
    swipeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: Text(
            'FILMFLIX',
            style: TextStyle(
              fontFamily: GoogleFonts.interTight().fontFamily,
              color: const Color(0xFFFF0000),
              fontSize: 30,
              letterSpacing: 0.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: const [],
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<MoviesRecord>>(
                  stream: queryMoviesRecord(),
                  builder: (context, snapshot) {
                    // Customize what your widget looks like when it's loading.
                    if (!snapshot.hasData) {
                      return const Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    List<MoviesRecord> swipeableStackMoviesRecordList =
                    snapshot.data!;

                    return SwipeableStack(
                      controller: swipeController, // Pass the controller
                      onSwipeFn: (index) {},
                      onLeftSwipe: (index) {
                        // Handle left swipe (dislike)
                        print('Disliked movie: ${swipeableStackMoviesRecordList[index].title}');
                      },
                      onRightSwipe: (index) async {
                        // Handle right swipe (like)
                        await currentUserReference!.update({
                          'myList': FieldValue.arrayUnion([
                            swipeableStackMoviesRecordList[index].reference
                          ]),
                        });

                        await swipeableStackMoviesRecordList[index]
                            .reference
                            .update({
                          'likedByUsers':
                          FieldValue.arrayUnion([currentUserReference]),
                        });

                        print('Liked movie: ${swipeableStackMoviesRecordList[index].title}');
                      },
                      onUpSwipe: (index) {},
                      onDownSwipe: (index) {},
                      itemBuilder: (context, swipeableStackIndex) {
                        final swipeableStackMoviesRecord =
                        swipeableStackMoviesRecordList[swipeableStackIndex];
                        return Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFF343131),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 4,
                                color: Color(0x33000000),
                                offset: Offset(0, 2),
                              )
                            ],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      20, 20, 20, 12),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      swipeableStackMoviesRecord.image,
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    20, 0, 20, 20),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      swipeableStackMoviesRecord.title,
                                      style: TextStyle(
                                        fontFamily:
                                        GoogleFonts.interTight().fontFamily,
                                        color: Colors.white,
                                        fontSize: 18,
                                        letterSpacing: 0.0,
                                      ),
                                    ),
                                    Text(
                                      swipeableStackMoviesRecord.year
                                          .toString(),
                                      style: TextStyle(
                                        fontFamily:
                                        GoogleFonts.interTight().fontFamily,
                                        color: Colors.white,
                                        fontSize: 18,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    20, 0, 20, 25),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        // Trigger left swipe animation (dislike)
                                        swipeController.swipeLeft();
                                      },
                                      child: const Icon(
                                        Icons.thumb_down,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MovieDetailsWidget(
                                                  receiveMovie: swipeableStackMoviesRecord
                                                      .reference,
                                                ),
                                          ),
                                        );
                                      },
                                      child: const Icon(
                                        Icons.info,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        // First perform the database operations
                                        await currentUserReference!.update({
                                          'myList': FieldValue.arrayUnion([
                                            swipeableStackMoviesRecordList[swipeableStackIndex].reference
                                          ]),
                                        });

                                        await swipeableStackMoviesRecordList[swipeableStackIndex]
                                            .reference
                                            .update({
                                          'likedByUsers':
                                          FieldValue.arrayUnion([currentUserReference]),
                                        });

                                        // Then trigger the right swipe animation
                                        swipeController.swipeRight();
                                      },
                                      child: const Icon(
                                        Icons.thumb_up,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: swipeableStackMoviesRecordList.length,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Stream<List<MoviesRecord>> queryMoviesRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(FirebaseFirestore.instance.collection('movies'));

  if (limit > 0) {
    query = query.limit(limit);
  }

  return query.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => MoviesRecord.fromSnapshot(doc)).toList();
  });
}

DocumentReference? get currentUserReference {
  User? user = FirebaseAuth.instance.currentUser;
  return user != null
      ? FirebaseFirestore.instance.collection('users').doc(user.uid)
      : null;
}

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