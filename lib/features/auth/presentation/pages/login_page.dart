import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunnet_app/features/auth/presentation/widgets/dont_have_account.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/themes/app_colors.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_textfield.dart';
import '../widgets/title_text.dart';
import '../../../auth/logic/cubit/user_cubit.dart';
import '../../../auth/logic/cubit/user_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final appColors = AppColors(isDarkMode: false);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isRememberMe = false;
  bool isCheckingAuth =
      true; // --- YENİ EKLENDİ: Arka planda kontrol yapıldığını tutar ---

  @override
  void initState() {
    super.initState();
    _loadSavedCredentialsAndAutoLogin();
  }

  Future<void> _loadSavedCredentialsAndAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('remember_me') ?? false;

    if (rememberMe) {
      final savedEmail = prefs.getString('saved_email') ?? '';
      final savedPassword = prefs.getString('saved_password') ?? '';

      if (savedEmail.isNotEmpty && savedPassword.isNotEmpty) {
        setState(() {
          isRememberMe = true;
          emailController.text = savedEmail;
          passwordController.text = savedPassword;
          // isCheckingAuth'u true bırakıyoruz ki form ekranda GÖZÜKMESİN.
        });

        if (mounted) {
          context.read<UserCubit>().signIn(savedEmail, savedPassword);
        }
        return; // İşlemi bitir, BlocListener sayfa geçişini halledecek
      }
    }

    // Eğer beni hatırla yoksa veya bilgiler boşsa formu göster
    if (mounted) {
      setState(() {
        isCheckingAuth = false;
      });
    }
  }

  Future<void> _saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (isRememberMe) {
      await prefs.setString('saved_email', email);
      await prefs.setString('saved_password', password);
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('saved_email');
      await prefs.remove('saved_password');
      await prefs.setBool('remember_me', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state.isAuthenticated) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Giriş başarılı!")));
          Navigator.pushReplacementNamed(context, Routes.main);
        } else if (state.error != null) {
          // Otomatik giriş hata verirse (örn: internet yoksa) formu göster
          setState(() {
            isCheckingAuth = false;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      child: Scaffold(
        backgroundColor: appColors.authPage.pageBgColor,
        // --- EĞER KONTROL EDİLİYORSA SADECE LOGO GÖSTER, DEĞİLSE FORMU GÖSTER ---
        body: isCheckingAuth
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/auth/authpage-icon.png", width: 150),
                    SizedBox(height: 20),
                    CircularProgressIndicator(
                      color: Colors.blue[800],
                    ), // İsteğe bağlı yükleniyor ikonu
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 100),
                    Center(child: Image.asset("assets/auth/authpage-icon.png")),
                    SizedBox(height: 20),

                    TitleText(appColors: appColors, titleText: "E-mail"),
                    SizedBox(height: 5),
                    AuthTextfield(
                      appColors: appColors,
                      hintText: "Ex: example@gmail.com",
                      controller: emailController,
                      isPassword: false,
                    ),

                    SizedBox(height: 20),

                    TitleText(appColors: appColors, titleText: "Şifre"),
                    SizedBox(height: 5),
                    AuthTextfield(
                      appColors: appColors,
                      hintText: "Ex: !dkKOWsŞ548.Ç54",
                      controller: passwordController,
                      isPassword: true,
                    ),

                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: isRememberMe,
                              onChanged: (value) {
                                setState(() {
                                  isRememberMe = value ?? false;
                                });
                              },
                              activeColor: Colors.blue[800],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Beni Hatırla",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 36),

                    AuthButton(
                      appColors: appColors,
                      buttonText: "Giriş Yap",
                      onTap: () {
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Lütfen tüm alanları doldurun."),
                            ),
                          );
                          return;
                        }

                        // Giriş yapılınca loading ekranına geç
                        setState(() {
                          isCheckingAuth = true;
                        });

                        _saveCredentials(email, password);

                        context.read<UserCubit>().signIn(email, password);
                        final data = context.read<UserCubit>().loadUserData();
                        debugPrint(data.toString());
                      },
                    ),

                    SizedBox(height: 30),
                    DontHaveAccount(appColors: appColors),

                    SizedBox(height: 15),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, Routes.main);
                        },
                        child: Text(
                          "Üye Olmadan Devam Et",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }
}
