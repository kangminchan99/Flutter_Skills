import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskills/common/model/cursor_pagination_model.dart';
import 'package:flutterskills/common/provider/pagination_provider.dart';
import 'package:flutterskills/features/product/model/product_model.dart';
import 'package:flutterskills/features/product/repository/product_repository.dart';

class ProductStateNotifier
    extends PaginationProvider<ProductModel, ProductRepository> {
  ProductStateNotifier({required super.repository});
}

final productProvider =
    StateNotifierProvider<ProductStateNotifier, CursorPaginationBase>((ref) {
      final repository = ref.watch(productRepositoryProvider);
      return ProductStateNotifier(repository: repository);
    });
