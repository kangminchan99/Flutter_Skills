import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterskills/common/const/data.dart';
import 'package:flutterskills/features/user/model/user_model.dart';
import 'package:flutterskills/features/user/repository/user_repository.dart';

class UserStateNotifier extends StateNotifier<UserModelBase?> {
  final UserRepository repository;
  final FlutterSecureStorage storage;

  UserStateNotifier({required this.repository, required this.storage})
    : super(UserModelLoading()) {
    // 내 정보 가져오기
    getMe();
  }

  getMe() async {
    final accessToken = await storage.read(key: accessTokenKey);
    final refreshToken = await storage.read(key: refreshTokenKey);

    if (accessToken == null || refreshToken == null) {
      state = null;
      return;
    }

    final response = await repository.getMe();

    state = response;
  }
}
