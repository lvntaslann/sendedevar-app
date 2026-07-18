import 'package:sende_de_var/features/channels/data/model/members_model.dart';

import '../model/channel_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChannelServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;
  final Map<String, DocumentReference<Map<String, dynamic>>> _channelRefCache = {};

  String get _currentUid => _user?.uid ?? (throw Exception('Not authenticated'));

  Future<String> _getCurrentUserName() async {
    final snap = await _firestore.collection('users').doc(_currentUid).get();
    return (snap.data()?['name'] as String?) ?? _user?.displayName ?? 'User';
  }

  Future<void> _ensureChannelIndex(String channelId, String ownerId) async {
    final idxRef = _firestore.collection('channel_index').doc(channelId);
    final idx = await idxRef.get();
    if (!idx.exists) {
      await idxRef.set({
        'ownerId': ownerId,
        'path': 'channels/$ownerId/user_channels/$channelId',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<DocumentReference<Map<String, dynamic>>?> _resolveChannelRef(String channelId) async {
    final cached = _channelRefCache[channelId];
    if (cached != null) return cached;
    final idxDoc = await _firestore.collection('channel_index').doc(channelId).get();
    if (idxDoc.exists) {
      final ownerId = (idxDoc.data()?['ownerId'] as String?) ?? '';
      if (ownerId.isNotEmpty) {
        final ref = _firestore.collection('channels').doc(ownerId).collection('user_channels').doc(channelId);
        _channelRefCache[channelId] = ref;
        return ref;
      }
    }
    final ownersSnap = await _firestore.collection('channels').get();
    for (final ownerDoc in ownersSnap.docs) {
      final candidateRef = ownerDoc.reference.collection('user_channels').doc(channelId);
      final candidateSnap = await candidateRef.get();
      if (candidateSnap.exists) {
        _channelRefCache[channelId] = candidateRef;
        await _firestore.collection('channel_index').doc(channelId).set({
          'ownerId': ownerDoc.id,
          'path': candidateRef.path,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        return candidateRef;
      }
    }
    return null;
  }

  Future<List<ChannelModel>> fetchOwnedChannels() async {
    try {
      final snapshot = await _firestore
          .collection('channels')
          .doc(_user?.uid)
          .collection('user_channels')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        if (!(data.containsKey('id')) || (data['id'] as String?)?.isEmpty == true) {
          data['id'] = doc.id;
        }
        _channelRefCache[data['id'] as String] = doc.reference;
        return ChannelModel.fromJson(data);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ChannelModel>> fetchJoinedChannels() async {
    try {
      final allChannelsSnapshot = await _firestore.collectionGroup('user_channels').get();

      final joinedChannels = <ChannelModel>[];

      for (var doc in allChannelsSnapshot.docs) {
        final data = doc.data();
        final members = (data['members'] as List<dynamic>?) ?? [];
        final isMember = members.any((m) => m['id'] == _user?.uid);

        if (isMember && doc.reference.parent.parent?.id != _user?.uid) {
          if (!(data.containsKey('id')) || (data['id'] as String?)?.isEmpty == true) {
            data['id'] = doc.id;
          }
          _channelRefCache[data['id'] as String] = doc.reference;
          joinedChannels.add(ChannelModel.fromJson(data));
        }
      }

      return joinedChannels;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ChannelModel>> fetchAllChannels() async {
    try {
      final owned = await fetchOwnedChannels();
      final joined = await fetchJoinedChannels();

      final allChannels = <String, ChannelModel>{};
      for (var channel in owned) {
        allChannels[channel.id] = channel;
      }
      for (var channel in joined) {
        allChannels[channel.id] = channel;
      }

      return allChannels.values.toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ChannelModel>> fetchDiscoverableChannels() async {
    try {
      final allChannelsSnapshot = await _firestore.collectionGroup('user_channels').get();
      final discoverableChannels = <ChannelModel>[];
      for (var doc in allChannelsSnapshot.docs) {
        if (doc.reference.parent.parent?.id == _user?.uid) continue;

        final data = doc.data();
        final members = (data['members'] as List<dynamic>?) ?? [];
        final isMember = members.any((m) => m['id'] == _user?.uid);
        if (!isMember) {
          if (!(data.containsKey('id')) || (data['id'] as String?)?.isEmpty == true) {
            data['id'] = doc.id;
          }
          _channelRefCache[data['id'] as String] = doc.reference;
          discoverableChannels.add(ChannelModel.fromJson(data));
        }
      }
      return discoverableChannels;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveChannel(ChannelModel channel) async {
    try {
      final ref = _firestore
          .collection('channels')
          .doc(_currentUid)
          .collection('user_channels')
          .doc(channel.id);
      await ref.set(channel.toJson());
      _channelRefCache[channel.id] = ref;
      await _ensureChannelIndex(channel.id, _currentUid);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isChannelOwner(String channelId) async {
    try {
      final doc = await _firestore
          .collection('channels')
          .doc(_user?.uid)
          .collection('user_channels')
          .doc(channelId)
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  Future<List<MembersModel>> fetchAddableMembers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      final currentUserId = _user?.uid;
      return snapshot.docs
          .where((doc) => doc.id != currentUserId)
          .map((doc) {
            final data = doc.data();
            return MembersModel(
              id: doc.id,
              name: data['name'] as String? ?? 'İsimsiz',
              role: 'User',
              joinedAt: Timestamp.now(),
            );
          })
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> joinChannel(String channelId) async {
    try {
      final userName = await _getCurrentUserName();

      final channelRef = await _resolveChannelRef(channelId);
      if (channelRef == null) {
        throw Exception('Channel not found');
      }
      await _firestore.runTransaction((tx) async {
        final snap = await tx.get(channelRef);
        final data = (snap.data() as Map<String, dynamic>);
        final rawMembers = (data['members'] as List<dynamic>? ?? []);

        final members = rawMembers.whereType<Map<String, dynamic>>().toList();
        final alreadyMember = members.any((m) => m['id'] == _currentUid);
        if (alreadyMember) return;
        final newMember = <String, dynamic>{
          'id': _currentUid,
          'name': userName,
          'role': 'User',
          'joinedAt': Timestamp.now(),
          'duties': <dynamic>[],
          'isSelected': false,
        };

        members.add(newMember);
        tx.update(channelRef, {'members': members});
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDutyStatus({
    required String channelId,
    required String memberId,
    required String dutyId,
    required String newStatus,
  }) async {
    try {
      final channelRef = _channelRefCache[channelId];
      if (channelRef == null) {
        throw Exception('Channel not found in cache');
      }

      await _firestore.runTransaction((tx) async {
        final snap = await tx.get(channelRef);
        final data = snap.data() as Map<String, dynamic>;
        final members = (data['members'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];

        final memberIndex = members.indexWhere((m) => m['id'] == memberId);
        if (memberIndex == -1) throw Exception('Member not found');

        final duties = (members[memberIndex]['duties'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
        final dutyIndex = duties.indexWhere((d) => d['id'] == dutyId);
        if (dutyIndex == -1) throw Exception('Duty not found');

        duties[dutyIndex]['status'] = newStatus;
        members[memberIndex]['duties'] = duties;

        tx.update(channelRef, {'members': members});
      });
    } catch (e) {
      rethrow;
    }
  }
}
