import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sende_de_var/core/utils/font_size.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../data/model/members_model.dart';

class AddDutyDialog extends StatefulWidget {
  final List<MembersModel> members;
  final AppColors appColors;

  const AddDutyDialog({
    Key? key,
    required this.members,
    required this.appColors,
  }) : super(key: key);

  @override
  State<AddDutyDialog> createState() => _AddDutyDialogState();
}

class _AddDutyDialogState extends State<AddDutyDialog> {
  final TextEditingController _dutyNameController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();
  final List<String> _tasks = [];
  String? _selectedMemberId;

  void _addTask() {
    if (_taskController.text.trim().isNotEmpty) {
      setState(() {
        _tasks.add(_taskController.text.trim());
        _taskController.clear();
      });
    }
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
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
                height: 580.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
                      child: Text(
                        "Görev Ekle",
                        style: TextStyle(
                          fontSize: AppFontSizes.s24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildTextField(_dutyNameController, "Görev Adı"),
                          SizedBox(height: 15.h),
                          _buildMemberDropdown(),
                          SizedBox(height: 15.h),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(
                              "Görev Maddeleri",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppFontSizes.s14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          _buildTaskInput(),
                          SizedBox(height: 10.h),
                          _buildTaskList(),
                          SizedBox(height: 20.h),
                          _buildAddButton(context),
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

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      width: 300.w,
      height: 50.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 20.r),
        child: TextField(
          style: const TextStyle(color: Colors.white),
          controller: controller,
          decoration: InputDecoration(
            hintStyle: const TextStyle(color: Colors.white70),
            border: InputBorder.none,
            hintText: hint,
          ),
        ),
      ),
    );
  }

  Widget _buildMemberDropdown() {
    return Container(
      width: 300.w,
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedMemberId,
          hint: const Text("Üye Seç", style: TextStyle(color: Colors.white70)),
          dropdownColor: Colors.black87,
          style: const TextStyle(color: Colors.white),
          isExpanded: true,
          items: widget.members.map((m) {
            return DropdownMenuItem(
              value: m.id,
              child: Text(m.name),
            );
          }).toList(),
          onChanged: (val) => setState(() => _selectedMemberId = val),
        ),
      ),
    );
  }

  Widget _buildTaskInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 240.w,
          height: 50.h,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 20.r),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              controller: _taskController,
              decoration: const InputDecoration(
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
                hintText: "Görev maddesi",
              ),
              onSubmitted: (_) => _addTask(),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        InkWell(
          onTap: _addTask,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.greenAccent.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.greenAccent, size: 28),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskList() {
    return Container(
      width: 300.w,
      height: 150.h,
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
      ),
      child: _tasks.isEmpty
          ? const Center(
              child: Text(
                "Henüz görev maddesi eklenmedi",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            )
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${index + 1}. ${_tasks[index]}",
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                      InkWell(
                        onTap: () => _removeTask(index),
                        child: const Icon(Icons.close, color: Colors.redAccent, size: 18),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
      onTap: () {
        if (_dutyNameController.text.trim().isEmpty ||
            _selectedMemberId == null ||
            _tasks.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Lütfen tüm alanları doldurun"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        Navigator.of(context).pop({
          'name': _dutyNameController.text.trim(),
          'assignedTo': _selectedMemberId!,
          'tasks': _tasks,
        });
      },
      child: Container(
        width: 80,
        height: 40,
        decoration: BoxDecoration(
          color: widget.appColors.channelsPage.addButtonIconBgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            "Ekle",
            style: TextStyle(
              color: widget.appColors.channelsPage.addButtonIconColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dutyNameController.dispose();
    _taskController.dispose();
    super.dispose();
  }
}
