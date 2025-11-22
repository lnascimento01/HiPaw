import 'package:equatable/equatable.dart';

enum UserRole { admin, patient }

class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.email,
    required this.role,
    this.displayName,
  });

  final String id;
  final String email;
  final UserRole role;
  final String? displayName;

  bool get isAdmin => role == UserRole.admin;
  bool get isPatient => role == UserRole.patient;

  @override
  List<Object?> get props => [id, email, role, displayName];
}
