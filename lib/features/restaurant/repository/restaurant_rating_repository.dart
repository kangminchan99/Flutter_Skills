import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskills/common/const/data.dart';
import 'package:flutterskills/common/dio/dio_interceptor.dart';
import 'package:flutterskills/common/model/cursor_pagination_model.dart';
import 'package:flutterskills/common/model/pagination_params.dart';
import 'package:flutterskills/common/repository/base_pagination.dart';
import 'package:flutterskills/features/rating/model/rating_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'restaurant_rating_repository.g.dart';

// http://$ip/restaurant/:rid/rating
@RestApi()
abstract class RestaurantRatingRepository
    implements IBasePaginationRepository<RatingModel> {
  factory RestaurantRatingRepository(Dio dio, {String baseUrl}) =
      _RestaurantRatingRepository;

  @override
  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<CursorPaginationModel<RatingModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });
}

final restaurantRatingRepositoryProvider =
    Provider.family<RestaurantRatingRepository, String>((ref, rid) {
      final dio = ref.watch(dioProvider);

      return RestaurantRatingRepository(
        dio,
        baseUrl: 'http://$ip/restaurant/$rid/rating',
      );
    });
