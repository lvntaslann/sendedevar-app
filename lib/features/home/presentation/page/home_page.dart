import 'package:flutter/material.dart';
import 'package:sende_de_var/features/home/presentation/widgets/daily_hadis_card.dart';
import '../widgets/mini_container_row.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 30.h),
          const DailyHadisCard(),
          SizedBox(height: 20.h),
          const MiniContainerRow(),
        ],
      ),
    );
  }
}
