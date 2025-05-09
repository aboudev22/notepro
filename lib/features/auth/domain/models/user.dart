import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String email;
  final String displayName;
  final bool isAdmin;
  final DateTime createdAt;
  final DateTime lastLogin;

  User({
    required this.id,
    required this.email,
    required this.displayName,
    required this.isAdmin,
    required this.createdAt,
    required this.lastLogin,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    Timestamp? createdAt = data['createdAt'] as Timestamp?;
    Timestamp? lastLogin = data['lastLogin'] as Timestamp?;

    return User(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      isAdmin: data['isAdmin'] ?? false,
      createdAt: createdAt?.toDate() ?? DateTime.now(),
      lastLogin: lastLogin?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'isAdmin': isAdmin,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLogin': Timestamp.fromDate(lastLogin),
    };
  }
}
