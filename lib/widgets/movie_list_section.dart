import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/movies_record.dart';
import 'movie_thumbnail.dart';

class MovieListSection extends StatelessWidget {
  final String title;
  final List<DocumentReference> movieReferences;

  const MovieListSection({
    super.key,
    required this.title,
    required this.movieReferences,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontFamily: GoogleFonts.interTight().fontFamily,
      color: Colors.white,
      fontSize: 17,
    );

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
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
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                scrollDirection: Axis.horizontal,
                itemCount: movieReferences.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final ref = movieReferences[index];
                  return StreamBuilder<MoviesRecord>(
                    stream: MoviesRecord.getDocument(ref),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.red),
                            ),
                          ),
                        );
                      }

                      final movie = snapshot.data!;
                      return MovieThumbnail(movie: movie);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}