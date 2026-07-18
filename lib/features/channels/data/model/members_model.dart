import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sende_de_var/features/channels/data/model/duty_model.dart';

class MembersModel {
  final String id;
  final String name;
  final String role;
  final Timestamp joinedAt;
  final List<DutyModel> duties;
  final bool isSelected;

  MembersModel({
    required this.id,
    required this.name,
    required this.role,
    required this.joinedAt,
    this.isSelected = false,
    this.duties = const [],
  });

  factory MembersModel.fromMap(Map<String, dynamic> map) {
    return MembersModel(
      id: map['id'] as String,
      name: map['name'] as String,
      role: map['role'] as String,
      joinedAt: map['joinedAt'] is Timestamp 
          ? map['joinedAt'] as Timestamp
          : Timestamp.fromDate(DateTime.parse(map['joinedAt'] as String)),
      duties: (map['duties'] as List<dynamic>? ?? [])
          .map((e) => DutyModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      isSelected: map['isSelected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'joinedAt': joinedAt.toDate().toIso8601String(),
      'duties': duties.map((e) => e.toMap()).toList(),
      'isSelected': isSelected,
    };
  }
}