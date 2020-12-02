import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  final List<String> product;

  Products(this.product);

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: [
          Image.asset(
            'assets/sweet.jpg',
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Text(product[index]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return product.length > 0
        ? ListView.builder(
            itemCount: product.length,
            itemBuilder: _buildProductItem,
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
