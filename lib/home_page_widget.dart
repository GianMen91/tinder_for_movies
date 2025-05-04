import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'movie_details_widget.dart';
import 'movies_record.dart';

// Import your actual movie details widget


// User record model
class UserRecord {
  final String displayName;
  final List<DocumentReference> myList;

  UserRecord({
    required this.displayName,
    required this.myList,
  });

  static UserRecord fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserRecord(
      displayName: data['display_name'] ?? '',
      myList: List<DocumentReference>.from(data['my_list'] ?? []),
    );
  }
}

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});



  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  User? currentUser;
  UserRecord? userRecord;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (currentUser != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();
      if (snapshot.exists) {
        setState(() {
          userRecord = UserRecord.fromSnapshot(snapshot);
        });
      }
    }
  }

  Stream<List<MoviesRecord>> queryMoviesRecord({
    required Query Function(Query) queryBuilder,
  }) {
    return queryBuilder(FirebaseFirestore.instance.collection('movies'))
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => MoviesRecord.fromSnapshot(doc)).toList();
    });
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
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUser?.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          'Loading...',
                          style: TextStyle(
                            fontFamily: GoogleFonts.interTight().fontFamily,
                            color: Colors.white,
                            fontSize: 27,
                          ),
                        );
                      }

                      if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                        return Text(
                          'Welcome back',
                          style: TextStyle(
                            fontFamily: GoogleFonts.interTight().fontFamily,
                            color: Colors.white,
                            fontSize: 27,
                          ),
                        );
                      }

                      final data = snapshot.data!.data() as Map<String, dynamic>;
                      final displayName = data['display_name'] ?? '';

                      return Text(
                        'Welcome back, $displayName',
                        style: TextStyle(
                          fontFamily: GoogleFonts.interTight().fontFamily,
                          color: const Color(0xFFFEFEFE),
                          fontSize: 27,
                        ),
                      );
                    },
                  ),
                ),

                // My List Section
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const SizedBox();
                    }

                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    final myList = List<DocumentReference>.from(data['my_list'] ?? []);

                    if (myList.isEmpty) {
                      return const SizedBox();
                    }

                    return Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                            child: Text(
                              'My List',
                              style: TextStyle(
                                fontFamily: GoogleFonts.interTight().fontFamily,
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 7, 0, 0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 143,
                              child: ListView.separated(
                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: myList.length,
                                separatorBuilder: (_, __) => const SizedBox(width: 10),
                                itemBuilder: (context, index) {
                                  final movieRef = myList[index];
                                  return StreamBuilder<MoviesRecord>(
                                    stream: MoviesRecord.getDocument(movieRef),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Center(
                                          child: SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                Colors.red,
                                              ),
                                            ),
                                          ),
                                        );
                                      }

                                      final movie = snapshot.data!;
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                            MovieDetailsWidget.routeName,
                                            arguments: {'movieRef': movie.reference},
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.network(
                                            movie.image,
                                            width: 100,
                                            height: 200,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // All Movies Section
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                        child: Text(
                          'All movies',
                          style: TextStyle(
                            fontFamily: GoogleFonts.interTight().fontFamily,
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 7, 0, 0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 143,
                          child: StreamBuilder<List<MoviesRecord>>(
                            stream: queryMoviesRecord(
                              queryBuilder: (query) => query.orderBy('year', descending: true),
                            ),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.red,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              List<MoviesRecord> movies = snapshot.data!;
                              return ListView.separated(
                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: movies.length,
                                separatorBuilder: (_, __) => const SizedBox(width: 10),
                                itemBuilder: (context, index) {
                                  final movie = movies[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        MovieDetailsWidget.routeName,
                                        arguments: {'movieRef': movie.reference},
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        movie.image,
                                        width: 100,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Drama Section
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                        child: Text(
                          'Drama',
                          style: TextStyle(
                            fontFamily: GoogleFonts.interTight().fontFamily,
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 7, 0, 0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 143,
                          child: StreamBuilder<List<MoviesRecord>>(
                            stream: queryMoviesRecord(
                              queryBuilder: (query) => query.where('genre', isEqualTo: 'Drama'),
                            ),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.red,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              List<MoviesRecord> movies = snapshot.data!;
                              return ListView.separated(
                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: movies.length,
                                separatorBuilder: (_, __) => const SizedBox(width: 10),
                                itemBuilder: (context, index) {
                                  final movie = movies[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        MovieDetailsWidget.routeName,
                                        arguments: {'movieRef': movie.reference},
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        movie.image,
                                        width: 100,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Action Section
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                        child: Text(
                          'Action',
                          style: TextStyle(
                            fontFamily: GoogleFonts.interTight().fontFamily,
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 7, 0, 0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 143,
                          child: StreamBuilder<List<MoviesRecord>>(
                            stream: queryMoviesRecord(
                              queryBuilder: (query) => query.where('genre', isEqualTo: 'Action'),
                            ),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.red,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              List<MoviesRecord> movies = snapshot.data!;
                              return ListView.separated(
                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: movies.length,
                                separatorBuilder: (_, __) => const SizedBox(width: 10),
                                itemBuilder: (context, index) {
                                  final movie = movies[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        MovieDetailsWidget.routeName,
                                        arguments: {'movieRef': movie.reference},
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        movie.image,
                                        width: 100,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}