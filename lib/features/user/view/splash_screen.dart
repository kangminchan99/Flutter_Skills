import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskills/common/layout/default_layout.dart';
import 'package:flutterskills/common/styles/app_colors.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  static String get routeName => 'splash';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
