import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskills/common/const/data.dart';
import 'package:flutterskills/common/dio/dio_interceptor.dart';
import 'package:flutterskills/common/model/login_response.dart';
import 'package:flutterskills/common/model/token_response.dart';
import 'package:flutterskills/common/utils/data_utils.dart';

class AuthRepository {
  // http://$ip/auth
  final String baseUrl;
  final Dio dio;
  AuthRepository({required this.baseUrl, required this.dio});

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    final serialized = DataUtils.plainToBase64('$username:$password');

    final response = await dio.post(
      '$baseUrl/login',
      options: Options(headers: {'authorization': 'Basic $serialized'}),
    );

    return LoginResponse.fromJson(response.data);
  }

  Future<TokenResponse> getToken() async {
    final response = await dio.post(
      '$baseUrl/token',
      options: Options(headers: {'refreshToken': 'true'}),
    );

    return TokenResponse.fromJson(response.data);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return AuthRepository(dio: dio, baseUrl: 'http://$ip/auth');
});
