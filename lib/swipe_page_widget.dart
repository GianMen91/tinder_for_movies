import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinder_for_movies/swipeable_stack.dart';


import 'movie_details_widget.dart';
import 'movies_record.dart';

class SwipePageWidget extends StatefulWidget {
  const SwipePageWidget({super.key});

  static String routeName = 'SwipePage';
  static String routePath = '/swipePage';

  @override
  State<SwipePageWidget> createState() => _SwipePageWidgetState();
}

class _SwipePageWidgetState extends State<SwipePageWidget> {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {

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
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
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
                          child: CircularProgressIndicator(

                          ),
                        ),
                      );
                    }
                    List<MoviesRecord> swipeableStackMoviesRecordList =
                    snapshot.data!;

                    return SwipeableStack(
                      onSwipeFn: (index) {},
                      onLeftSwipe: (index) {},
                      onRightSwipe: (index) async {

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
                            mainAxisSize: MainAxisSize.max,
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
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      swipeableStackMoviesRecord.title,
                                      style: TextStyle(
                                        fontFamily: GoogleFonts.interTight().fontFamily,
                                        color: Colors.white,
                                        fontSize: 18,
                                        letterSpacing: 0.0,
                                      ),
                                    ),
                                    Text(
                                      swipeableStackMoviesRecord.year.toString(),
                                      style: TextStyle(
                                        fontFamily: GoogleFonts.interTight().fontFamily,
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
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {

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
                                        Navigator.pushNamed(
                                          context,
                                          MovieDetailsWidget.routeName,
                                          arguments: {
                                            'receiveMovie': swipeableStackMoviesRecord.reference,
                                          },
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
                      loop: false,
                      cardDisplayCount: 3,
                      scale: 0.9,
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
  return user != null ? FirebaseFirestore.instance.collection('users').doc(user.uid) : null;
}