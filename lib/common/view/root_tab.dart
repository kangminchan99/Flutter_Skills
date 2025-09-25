import 'package:flutter/material.dart';
import 'package:flutterskills/common/layout/default_layout.dart';
import 'package:flutterskills/common/styles/app_colors.dart';
import 'package:flutterskills/features/product/view/product_screen.dart';
import 'package:flutterskills/features/restaurant/view/restaurant_screen.dart';
import 'package:flutterskills/features/user/view/profile_screen.dart';

class RootTab extends StatefulWidget {
  static String get routeName => 'home';
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  int index = 0;
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
    controller.addListener(tabListener);
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBarTitle: '코팩 딜리버리',
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.bodyTextColor,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          controller.animateTo(index);
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: '음식',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: '주문',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '프로필',
          ),
        ],
      ),
      child: TabBarView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        children: [
          RestaurantScreen(),
          ProductScreen(),
          Container(child: Text('order')),
          ProfileScreen(),
        ],
      ),
    );
  }
}
