import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../widgets/products/products.dart';
import '../scope-models/main_model.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EasyLoad'),
        actions: [
          ScopedModelDescendant<MainModel>(
              builder: (context, child, model) {
            return IconButton(
              icon: Icon(
                model.displayFavOnly ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () {
                model.toggleDisplayMode();
              },
            );
          }),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('Choose'),
            ),
            ListTile(
              leading: Icon(Icons.edit),
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
      body: Products(),
    );
  }
}
