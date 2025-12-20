import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String username;
  final String? mobileNumber;
  final String? photoUrl;
  final String authProvider; // 'email', 'google', 'facebook'
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.mobileNumber,
    this.photoUrl,
    required this.authProvider,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create UserModel from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      username: data['username'] ?? 'User',
      mobileNumber: data['mobileNumber'],
      photoUrl: data['photoUrl'],
      authProvider: data['authProvider'] ?? 'email',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Convert UserModel to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'username': username,
      'mobileNumber': mobileNumber,
      'photoUrl': photoUrl,
      'authProvider': authProvider,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create a copy with updated fields
  UserModel copyWith({
    String? uid,
    String? email,
    String? username,
    String? mobileNumber,
    String? photoUrl,
    String? authProvider,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      authProvider: authProvider ?? this.authProvider,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
