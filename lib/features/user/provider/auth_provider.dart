import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskills/common/view/root_tab.dart';
import 'package:flutterskills/features/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutterskills/features/user/model/user_model.dart';
import 'package:flutterskills/features/user/provider/user_provider.dart';
import 'package:flutterskills/features/user/view/login_screen.dart';
import 'package:flutterskills/features/user/view/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({required this.ref}) {
    ref.listen<UserModelBase?>(userProvider, (prev, next) {
      if (prev != next) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
    GoRoute(
      path: '/',
      name: RootTab.routeName,
      builder: (context, state) => const RootTab(),
      routes: [
        GoRoute(
          path: 'restaurant/:rid',
          builder: (context, state) =>
              RestaurantDetailScreen(id: state.pathParameters['rid']!),
        ),
      ],
    ),
    GoRoute(
      path: '/splash',
      name: SplashScreen.routeName,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.routeName,
      builder: (context, state) => const LoginScreen(),
    ),
  ];

  // SplashScreen - 앱을 처음 시작했을 때 토큰이 존재하는지 확인하고 로그인 스크린으로 보내줄지 홈 스크린으로 보내줄지 확인하는 과정이 필요
  String? redirectLogic(BuildContext context, GoRouterState state) {
    final UserModelBase? user = ref.read(userProvider);
    final loggingIn = state.matchedLocation == '/login';

    // 유저 정보가 없는데 로그인중이면 그대로 로그인페이지에 두고
    // 만약에 로그인중이 아니라면 로그인페이지로 이동
    if (user == null) {
      // 로그인이 안되어있는 상태
      return loggingIn ? null : '/login';
    }

    // UserModel
    // 사용자 정보가 있는 상태면 로그인 중이거나 현재 위치가 SplashScreen이면 홈으로 이동시킨다.
    if (user is UserModel) {
      return loggingIn || state.matchedLocation == '/splash' ? '/' : null;
    }

    // UserModelError
    if (user is UserModelError) {
      return loggingIn ? null : '/login';
    }

    return null;
  }
}

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});
