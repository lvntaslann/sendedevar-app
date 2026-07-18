import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sende_de_var/core/utils/name_utils.dart';
import '../../../../channels/data/model/members_model.dart';

class MemberSelectionGrid extends StatelessWidget {
  final List<MembersModel> members;
  final Set<String> selectedIds;
  final Function(String) onToggleSelect;

  const MemberSelectionGrid({
    Key? key,
    required this.members,
    required this.selectedIds,
    required this.onToggleSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      height: 270.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 12.h),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 3.h,
          crossAxisSpacing: 3.w,
          childAspectRatio: 1.8,
        ),
        itemCount: members.length,
        itemBuilder: (context, index) {
          final m = members[index];
          final selected = selectedIds.contains(m.id);

          return InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            splashFactory: NoSplash.splashFactory,
            onTap: () => onToggleSelect(m.id),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected
                                ? Colors.greenAccent
                                : Colors.white70,
                            width: selected ? 2 : 1,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 24.r,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: Text(
                            NameUtils.getInitials(m.name),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      if (selected)
                        Positioned(
                          right: -2,
                          bottom: -2,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    width: 120.w,
                    child: Text(
                      m.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
