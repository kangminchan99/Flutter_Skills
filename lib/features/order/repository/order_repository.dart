import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskills/common/const/data.dart';
import 'package:flutterskills/common/dio/dio_interceptor.dart';
import 'package:flutterskills/common/model/cursor_pagination_model.dart';
import 'package:flutterskills/common/model/pagination_params.dart';
import 'package:flutterskills/common/repository/base_pagination.dart';
import 'package:flutterskills/features/order/model/order_model.dart';
import 'package:flutterskills/features/order/model/post_order_body.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'order_repository.g.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return OrderRepository(dio, baseUrl: 'http://$ip/order');
});

// http://$ip/order
@RestApi()
abstract class OrderRepository
    implements IBasePaginationRepository<OrderModel> {
  factory OrderRepository(Dio dio, {String baseUrl}) = _OrderRepository;

  @override
  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<CursorPaginationModel<OrderModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  @POST('')
  @Headers({'accessToken': 'true'})
  Future<OrderModel> postOrder({@Body() required PostOrderBody body});
}
