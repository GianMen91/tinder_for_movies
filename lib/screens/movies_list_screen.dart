import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tinder_for_movies/widgets/app_logo.dart';

import '../models/movies_record.dart';
import '../models/user_record.dart';
import '../widgets/movie_list_section.dart';
import '../widgets/movie_section.dart';

class MoviesListScreen extends StatefulWidget {
  const MoviesListScreen({super.key});

  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
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
        .map((snapshot) =>
        snapshot.docs.map((doc) => MoviesRecord.fromSnapshot(doc)).toList());
  }

  TextStyle get sectionTitleStyle => TextStyle(
    fontFamily: GoogleFonts.interTight().fontFamily,
    color: Colors.white,
    fontSize: 17,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const AppLogo(),
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Text
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    final name = snapshot.data?.data()
                    as Map<String, dynamic>? ?? {};
                    final displayName = name['display_name'] ?? '';

                    return Text(
                      displayName.isNotEmpty
                          ? 'Welcome back, $displayName'
                          : 'Welcome back',
                      style: TextStyle(
                        fontFamily: GoogleFonts.interTight().fontFamily,
                        color: Colors.white,
                        fontSize: 27,
                      ),
                    );
                  },
                ),
              ),

              // My List
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const SizedBox();
                  }

                  final data =
                      snapshot.data!.data() as Map<String, dynamic>? ?? {};
                  final myList = List<DocumentReference>.from(data['myList'] ?? []);

                  if (myList.isEmpty) return const SizedBox();

                  return MovieListSection(
                    title: 'My List',
                    movieReferences: myList,
                  );
                },
              ),

              // Other Categories
              MovieSection(
                title: 'All movies',
                queryBuilder: (q) => q.orderBy('year', descending: true),
              ),
              MovieSection(
                title: 'Drama',
                queryBuilder: (q) => q.where('genre', isEqualTo: 'Drama'),
              ),
              MovieSection(
                title: 'Action',
                queryBuilder: (q) => q.where('genre', isEqualTo: 'Action'),
                bottomPadding: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}








