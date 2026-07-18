import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sende_de_var/features/channels/presentation/widgets/duty/completed_duty.dart';
import 'package:sende_de_var/features/channels/presentation/widgets/name_and_date.dart';
import 'package:sende_de_var/features/channels/presentation/widgets/user_profile_icon.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../data/model/duty_model.dart';

class StudentDetail extends StatelessWidget {
  final AppColors appColors;
  final String name;
  final String joinDate;
  final int completedDuties;
  final bool isUserOrDuty;
  final VoidCallback onTapDutyButton;
  final List<DutyModel> duties;
  final bool isTappedButton;

  const StudentDetail({
    Key? key,
    required this.appColors,
    required this.name,
    required this.joinDate,
    required this.completedDuties,
    required this.isUserOrDuty,
    required this.onTapDutyButton,
    required this.duties,
    required this.isTappedButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      padding: EdgeInsets.all(12.w),
      child: Column(
        children: [
          Row(
            children: [
              UserProfileIcon(appColors: appColors),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NameAndDate(
                      name: name,
                      appColors: appColors,
                      joinDate: joinDate,
                    ),
                  ],
                ),
              ),
              isUserOrDuty
                  ? CompletedDuty(
                      completedDuties: completedDuties,
                      appColors: appColors,
                    )
                  : Container(),
              if (!isUserOrDuty) ...[
                SizedBox(width: 8.w),
                IconButton(
                  onPressed: onTapDutyButton,
                  icon: Icon(
                    isTappedButton
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          ),

          if (isTappedButton && !isUserOrDuty) ...[
            SizedBox(height: 12.h),
            if (duties.isEmpty)
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Text(
                  'Henüz görev eklenmedi',
                  style: TextStyle(color: Colors.white60, fontSize: 14.sp),
                ),
              )
            else
              ...duties.map((duty) {
                final isDone = duty.status == 'done';
                final statusColor = isDone ? Colors.green : Colors.grey;

                return Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: isDone
                        ? Colors.green.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: statusColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isDone
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: statusColor,
                        size: 20.sp,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              duty.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              DateFormatter.formatDate(duty.createdAt),
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          isDone ? 'Tamamlandı' : 'Bekliyor',
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
          ],
        ],
      ),
    );
  }
}
