import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/themes/app_colors.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_textfield.dart';
import '../widgets/title_text.dart';
import '../../../auth/logic/cubit/user_cubit.dart';
import '../../../auth/logic/cubit/user_state.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors(isDarkMode: false);
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state.isSignIn) {
          final snackBar = SnackBar(
            content: const Text("Kayıt başarılı!"),
            duration: const Duration(seconds: 2),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((_) {
            Navigator.pushReplacementNamed(context, Routes.login);
          });
        } else if (state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      child: Scaffold(
        backgroundColor: appColors.authPage.pageBgColor,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthHeader(
                    appColors: appColors,
                    subtitle: "Yeni bir hesap oluştur",
                  ),
                  SizedBox(height: 30.h),
                  TitleText(appColors: appColors, titleText: "Ad-Soyad"),
                  SizedBox(height: 5),
                  AuthTextfield(
                    appColors: appColors,
                    hintText: "Ex: Levent Aslan",
                    controller: nameController,
                    isPassword: false,
                    prefixIcon: Icons.person_outline,
                  ),
                  SizedBox(height: 20),
                  TitleText(appColors: appColors, titleText: "E-mail"),
                  SizedBox(height: 5),
                  AuthTextfield(
                    appColors: appColors,
                    hintText: "Ex: example@gmail.com",
                    controller: emailController,
                    isPassword: false,
                    prefixIcon: Icons.email_outlined,
                  ),
                  SizedBox(height: 20),
                  TitleText(appColors: appColors, titleText: "Şifre"),
                  SizedBox(height: 5),
                  AuthTextfield(
                    appColors: appColors,
                    hintText: "Ex: !dkKOWsŞ548.Ç54",
                    controller: passwordController,
                    isPassword: true,
                    prefixIcon: Icons.lock_outline,
                  ),
                  SizedBox(height: 40),
                  AuthButton(
                appColors: appColors,
                buttonText: "Kayıt ol",
                onTap: () {
                  final nameSurname = nameController.text.trim();
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();

                  if (nameSurname.isEmpty ||
                      email.isEmpty ||
                      password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Lütfen tüm alanları doldurun."),
                      ),
                    );
                    return;
                  }

                  final parts = nameSurname.split(" ");
                  final name = parts.isNotEmpty ? parts.first : "";
                  final surname = parts.length > 1
                      ? parts.sublist(1).join(" ")
                      : "";

                  context.read<UserCubit>().signUp(
                    name: name,
                    surname: surname,
                    email: email,
                    password: password,
                  );
                },
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
            Positioned(
              top: 16.h,
              left: 12.w,
              child: SafeArea(
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: appColors.authPage.textColor,
                    size: 20.r,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
