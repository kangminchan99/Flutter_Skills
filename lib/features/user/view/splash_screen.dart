import 'package:flutter/material.dart';
import 'package:flutterskills/common/const/data.dart';
import 'package:flutterskills/common/layout/default_layout.dart';
import 'package:flutterskills/common/styles/app_colors.dart';
import 'package:flutterskills/common/view/root_tab.dart';
import 'package:flutterskills/features/user/view/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkToken();
  }

  Future<void> checkToken() async {
    final accessToken = await storage.read(key: accessTokenKey);
    final refreshToken = await storage.read(key: refreshTokenKey);

    if (refreshToken == null || accessToken == null) {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    } else {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => RootTab()),
        (route) => false,
      );
    }
  }

  Future<void> deleteToken() async {
    await storage.deleteAll();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: AppColors.primaryColor,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/logo/logo.png',
              width: MediaQuery.of(context).size.width / 2,
            ),
            SizedBox(height: 16),
            CircularProgressIndicator.adaptive(backgroundColor: Colors.black),
          ],
        ),
      ),
    );
  }
}
