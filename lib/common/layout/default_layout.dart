import 'package:flutter/material.dart';

// 모든 뷰에 공통적으로 변경될 사항이 있을 경우 여기서 변경해주면 된다
class DefaultLayout extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  const DefaultLayout({super.key, required this.child, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      body: child,
    );
  }
}
