import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'movies_record.dart';


class MovieDetailsWidget extends StatefulWidget {
  const MovieDetailsWidget({
    super.key,
    required this.receiveMovie,
  });

  final DocumentReference? receiveMovie;

  static String routeName = 'MovieDetails';
  static String routePath = '/movieDetails';

  @override
  State<MovieDetailsWidget> createState() => _MovieDetailsWidgetState();
}

class _MovieDetailsWidgetState extends State<MovieDetailsWidget> {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Get current user reference
  DocumentReference? get currentUserReference =>
      FirebaseFirestore.instance.collection('users').doc(
        /* Replace with your auth implementation */
        // For example: FirebaseAuth.instance.currentUser?.uid
      );

  @override
  void initState() {
    super.initState();


  }

  @override
  void dispose() {

    super.dispose();
  }

  // Launch URL helper function
  Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MoviesRecord>(
      stream: MoviesRecord.getDocument(widget.receiveMovie!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          );
        }

        final movieDetailsMoviesRecord = snapshot.data!;

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
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                movieDetailsMoviesRecord.title,
                style: GoogleFonts.interTight(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: const [],
              centerTitle: true,
            ),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            movieDetailsMoviesRecord.image,
                            width: 140,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                child: Text(
                                  movieDetailsMoviesRecord.title,
                                  style: GoogleFonts.interTight(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                child: Text(
                                  movieDetailsMoviesRecord.length,
                                  style: GoogleFonts.interTight(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                child: Text(
                                  movieDetailsMoviesRecord.year.toString(),
                                  style: GoogleFonts.interTight(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await launchURL(movieDetailsMoviesRecord.trailerLink);
                                },
                                child: Text(
                                  'Watch Trailer',
                                  style: GoogleFonts.interTight(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (movieDetailsMoviesRecord.likedByUsers.contains(currentUserReference) == false)
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                      child: ElevatedButton(
                        onPressed: () async {
                          // Update the current user's my list
                          await currentUserReference?.update({
                            'myList': FieldValue.arrayUnion([movieDetailsMoviesRecord.reference]),
                          });

                          // Update the movie's liked by users
                          await movieDetailsMoviesRecord.reference.update({
                            'likedByUsers': FieldValue.arrayUnion([currentUserReference]),
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF43474C),
                          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                          minimumSize: const Size(double.infinity, 40),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Add to my list',
                          style: GoogleFonts.interTight(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  if (movieDetailsMoviesRecord.likedByUsers.contains(currentUserReference) == true)
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                      child: ElevatedButton(
                        onPressed: () async {
                          // Remove from the current user's my list
                          await currentUserReference?.update({
                            'myList': FieldValue.arrayRemove([movieDetailsMoviesRecord.reference]),
                          });

                          // Remove from the movie's liked by users
                          await movieDetailsMoviesRecord.reference.update({
                            'likedByUsers': FieldValue.arrayRemove([currentUserReference]),
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF43474C),
                          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                          minimumSize: const Size(double.infinity, 40),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Remove from my list',
                          style: GoogleFonts.interTight(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      movieDetailsMoviesRecord.description,
                      style: GoogleFonts.interTight(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}