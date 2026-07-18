import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sende_de_var/features/channels/logic/cubit/channel_state.dart';
import '../../data/model/channel_model.dart';
import '../../data/services/channel_services.dart';

class ChannelCubit extends Cubit<ChannelState> {
  final ChannelServices channelServices;
  ChannelCubit(this.channelServices) : super(ChannelState());

  //get all channel
  Future<void> getAllChannels() async {
    try {
      emit(state.copyWith(isLoading: true));
      final channels = await channelServices.fetchAllChannels();
      emit(state.copyWith(channels: channels, isLoading: false));
    } on FirebaseException catch (e) {
      emit(state.copyWith(isLoading: false, error: e.message ?? 'Firestore hatası'));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  //save channel
  Future<void> saveChannel(ChannelModel channel) async {
    try {
      await channelServices.saveChannel(channel);
      emit(ChannelState(channels: state.channels, isLoading: false));
    } on FirebaseException catch (e) {
      emit(state.copyWith(error: e.message ?? 'Firestore hatası'));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  //get all addable members
  Future<void> getAllMembers() async {
    try {
      emit(state.copyWith(isLoading: true));
      final members = await channelServices.fetchAddableMembers();
      emit(state.copyWith(members: members, isLoading: false));
    } on FirebaseException catch (e) {
      emit(state.copyWith(isLoading: false, error: e.message ?? 'Firestore hatası'));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> getOwnedChannels() async {
    try {
      emit(state.copyWith(isLoading: true));
      final channels = await channelServices.fetchOwnedChannels();
      emit(state.copyWith(channels: channels, isLoading: false));
    } on FirebaseException catch (e) {
      emit(state.copyWith(isLoading: false, error: e.message ?? 'Firestore hatası'));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> getJoinedChannels() async {
    try {
      emit(state.copyWith(isLoading: true));
      final channels = await channelServices.fetchJoinedChannels();
      emit(state.copyWith(channels: channels, isLoading: false));
    } on FirebaseException catch (e) {
      emit(state.copyWith(isLoading: false, error: e.message ?? 'Firestore hatası'));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> getDiscoverableChannels() async {
    try {
      emit(state.copyWith(isLoading: true));
      final channels = await channelServices.fetchDiscoverableChannels();
      emit(state.copyWith(channels: channels, isLoading: false));
    } on FirebaseException catch (e) {
      emit(state.copyWith(isLoading: false, error: e.message ?? 'Firestore hatası'));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> joinChannel(String channelId) async {
    try {
      await channelServices.joinChannel(channelId);
      emit(ChannelState(channels: state.channels, isLoading: false));
    } on FirebaseException catch (e) {
      emit(state.copyWith(error: e.message ?? 'Firestore hatası'));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<bool> checkChannelOwnership(String channelId) async {
    try {
      return await channelServices.isChannelOwner(channelId);
    } catch (_) {
      return false;
    }
  }

  Future<void> refreshJoinedChannelsSilently() async {
    try {
      final channels = await channelServices.fetchJoinedChannels();
      emit(state.copyWith(channels: channels));
    } catch (e) {
      // Hata durumunda mevcut state'i koru, kullanıcıyı rahatsız etme
    }
  }
}
