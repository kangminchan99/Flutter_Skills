import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterskills/common/const/data.dart';
import 'package:flutterskills/common/secure_storage/secure_storage.dart';
import 'package:flutterskills/features/user/model/user_model.dart';
import 'package:flutterskills/features/user/repository/auth_repository.dart';
import 'package:flutterskills/features/user/repository/user_repository.dart';

class UserStateNotifier extends StateNotifier<UserModelBase?> {
  final UserRepository userRepository;
  final AuthRepository authRepository;
  final FlutterSecureStorage storage;

  UserStateNotifier({
    required this.userRepository,
    required this.authRepository,
    required this.storage,
  }) : super(UserModelLoading()) {
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

    final response = await userRepository.getMe();

    state = response;
  }

  Future<UserModelBase> login({
    required String username,
    required String password,
  }) async {
    try {
      state = UserModelLoading();

      final response = await authRepository.login(
        username: username,
        password: password,
      );

      await storage.write(key: accessTokenKey, value: response.accessToken);
      await storage.write(key: refreshTokenKey, value: response.refreshToken);

      final userResponse = await userRepository.getMe();

      state = userResponse;

      return userResponse;
    } catch (e) {
      state = UserModelError(errorMsg: '로그인에 실패했습니다 $e');

      return Future.value(state);
    }
  }

  logout() async {
    state = null;

    // 작업이 모두 끝나야 다음으로 넘어감
    await Future.wait([
      storage.delete(key: accessTokenKey),
      storage.delete(key: refreshTokenKey),
    ]);
  }
}

final userProvider = StateNotifierProvider<UserStateNotifier, UserModelBase?>((
  ref,
) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);

  return UserStateNotifier(
    userRepository: userRepository,
    authRepository: authRepository,
    storage: storage,
  );
});
