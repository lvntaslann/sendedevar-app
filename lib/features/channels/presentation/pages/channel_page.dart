import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sunnet_app/features/channels/data/model/members_model.dart';
import 'package:sunnet_app/features/channels/logic/cubit/channel_state.dart';
import 'package:sunnet_app/features/channels/presentation/widgets/showdialog/add_member_dialog.dart';
import '../../../../core/routes/app_routes.dart'; // Yönlendirme için eklendi
import '../../../auth/logic/cubit/user_cubit.dart'; // UserCubit kontrolü için eklendi
import 'duty_page.dart';
import '../../../../core/themes/app_colors.dart';
import '../../data/model/channel_model.dart';
import '../../logic/cubit/channel_cubit.dart';
import '../widgets/button/channel_default_button.dart';
import '../widgets/button/switch_Item_button_left.dart';
import '../widgets/button/switch_item_button_right.dart';
import '../widgets/channel/content_container.dart';
import '../widgets/channel/discoverable_channels_list.dart';

class ChannelPage extends StatefulWidget {
  const ChannelPage({Key? key}) : super(key: key);

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  bool isSwitched = false;
  TextEditingController subjectController = TextEditingController();
  final Set<String> _joiningChannels = {};
  List<ChannelModel> _discoverableChannels = [];
  bool _loadingDiscoverable = false;

  void toggleSwitch() {
    setState(() {
      isSwitched = !isSwitched;
      _loadChannels();
      if (isSwitched) {
        _loadDiscoverableChannels();
      }
    });
  }

  void _loadChannels() {
    // Sadece giriş yapılmışsa verileri çek
    final isAuth = context.read<UserCubit>().state.isAuthenticated;
    if (!isAuth) return;

    if (isSwitched) {
      context.read<ChannelCubit>().getJoinedChannels();
      _loadDiscoverableChannels();
    } else {
      context.read<ChannelCubit>().getOwnedChannels();
    }
  }

  void _loadDiscoverableChannels() async {
    if (!isSwitched) return;

    final isAuth = context.read<UserCubit>().state.isAuthenticated;
    if (!isAuth) return;

    setState(() {
      _loadingDiscoverable = true;
    });
    try {
      final channels = await context
          .read<ChannelCubit>()
          .channelServices
          .fetchDiscoverableChannels();
      if (mounted) {
        setState(() {
          _discoverableChannels = channels;
          _loadingDiscoverable = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingDiscoverable = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final isAuth = context.read<UserCubit>().state.isAuthenticated;
    if (isAuth) {
      _loadChannels();
      context.read<ChannelCubit>().getAllMembers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors(isDarkMode: false);
    // Kullanıcının giriş yapıp yapmadığını dinliyoruz
    final isAuth = context.watch<UserCubit>().state.isAuthenticated;

    return Scaffold(
      backgroundColor: appColors.channelsPage.pageBgColor,
      // Eğer giriş yapmadıysa Guest (Misafir) ekranını, yaptıysa normal ekranı göster
      body: !isAuth
          ? _buildGuestView(context, appColors)
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SwitchItemButtonLeft(
                          title: "Kanallarım",
                          appColors: appColors,
                          isActive: !isSwitched,
                          onTap: toggleSwitch,
                        ),
                        SwitchItemButtonRight(
                          title: "Katıldığım Kanallar",
                          appColors: appColors,
                          isActive: isSwitched,
                          onTap: toggleSwitch,
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),

                    Expanded(
                      child: BlocBuilder<ChannelCubit, ChannelState>(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state.error != null) {
                            return Center(
                              child: Text(
                                "Hata: ${state.error}",
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          }

                          final channels = state.channels;

                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (channels.isEmpty)
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 40.h),
                                      child: Text(
                                        isSwitched
                                            ? "Henüz katıldığınız kanal yok."
                                            : "Henüz kanal oluşturmadınız.",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: channels.length,
                                    itemBuilder: (context, index) {
                                      final channel = channels[index];
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 12.h),
                                        child: ContentContainer(
                                          title: channel.title,
                                          subTitle: '${channel.members.length}',
                                          appColors: appColors,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => DutyPage(
                                                  channel: channel,
                                                  members: channel.members,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),

                                if (isSwitched) ...[
                                  SizedBox(height: 30.h),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                    ),
                                    child: Text(
                                      "Katılabileceğim Kanallar",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  DiscoverableChannelsList(
                                    isLoading: _loadingDiscoverable,
                                    channels: _discoverableChannels,
                                    joiningChannels: _joiningChannels,
                                    appColors: appColors,
                                    onJoinStart: (channelId) {
                                      setState(() {
                                        _joiningChannels.add(channelId);
                                      });
                                    },
                                    onJoinSuccess: (channelId) {
                                      if (mounted) {
                                        setState(() {
                                          _discoverableChannels.removeWhere(
                                            (c) => c.id == channelId,
                                          );
                                          _joiningChannels.remove(channelId);
                                        });
                                      }
                                    },
                                    onJoinError: (channelId) {
                                      if (mounted) {
                                        setState(() {
                                          _joiningChannels.remove(channelId);
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 10.h),

                    if (!isSwitched)
                      ChannelDefaultButton(
                        onTap: () async {
                          await context.read<ChannelCubit>().getAllMembers();

                          final currentState = context
                              .read<ChannelCubit>()
                              .state;

                          final selectedMembers =
                              await showDialog<List<MembersModel>>(
                                context: context,
                                builder: (context) => AddChannelDialog(
                                  key: ValueKey(
                                    DateTime.now().millisecondsSinceEpoch,
                                  ),
                                  addableMembers: currentState.members,
                                  appColors: appColors,
                                  subjectController: subjectController,
                                ),
                              );

                          if (selectedMembers == null ||
                              subjectController.text.trim().isEmpty) {
                            return;
                          }

                          final channel = ChannelModel(
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            title: subjectController.text.trim(),
                            subTitle: 'Kanal Açıklaması',
                            members: selectedMembers,
                            createdAt: Timestamp.now(),
                          );

                          await context.read<ChannelCubit>().saveChannel(
                            channel,
                          );
                          _loadChannels();
                          subjectController.clear();
                        },
                        appColors: appColors,
                        title: "Yeni Kanal Oluştur",
                      ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
    );
  }

  // GİRİŞ YAPMAMIŞ KULLANICI İÇİN GÖSTERİLECEK EKRAN
  Widget _buildGuestView(BuildContext context, AppColors appColors) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_alt_outlined, size: 80.sp, color: Colors.white54),
            SizedBox(height: 20.h),
            Text(
              "Kanallara katılmak veya oluşturmak için\ngiriş yapmanız gerekmektedir.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 30.h),
            ChannelDefaultButton(
              title: "Giriş Yap / Üye Ol",
              appColors: appColors,
              onTap: () {
                Navigator.pushNamed(context, Routes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
