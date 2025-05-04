import 'package:cloud_firestore/cloud_firestore.dart';

class MoviesRecord {
  final String title;
  final String description;
  final String image;
  final String length;
  final int year;
  final String trailerLink;
  final List<DocumentReference> likedByUsers;
  final DocumentReference reference;

  MoviesRecord({
    required this.title,
    required this.description,
    required this.image,
    required this.length,
    required this.year,
    required this.trailerLink,
    required this.likedByUsers,
    required this.reference,
  });

  factory MoviesRecord.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return MoviesRecord(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      length: data['length'] ?? '',
      year: data['year'] ?? 0,
      trailerLink: data['trailerLink'] ?? '',
      likedByUsers: List<DocumentReference>.from(data['likedByUsers'] ?? []),
      reference: snapshot.reference,
    );
  }

  static Stream<MoviesRecord> getDocument(DocumentReference documentReference) {
    return documentReference.snapshots().map((snapshot) => MoviesRecord.fromSnapshot(snapshot));
  }
}