import '../../domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  const AppUserModel({
    required super.id,
    required super.email,
    required super.role,
    super.displayName,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      role: UserRole.values.firstWhere(
        (role) => role.name == json['role'],
        orElse: () => UserRole.patient,
      ),
      displayName: json['displayName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role.name,
      'displayName': displayName,
    };
  }

  factory AppUserModel.fromFirestore(
    Map<String, dynamic> data, {
    required String id,
  }) {
    return AppUserModel(
      id: id,
      email: data['email'] as String,
      role: UserRole.values.firstWhere(
        (role) => role.name == data['role'],
        orElse: () => UserRole.patient,
      ),
      displayName: data['displayName'] as String?,
    );
  }
}
