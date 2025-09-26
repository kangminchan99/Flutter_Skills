import 'package:flutter/material.dart';

// 모든 뷰에 공통적으로 변경될 사항이 있을 경우 여기서 변경해주면 된다
class DefaultLayout extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final String? appBarTitle;
  final Widget? bottomNavigationBar;
  final Widget? floactingActionButton;
  const DefaultLayout({
    super.key,
    required this.child,
    this.backgroundColor,
    this.appBarTitle,
    this.bottomNavigationBar,
    this.floactingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: renderAppBar(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floactingActionButton,
    );
  }

  AppBar? renderAppBar() {
    if (appBarTitle == null) {
      return null;
    }
    return AppBar(
      title: Text(
        appBarTitle!,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }
}
