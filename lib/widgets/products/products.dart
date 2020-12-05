import 'package:flutter/material.dart';

import './product_card.dart';

class Products extends StatelessWidget {
  final List<Map<String, dynamic>> product;
  final Function deleteProduct;

  Products(this.product, {this.deleteProduct});

  @override
  Widget build(BuildContext context) {
    return product.length > 0
        ? ListView.builder(
            itemCount: product.length,
            itemBuilder: (BuildContext context, int index) =>
                ProductCard(product[index], index),
          )
        : Center(
            child: Text(
              'No product found, please add some!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }
}
