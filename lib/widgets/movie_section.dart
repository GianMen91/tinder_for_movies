import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/movies_record.dart';
import 'movie_list_view.dart';

class MovieSection extends StatelessWidget {
  final String title;
  final Query Function(Query) queryBuilder;
  final double bottomPadding;

  const MovieSection({
    super.key,
    required this.title,
    required this.queryBuilder,
    this.bottomPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontFamily: GoogleFonts.interTight().fontFamily,
      color: Colors.white,
      fontSize: 17,
    );

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
            child: Text(title, style: titleStyle),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 7, 0, 0),
            child: SizedBox(
              height: 143,
              child: StreamBuilder<List<MoviesRecord>>(
                stream: FirebaseFirestore.instance
                    .collection('movies')
                    .snapshots()
                    .map((snapshot) => snapshot.docs
                    .map((doc) => MoviesRecord.fromSnapshot(doc))
                    .toList()),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      ),
                    );
                  }

                  final movies = snapshot.data!;
                  return MovieListView(movies: movies);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}