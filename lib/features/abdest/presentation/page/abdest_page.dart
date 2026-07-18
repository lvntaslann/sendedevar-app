import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sende_de_var/core/constants/abdest.dart';
import 'package:sende_de_var/core/themes/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_content_widget.dart';

class AbdestPage extends StatelessWidget {
  const AbdestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors(isDarkMode: false);
    return Scaffold(
      backgroundColor: appColors.abdestPage.pageBgColor,
      appBar: const CustomAppBar(title: "Abdest nasıl alınır ?",showBackButton: true,),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(top: 15.h, bottom: 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: abdestContent.map((item) {
              return CustomContentWidget(
                appColors: appColors,
                imagePath: item.imagePath,
                imageWidth: item.width,
                imageHeight: item.height,
                title: item.title,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
