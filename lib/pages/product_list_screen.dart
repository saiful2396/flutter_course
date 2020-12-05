import 'package:flutter/material.dart';

import 'product_edit_screen.dart';

class ProductListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function updateProduct;

  ProductListScreen(this.products, this.updateProduct);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (ctx, index) => ListTile(
        leading: Image.asset(products[index]['image']),
        title: Text(products[index]['title']),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return ProductEditScreen(
                    product:products[index],
                    updateProduct: updateProduct,
                    prodIndex: index,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
