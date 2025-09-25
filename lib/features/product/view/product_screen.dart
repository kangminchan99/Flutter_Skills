import 'package:flutter/material.dart';
import 'package:flutterskills/common/components/pagination_listview.dart';
import 'package:flutterskills/features/product/components/product_card.dart';
import 'package:flutterskills/features/product/model/product_model.dart';
import 'package:flutterskills/features/product/provider/product_provider.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListview<ProductModel>(
      provider: productProvider,
      itemBuilder: <ProductModel>(context, index, model) {
        return ProductCard.fromProductModel(model: model);
      },
    );
  }
}
