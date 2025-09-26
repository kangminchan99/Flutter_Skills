import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskills/common/const/data.dart';
import 'package:flutterskills/common/dio/dio_interceptor.dart';
import 'package:flutterskills/features/user/model/basket_item_model.dart';
import 'package:flutterskills/features/user/model/patch_basket_body.dart';
import 'package:flutterskills/features/user/model/user_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'user_repository.g.dart';

// http://$ip/user/me
@RestApi()
abstract class UserRepository {
  factory UserRepository(Dio dio, {String baseUrl}) = _UserRepository;

  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<UserModel> getMe();

  @GET('/basket')
  @Headers({'accessToken': 'true'})
  Future<List<BasketItemModel>> getBasket();

  @PATCH('/basket')
  @Headers({'accessToken': 'true'})
  Future<List<BasketItemModel>> patchBasket({
    @Body() required PatchBasketBody body,
  });
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return UserRepository(dio, baseUrl: 'http://$ip/user/me');
});
