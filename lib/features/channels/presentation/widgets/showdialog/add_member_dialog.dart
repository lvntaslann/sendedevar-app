import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sende_de_var/core/utils/font_size.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../../channels/data/model/members_model.dart';
import 'member_selection_grid.dart';
import 'custom_text_field.dart';
import 'dialog_action_button.dart';

class AddChannelDialog extends StatefulWidget {
  final TextEditingController subjectController;
  final List<MembersModel> addableMembers;
  final AppColors appColors;
  const AddChannelDialog({
    Key? key,
    required this.subjectController,
    required this.addableMembers,
    required this.appColors,
  }) : super(key: key);

  @override
  State<AddChannelDialog> createState() => _AddChannelDialogState();
}

class _AddChannelDialogState extends State<AddChannelDialog> {
  

  final Set<String> _selectedIds = {};

  void _toggleSelect(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                width: 500.w,
                height: 520.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Başlık
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 30,
                        left: 30,
                        right: 30,
                      ),
                      child: Text(
                        "Kanal Oluştur",
                        style: TextStyle(
                          fontSize: AppFontSizes.s24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Form Alanları
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextField(
                            controller: widget.subjectController,
                            hint: "Kanal ismi",
                          ),
                          SizedBox(height: 10.h),

                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(
                              "Üye ekle",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppFontSizes.s14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          MemberSelectionGrid(
                            members: widget.addableMembers,
                            selectedIds: _selectedIds,
                            onToggleSelect: _toggleSelect,
                          ),
                          SizedBox(height: 30.h),
                          DialogActionButton(
                            text: "Ekle",
                            appColors: widget.appColors,
                            onTap: () {
                              final selectedMembers = widget.addableMembers
                                  .where((m) => _selectedIds.contains(m.id))
                                  .toList();
                              _selectedIds.clear();
                              Navigator.of(context).pop(selectedMembers);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
