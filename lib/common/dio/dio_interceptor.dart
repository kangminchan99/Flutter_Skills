import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterskills/common/const/data.dart';

class DioInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;

  DioInterceptor({required this.secureStorage});

  // 1) 요청을 보낼 때
  // 요청이 보내지기 전에 요청의 header에 accessToken : true일 경우
  // 실제 토큰을 가져와서(secureStorage) 'authorization': 'Bearer $accessToken 으로 헤더를 변경해준다.
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    log('[REQ] [${options.method}] ${options.uri}');
    if (options.headers['accessToken'] == 'true') {
      // 엑세스 토큰 체크용 헤더 삭제
      options.headers.remove('accessToken');

      final accessToken = await secureStorage.read(key: accessTokenKey);

      // 실제 헤더로 교체
      options.headers.addAll({'authorization': 'Bearer $accessToken'});
    }

    if (options.headers['refreshToken'] == 'true') {
      // 엑세스 토큰 체크용 헤더 삭제
      options.headers.remove('refreshToken');

      final refreshToken = await secureStorage.read(key: refreshTokenKey);

      // 실제 헤더로 교체
      options.headers.addAll({'authorization': 'Bearer $refreshToken'});
    }
    // 여기서 보내짐
    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을 때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(
      '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}',
    );

    return super.onResponse(response, handler);
  }

  // 3) 에러가 났을 때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 에러가 났을 때 (status code)
    // 토큰을 재발급 받는 시도를 하고 토큰이 재발급 되면
    // 다시 새로운 토큰으로 요청을한다.
    log('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await secureStorage.read(key: refreshTokenKey);

    // refreshToken이 아예 없으면
    // 에러를 던진다
    if (refreshToken == null) {
      // 에러를 던질때는 handler.reject 사용
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(headers: {'authorization': 'Bearer $refreshToken'}),
        );

        final accessToken = resp.data['accessToken'];

        final options = err.requestOptions;

        // 토큰 변경
        options.headers.addAll({'authorization': 'Bearer $accessToken'});

        // 로컬에서도 토큰 변경
        await secureStorage.write(key: accessTokenKey, value: accessToken);

        // 토큰 변경 후 요청 재전송
        final response = await dio.fetch(options);

        //
        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.reject(e);
      }
    }
    return handler.reject(err);
  }
}
