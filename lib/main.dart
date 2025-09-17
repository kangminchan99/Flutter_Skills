import 'package:flutter/material.dart';
import 'package:flutterskills/features/user/view/login_screen.dart';
import 'package:flutterskills/features/user/view/splash_screen.dart';

void main() {
  runApp(_App());
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'NotoSans'),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
