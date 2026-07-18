import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../admin/presentation/page/admin_stats_page.dart';
import '../../../auth/data/model/user_model.dart';
import '../../../auth/logic/cubit/user_cubit.dart';

class ProfileSettingsSection extends StatelessWidget {
  final AppColors appColors;
  final UserModel user;
  final bool isAdmin;

  const ProfileSettingsSection({
    super.key,
    required this.appColors,
    required this.user,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hesap ve Gizlilik',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          if (isAdmin) ...[
            _SettingsTile(
              appColors: appColors,
              icon: Icons.admin_panel_settings_outlined,
              title: 'Yönetim Paneli',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminStatsPage()),
              ),
            ),
            SizedBox(height: 10.h),
          ],
          _SettingsTile(
            appColors: appColors,
            icon: Icons.person_outline,
            title: 'Hesap Bilgileri',
            onTap: () => _showAccountInfoSheet(context),
          ),
          SizedBox(height: 10.h),
          _SettingsTile(
            appColors: appColors,
            icon: Icons.shield_outlined,
            title: 'Veri Güvenliği',
            onTap: () => _showInfoSheet(
              context,
              icon: Icons.shield_outlined,
              title: 'Veri Güvenliği',
              content: _dataSecurityText,
            ),
          ),
          SizedBox(height: 10.h),
          _SettingsTile(
            appColors: appColors,
            icon: Icons.description_outlined,
            title: 'KVKK Aydınlatma Metni',
            onTap: () => _showInfoSheet(
              context,
              icon: Icons.description_outlined,
              title: 'KVKK Aydınlatma Metni',
              content: _kvkkText,
            ),
          ),
          SizedBox(height: 10.h),
          _SettingsTile(
            appColors: appColors,
            icon: Icons.logout,
            title: 'Çıkış Yap',
            isDestructive: true,
            onTap: () => _confirmSignOut(context),
          ),
        ],
      ),
    );
  }

  void _showAccountInfoSheet(BuildContext context) {
    final joinDate = DateFormatter.formatDate(user.createdAt);

    _showInfoSheet(
      context,
      icon: Icons.person_outline,
      title: 'Hesap Bilgileri',
      contentBuilder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow('Ad Soyad', '${user.name} ${user.surname}'),
          _infoRow('E-posta', user.email),
          _infoRow('Üyelik Tarihi', joinDate),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: appColors.profilePage.levelTextColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoSheet(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? content,
    WidgetBuilder? contentBuilder,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF102117),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.35,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Icon(icon, color: const Color(0xFF22C55E), size: 22.sp),
                      SizedBox(width: 8.w),
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: contentBuilder != null
                          ? contentBuilder(context)
                          : Text(
                              content ?? '',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14.sp,
                                height: 1.6,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF102117),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: const Text('Çıkış Yap', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Hesabından çıkış yapmak istediğine emin misin?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Vazgeç', style: TextStyle(color: Colors.white70)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<UserCubit>().signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.login,
                  (route) => false,
                );
              },
              child: const Text('Çıkış Yap', style: TextStyle(color: Color(0xFFEF4444))),
            ),
          ],
        );
      },
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final AppColors appColors;
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsTile({
    required this.appColors,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? const Color(0xFFEF4444) : Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: appColors.profilePage.contentContainerBgColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isDestructive
                ? const Color(0xFFEF4444).withOpacity(0.3)
                : appColors.profilePage.dailyStatusCompletedColor.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: color, size: 19.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: color.withOpacity(0.5), size: 20.sp),
          ],
        ),
      ),
    );
  }
}

const _dataSecurityText = '''
Verilerinin güvenliği bizim için önemlidir.

• Hesabın Google Firebase Authentication altyapısı ile korunur; şifren şifrelenmiş olarak saklanır, bize veya üçüncü kişilere açık metin olarak görünmez.

• Profil ve görev verilerin Google Cloud Firestore üzerinde, endüstri standardı erişim kontrolleriyle saklanır.

• Konum bilgin yalnızca kıble yönü, namaz vakitleri ve yakın cami önerisi gibi özellikleri çalıştırmak için anlık olarak kullanılır; kalıcı olarak sunucularımızda saklanmaz.

• Verilerin reklam amacıyla üçüncü taraflarla paylaşılmaz veya satılmaz.

• Hesabını ve verilerini istediğin zaman silmemizi talep edebilirsin.
''';

const _kvkkText = '''
6698 Sayılı Kişisel Verilerin Korunması Kanunu ("KVKK") Aydınlatma Metni

Uygulamamızı kullanırken ad, soyad, e-posta adresi ve kullanım tercihlerin gibi kişisel verilerin, KVKK'ya uygun şekilde işlenmektedir.

1. Veri Sorumlusu
Kişisel verilerin, uygulamanın işletmecisi tarafından veri sorumlusu sıfatıyla işlenmektedir.

2. İşlenen Veriler
Ad, soyad, e-posta adresi, üyelik tarihi, görev/ibadet takip verileri ve (izin verildiğinde) konum bilgisi.

3. İşleme Amaçları
Hesabının oluşturulması ve yönetimi, namaz vakti ve kıble yönü gibi hizmetlerin sunulması, görevlerinin takip edilmesi ve uygulama güvenliğinin sağlanması.

4. Verilerin Aktarımı
Verilerin yalnızca hizmetin sunulması için gerekli olan Firebase (Google) altyapı sağlayıcısı ile paylaşılır; pazarlama amacıyla üçüncü kişilerle paylaşılmaz.

5. Haklarların
KVKK'nın 11. maddesi kapsamında verilerine erişme, düzeltme, silme ve işlenmesine itiraz etme hakkına sahipsin. Taleplerini uygulama içinden bize iletebilirsin.
''';
