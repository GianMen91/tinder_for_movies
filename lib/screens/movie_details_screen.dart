import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/movies_record.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({
    super.key,
    required this.movieReference,
  });

  final DocumentReference? movieReference;

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  DocumentReference? get _currentUserRef {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    return FirebaseFirestore.instance.collection('users').doc(uid);
  }

  Future<void> _openTrailerUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _addToMyList(MoviesRecord movie) async {
    await _currentUserRef?.update({
      'myList': FieldValue.arrayUnion([movie.reference]),
    });
    await movie.reference?.update({
      'likedByUsers': FieldValue.arrayUnion([_currentUserRef]),
    });
  }

  Future<void> _removeFromMyList(MoviesRecord movie) async {
    await _currentUserRef?.update({
      'myList': FieldValue.arrayRemove([movie.reference]),
    });
    await movie.reference?.update({
      'likedByUsers': FieldValue.arrayRemove([_currentUserRef]),
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MoviesRecord>(
      stream: MoviesRecord.getDocument(widget.movieReference!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        final movie = snapshot.data!;
        final isLiked = movie.likedByUsers.contains(_currentUserRef);

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                movie.title,
                style: GoogleFonts.interTight(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMovieHeader(movie),
                    const SizedBox(height: 20),
                    _buildActionButton(movie, isLiked),
                    const SizedBox(height: 20),
                    Text(
                      movie.description,
                      style: GoogleFonts.interTight(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMovieHeader(MoviesRecord movie) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            movie.image,
            width: 140,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailText(movie.title),
              _buildDetailText(movie.length),
              _buildDetailText(movie.year.toString()),
              InkWell(
                onTap: () => _openTrailerUrl(movie.trailerLink),
                child: _buildDetailText('Watch Trailer', underline: true),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailText(String text, {bool underline = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: GoogleFonts.interTight(
          color: Colors.white,
          fontSize: 17,
          decoration: underline ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    );
  }

  Widget _buildActionButton(MoviesRecord movie, bool isLiked) {
    return ElevatedButton(
      onPressed: () => isLiked ? _removeFromMyList(movie) : _addToMyList(movie),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF43474C),
        minimumSize: const Size(double.infinity, 40),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        isLiked ? 'Remove from my list' : 'Add to my list',
        style: GoogleFonts.interTight(
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
