import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sende_de_var/features/profile/presentation/widgets/task_item.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/font_size.dart';

class TaskSection extends StatelessWidget {
  final AppColors appColors;

  const TaskSection({required this.appColors, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 30.w),
          child: Text(
            "Bugünün İşleri",
            style: TextStyle(
              color: appColors.profilePage.textColor,
              fontSize: AppFontSizes.s16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        TaskItem(
          title: "Kur'an tilaveti",
          statusText: "Tamamlandı",
          isCompleted: true,
          appColors: appColors,
        ),
        SizedBox(height: 10.h),
        TaskItem(
          title: "Beş vakit namaz",
          statusText: "Tamamlandı",
          isCompleted: true,
          appColors: appColors,
        ),
        SizedBox(height: 10.h),
        TaskItem(
          title: "Hadis çalışması",
          statusText: "Devam Ediyor",
          isCompleted: false,
          appColors: appColors,
        ),
      ],
    );
  }
}