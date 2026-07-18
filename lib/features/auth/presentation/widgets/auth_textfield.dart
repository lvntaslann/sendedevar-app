import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/themes/app_colors.dart';

class AuthTextfield extends StatefulWidget {
  const AuthTextfield({
    super.key,
    required this.appColors,
    required this.hintText,
    required this.controller,
    required this.isPassword,
    this.prefixIcon,
  });

  final AppColors appColors;
  final String hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final IconData? prefixIcon;

  @override
  State<AuthTextfield> createState() => _AuthTextfieldState();
}

class _AuthTextfieldState extends State<AuthTextfield> {
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
  }

  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final appColors = widget.appColors;
    const accent = Color(0xFF22C55E);

    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 320.w,
        height: 58.h,
        decoration: BoxDecoration(
          color: const Color(0xFF16301F),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: _focused
                ? accent
                : appColors.authPage.containerColor.withOpacity(0.35),
            width: _focused ? 1.4 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: (_focused ? accent : appColors.authPage.containerShadowColor)
                  .withOpacity(_focused ? 0.18 : 0.12),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Focus(
          onFocusChange: (value) => setState(() => _focused = value),
          child: TextField(
            controller: widget.controller,
            cursorColor: accent,
            style: TextStyle(
              color: appColors.authPage.textColor,
              fontWeight: FontWeight.w500,
            ),
            obscureText: _obscure,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: appColors.authPage.textColor.withOpacity(0.4),
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 6.w),
                      child: Container(
                        width: 34.r,
                        height: 34.r,
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          widget.prefixIcon,
                          color: accent,
                          size: 18.r,
                        ),
                      ),
                    )
                  : null,
              prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: appColors.authPage.textColor.withOpacity(0.6),
                        size: 20.r,
                      ),
                    )
                  : null,
              filled: false,
              contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}