import 'package:flutter/material.dart';

import '../product_manager.dart';

class ProductScreen extends StatelessWidget {
  final List<Map<String, String>> products;
  final Function addProduct;
  final Function deleteProduct;
  ProductScreen(this.products, this.addProduct, this.deleteProduct);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EasyLoad'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('Choose'),
            ),
            ListTile(
              title: Text('Manage Product'),
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/admin',
                );
              },
            ),
          ],
        ),
      ),
      body: ProductManager(products, addProduct, deleteProduct),
    );
  }
}
