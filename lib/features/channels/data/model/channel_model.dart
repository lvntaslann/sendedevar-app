import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sende_de_var/features/channels/data/model/members_model.dart';

class ChannelModel {
  final String id;
  final String title;
  final String subTitle;
  final List<MembersModel> members;
  final Timestamp createdAt;

  ChannelModel({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.members,
    required this.createdAt,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subTitle: json['subTitle'] as String,
      members: (json['members'] as List)
          .map((e) => MembersModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] is Timestamp 
          ? json['createdAt'] as Timestamp
          : Timestamp.fromDate(DateTime.parse(json['createdAt'] as String)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subTitle': subTitle,
      'members': members.map((e) => e.toMap()).toList(),
      'createdAt': createdAt.toDate().toIso8601String(),
    };
  }
}
