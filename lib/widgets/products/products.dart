import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './product_card.dart';
import '../../models/product.dart';
import '../../scope-models/main_model.dart';

class Products extends StatelessWidget {
  Widget _buildProductList(List<Product> product) {
    return ListView.builder(
      itemCount: product.length,
      itemBuilder: (BuildContext context, int index) =>
          ProductCard(product[index], index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return _buildProductList(model.displayedProducts);
    });
  }
}
