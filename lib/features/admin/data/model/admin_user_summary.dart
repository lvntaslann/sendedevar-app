import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUserSummary {
  final String uid;
  final String name;
  final String surname;
  final String email;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;
  final String deviceModel;
  final String osVersion;
  final String appVersion;

  AdminUserSummary({
    required this.uid,
    required this.name,
    required this.surname,
    required this.email,
    required this.createdAt,
    required this.lastLoginAt,
    required this.deviceModel,
    required this.osVersion,
    required this.appVersion,
  });

  factory AdminUserSummary.fromMap(Map<String, dynamic> data, String uid) {
    return AdminUserSummary(
      uid: uid,
      name: data['name'] ?? '',
      surname: data['surname'] ?? '',
      email: data['email'] ?? '',
      createdAt: (data['createdAt'] is Timestamp)
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      lastLoginAt: (data['lastLoginAt'] is Timestamp)
          ? (data['lastLoginAt'] as Timestamp).toDate()
          : null,
      deviceModel: data['deviceModel'] ?? 'Bilinmiyor',
      osVersion: data['osVersion'] ?? 'Bilinmiyor',
      appVersion: data['appVersion'] ?? 'Bilinmiyor',
    );
  }
}
