import 'package:flutter/material.dart';

import './products.dart';

class ProductManager extends StatelessWidget {
  final List<Map<String, dynamic>> product;
  ProductManager(this.product);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Products(product),
        ),
      ],
    );
  }
}
