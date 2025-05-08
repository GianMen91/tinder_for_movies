import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinder_for_movies/widgets/app_logo.dart';

import '../models/movies_record.dart';
import '../widgets/swipeable_stack.dart';
import '../widgets/swipeable_stack_controller.dart';
import 'movie_details_screen.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final SwipeableStackController swipeController = SwipeableStackController();

  @override
  void dispose() {
    swipeController.dispose();
    super.dispose();
  }

  /// Stream for fetching movies from Firestore
  Stream<List<MoviesRecord>> getMoviesStream() {
    return FirebaseFirestore.instance
        .collection('movies')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => MoviesRecord.fromSnapshot(doc)).toList());
  }

  /// Reference to current authenticated user in Firestore
  DocumentReference? get currentUserRef {
    final user = FirebaseAuth.instance.currentUser;
    return user != null
        ? FirebaseFirestore.instance.collection('users').doc(user.uid)
        : null;
  }

  /// Handles liking a movie
  Future<void> likeMovie(MoviesRecord movie) async {
    final userRef = currentUserRef;
    if (userRef == null) return;

    await userRef.update({
      'myList': FieldValue.arrayUnion([movie.reference]),
    });

    await movie.reference?.update({
      'likedByUsers': FieldValue.arrayUnion([userRef]),
    });

    if (kDebugMode) {
      print('Liked movie: ${movie.title}');
    }
  }

  /// Builds a swipeable movie card
  Widget buildMovieCard(MoviesRecord movie) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF343131),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(blurRadius: 4, color: Color(0x33000000), offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  movie.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  movie.title,
                  style: GoogleFonts.interTight(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  movie.year.toString(),
                  style: GoogleFonts.interTight(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.thumb_down, color: Colors.white, size: 40),
                  onPressed: () => swipeController.swipeLeft(),
                ),
                IconButton(
                  icon: const Icon(Icons.info, color: Colors.white, size: 40),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetailsScreen(movieReference: movie.reference),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.thumb_up, color: Colors.white, size: 40),
                  onPressed: () async {
                    await likeMovie(movie);
                    swipeController.swipeRight();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the swipeable stack widget
  Widget buildSwipeStack(List<MoviesRecord> movies) {
    return SwipeableStack(
      controller: swipeController,
      itemCount: movies.length,
      itemBuilder: (context, index) => buildMovieCard(movies[index]),
      onSwipeFn: (_) {},
      onLeftSwipe: (index) {
        if (kDebugMode) {
          print('Disliked movie: ${movies[index].title}');
        }
      },
      onRightSwipe: (index) => likeMovie(movies[index]),
      onUpSwipe: (_) {},
      onDownSwipe: (_) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const AppLogo(),
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
          child: StreamBuilder<List<MoviesRecord>>(
            stream: getMoviesStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final movies = snapshot.data!;
              return buildSwipeStack(movies);
            },
          ),
        ),
      ),
    );
  }
}
