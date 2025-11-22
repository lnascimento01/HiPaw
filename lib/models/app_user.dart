import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { admin, patient }

class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String email;
  final UserRole role;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isAdmin => role == UserRole.admin;

  factory AppUser.fromMap(String id, Map<String, dynamic> data) {
    return AppUser(
      id: id,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      role: (data['role'] as String? ?? 'patient') == 'admin' ? UserRole.admin : UserRole.patient,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': id,
        'name': name,
        'email': email,
        'role': role.name,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
