import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../data/model/admin_user_summary.dart';
import '../../data/services/admin_services.dart';

class AdminStatsPage extends StatefulWidget {
  const AdminStatsPage({super.key});

  @override
  State<AdminStatsPage> createState() => _AdminStatsPageState();
}

class _AdminStatsPageState extends State<AdminStatsPage> {
  final AdminServices _adminServices = AdminServices();

  int? _totalUsers;
  List<AdminUserSummary> _users = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        _adminServices.fetchTotalUserCount(),
        _adminServices.fetchUsers(),
      ]);
      setState(() {
        _totalUsers = results[0] as int;
        _users = results[1] as List<AdminUserSummary>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors(isDarkMode: false);

    return Scaffold(
      backgroundColor: appColors.profilePage.pageBgColor,
      appBar: const CustomAppBar(title: "Yönetim Paneli", showBackButton: true),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Text(
                        "Veriler yüklenemedi:\n$_error",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  )
                : ListView(
                    padding: EdgeInsets.all(16.w),
                    children: [
                      _buildTotalUsersCard(appColors),
                      SizedBox(height: 20.h),
                      Text(
                        "Kullanıcılar (${_users.length})",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      ..._users.map((user) => _buildUserCard(appColors, user)),
                    ],
                  ),
      ),
    );
  }

  Widget _buildTotalUsersCard(AppColors appColors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF58A47A), Color(0xFF22C55E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          Icon(Icons.groups_rounded, color: Colors.white, size: 36.sp),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${_totalUsers ?? 0}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "Toplam Kayıtlı Kullanıcı",
                style: TextStyle(color: Colors.white70, fontSize: 13.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(AppColors appColors, AdminUserSummary user) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: appColors.profilePage.contentContainerBgColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: appColors.profilePage.dailyStatusCompletedColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "${user.name} ${user.surname}".trim().isEmpty
                      ? user.email
                      : "${user.name} ${user.surname}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            user.email,
            style: TextStyle(color: Colors.white54, fontSize: 12.sp),
          ),
          SizedBox(height: 10.h),
          _infoLine(Icons.phone_android, "Cihaz", user.deviceModel),
          _infoLine(Icons.memory, "İşletim Sistemi", user.osVersion),
          _infoLine(Icons.info_outline, "Uygulama Sürümü", user.appVersion),
          _infoLine(
            Icons.login,
            "Son Oturum",
            user.lastLoginAt != null
                ? DateFormatter.formatDate(user.lastLoginAt!)
                : "Henüz giriş yapmadı",
          ),
          _infoLine(
            Icons.calendar_today_outlined,
            "Üyelik Tarihi",
            user.createdAt != null ? DateFormatter.formatDate(user.createdAt!) : "-",
          ),
        ],
      ),
    );
  }

  Widget _infoLine(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Row(
        children: [
          Icon(icon, color: Colors.white38, size: 14.sp),
          SizedBox(width: 6.w),
          Text(
            "$label: ",
            style: TextStyle(color: Colors.white38, fontSize: 12.sp),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.white70, fontSize: 12.sp),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
