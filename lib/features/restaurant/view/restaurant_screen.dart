import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterskills/common/const/data.dart';
import 'package:flutterskills/common/dio/dio_interceptor.dart';
import 'package:flutterskills/features/restaurant/components/restaurant_card.dart';
import 'package:flutterskills/features/restaurant/model/restaurant_model.dart';
import 'package:flutterskills/features/restaurant/repository/restaurant_repository.dart';
import 'package:flutterskills/features/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List<RestaurantModel>> paginateRestaurant() async {
    final dio = Dio();

    dio.interceptors.add(DioInterceptor(secureStorage: storage));

    final response = await RestaurantRepository(
      dio,
      baseUrl: 'http://$ip/restaurant',
    ).paginate();

    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: FutureBuilder<List<RestaurantModel>>(
        future: paginateRestaurant(),
        builder: (context, AsyncSnapshot<List<RestaurantModel>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator.adaptive());
          }

          return ListView.separated(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final pItem = snapshot.data![index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RestaurantDetailScreen(id: pItem.id),
                    ),
                  );
                },
                child: RestaurantCard.fromModel(model: pItem),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 16);
            },
          );
        },
      ),
    );
  }
}
