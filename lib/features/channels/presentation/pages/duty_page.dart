import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sende_de_var/core/widgets/custom_app_bar.dart';
import 'package:sende_de_var/features/channels/logic/cubit/duty_cubit.dart';
import 'package:sende_de_var/features/channels/logic/cubit/channel_cubit.dart';
import 'package:sende_de_var/features/channels/presentation/widgets/button/add_duty_floating_button.dart';
import '../../../../core/themes/app_colors.dart';
import '../../data/model/channel_model.dart';
import '../../data/model/members_model.dart';
import '../widgets/button/channel_default_button.dart';
import '../widgets/duty/student_detail.dart';
import '../widgets/button/switch_Item_button_left.dart';
import '../widgets/button/switch_item_button_right.dart';
import '../../../../core/utils/date_formatter.dart';

class DutyPage extends StatefulWidget {
  final ChannelModel channel;
  final List<MembersModel> members;

  const DutyPage({Key? key, required this.channel, required this.members})
    : super(key: key);

  @override
  _DutyPageState createState() => _DutyPageState();
}

class _DutyPageState extends State<DutyPage> {
  bool isSwitched = true;
  bool onTapDutyButton = false;
  Set<int> expandedIndexes = {};
  TextEditingController subjectController = TextEditingController();
  late List<MembersModel> _currentMembers;
  bool _isOwner = false;

  @override
  void initState() {
    super.initState();
    _currentMembers = widget.members;
    _checkOwnership();
    context.read<DutyCubit>().getAllDuties(widget.channel.id);
  }

  Future<void> _checkOwnership() async {
    final isOwner = await context.read<ChannelCubit>().checkChannelOwnership(
      widget.channel.id,
    );

    setState(() {
      _isOwner = isOwner;
    });
  }

  void toggleSwitch() {
    setState(() {
      isSwitched = !isSwitched;
      expandedIndexes.clear();
    });
  }

  void toggleDutyButton(int index) {
    setState(() {
      if (expandedIndexes.contains(index)) {
        expandedIndexes.remove(index);
      } else {
        expandedIndexes.add(index);
      }
    });
  }

  Future<void> _refreshChannel() async {
    await context.read<ChannelCubit>().getAllChannels();
    final updatedChannel = context
        .read<ChannelCubit>()
        .state
        .channels
        .firstWhere((ch) => ch.id == widget.channel.id);
    setState(() {
      _currentMembers = updatedChannel.members;
    });
  }



  @override
  Widget build(BuildContext context) {
    final appColors = AppColors(isDarkMode: false);

    return Scaffold(
      backgroundColor: appColors.channelsPage.pageBgColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            CustomAppBar(title: widget.channel.title, showBackButton: true),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SwitchItemButtonLeft(
                  appColors: appColors,
                  title: "Üyeler",
                  isActive: isSwitched,
                  onTap: () {
                    toggleSwitch();
                  },
                ),
                SwitchItemButtonRight(
                  title: "Görevler",
                  appColors: appColors,
                  isActive: !isSwitched,
                  onTap: () {
                    toggleSwitch();
                  },
                ),
              ],
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _currentMembers.length,
              itemBuilder: (context, index) {
                final m = _currentMembers[index];
                final completedCount = m.duties.where((d) => d.status == 'done').length;

                return StudentDetail(
                  appColors: appColors,
                  name: m.name,
                  joinDate: DateFormatter.formatDate(m.joinedAt.toDate()),
                  completedDuties: completedCount,
                  isUserOrDuty: isSwitched,
                  onTapDutyButton: () => toggleDutyButton(index),
                  duties: m.duties,
                  isTappedButton: expandedIndexes.contains(index),
                );
              },
            ),
            SizedBox(height: 330.h),

            if (_isOwner)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ChannelDefaultButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  appColors: appColors,
                  title: "Kanalı Kapat",
                ),
              ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
      floatingActionButton: !isSwitched && _isOwner
          ? AddDutyFloatingButton(
              members: _currentMembers,
              appColors: appColors,
              channelId: widget.channel.id,
              onDutyAdded: _refreshChannel,
            )
          : null,
    );
  }
}
