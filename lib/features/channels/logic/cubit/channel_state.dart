import 'package:sende_de_var/features/channels/data/model/members_model.dart';
import '../../data/model/channel_model.dart';

class ChannelState {
  final List<ChannelModel> channels;
  final List<MembersModel> members;
  final bool isLoading;
  final String? error;

  ChannelState({
    this.channels = const [],
    this.members = const [],
    this.isLoading = false,
    this.error,
  });

  ChannelState copyWith({
    List<ChannelModel>? channels,
    List<MembersModel>? members,
    bool? isLoading,
    String? error,
  }) {
    return ChannelState(
      channels: channels ?? this.channels,
      members: members ?? this.members,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
