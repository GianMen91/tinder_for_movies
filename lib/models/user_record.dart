import 'package:cloud_firestore/cloud_firestore.dart';

class UserRecord {
  final String displayName;
  final List<DocumentReference> myList;
  static final CollectionReference collection =
  FirebaseFirestore.instance.collection('users');

  UserRecord({
    required this.displayName,
    required this.myList,
  });

  static Map<String, dynamic> createUsersRecordData({
    String? displayName,
  }) {
    return {
      'display_name': displayName,
      'createdTime': FieldValue.serverTimestamp(),
    };
  }

  static UserRecord fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserRecord(
      displayName: data['display_name'] ?? '',
      myList: List<DocumentReference>.from(data['myList'] ?? []),
    );
  }
}