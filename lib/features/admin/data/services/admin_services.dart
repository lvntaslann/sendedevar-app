import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/admin_user_summary.dart';

class AdminServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> fetchTotalUserCount() async {
    final aggregate = await _firestore.collection('users').count().get();
    return aggregate.count ?? 0;
  }

  Future<List<AdminUserSummary>> fetchUsers() async {
    final snapshot = await _firestore.collection('users').get();

    final users = snapshot.docs
        .map((doc) => AdminUserSummary.fromMap(doc.data(), doc.id))
        .toList();

    users.sort((a, b) {
      final aDate = a.lastLoginAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.lastLoginAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });

    return users;
  }
}
