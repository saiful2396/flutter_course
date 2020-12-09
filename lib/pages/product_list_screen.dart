import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './product_edit_screen.dart';
import '../scope-models/main_model.dart';

class ProductListScreen extends StatefulWidget {
  final MainModel model;

  ProductListScreen(this.model);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    widget.model.fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return model.allProducts.isEmpty
          ? Center(
              child: Container(
                child: Text(
                  'Please add some product!...',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            )
          : ListView.builder(
              itemCount: model.allProducts.length,
              itemBuilder: (ctx, index) => Dismissible(
                key: Key(model.allProducts[index].title),
                background: Container(
                  color: Colors.red,
                ),
                onDismissed: (DismissDirection direction) {
                  if (direction == DismissDirection.endToStart) {
                    model.selectProduct(model.allProducts[index].id);
                    model.deleteProduct();
                  } else {
                    print('Other');
                  }
                },
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(model.allProducts[index].image)),
                      title: Text(model.allProducts[index].title),
                      subtitle: Text(
                          '\$${model.allProducts[index].price.toString()}'),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          model.selectProduct(model.allProducts[index].id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) {
                                return ProductEditScreen();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
            );
    });
  }
}
