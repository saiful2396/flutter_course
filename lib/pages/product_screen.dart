import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../widgets/products/products.dart';
import '../widgets/ui_element/logout_list_tile.dart';
import '../scope-models/main_model.dart';

class ProductScreen extends StatefulWidget {
  final MainModel model;

  ProductScreen(this.model);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    widget.model.fetchData();
    super.initState();
  }

  Widget _buildProductBody() {
    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      Widget content = Center(
        child: Text('No product found, please add some!'),
      );
      if (model.displayedProducts.length > 0 && !model.isLoading) {
        content = Products();
      } else if (model.isLoading) {
        content = Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: model.fetchData,
        color: Theme.of(context).primaryColor,
        child: content,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EasyLoad'),
        actions: [
          ScopedModelDescendant<MainModel>(builder: (context, child, model) {
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
            Divider(),
            LogoutListTile(),
          ],
        ),
      ),
      body: _buildProductBody(),
    );
  }
}
