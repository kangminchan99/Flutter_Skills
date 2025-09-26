import 'package:flutter/material.dart';
import 'package:flutterskills/common/layout/default_layout.dart';
import 'package:flutterskills/common/styles/app_colors.dart';
import 'package:flutterskills/common/view/root_tab.dart';
import 'package:go_router/go_router.dart';

class OrderDoneScreen extends StatelessWidget {
  static String get routeName => 'orderDone';
  const OrderDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.thumb_up_alt_outlined,
              color: AppColors.primaryColor,
              size: 50.0,
            ),
            SizedBox(height: 32.0),
            Text(
              '주문이 완료되었습니다!',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                context.goNamed(RootTab.routeName);
              },
              child: Text('홈으로', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
