import 'package:flutter/material.dart';

import './product_control.dart';
import './products.dart';

class ProductManager extends StatelessWidget {
  final List<Map<String, String>> product;
  final Function addProduct;
  final Function deleteProduct;
  ProductManager(this.product, this.addProduct, this.deleteProduct);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10.0),
          child: ProductControl(addProduct),
        ),
        Expanded(
          child: Products(product, deleteProduct:deleteProduct),
        ),
      ],
    );
  }
}
