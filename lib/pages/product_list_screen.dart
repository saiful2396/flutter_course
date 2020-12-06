import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './product_edit_screen.dart';
import '../scope-models/products_model.dart';

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductsModel>(
        builder: (BuildContext context, Widget child, ProductsModel model) {
      return model.products.isEmpty
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
              itemCount: model.products.length,
              itemBuilder: (ctx, index) => Dismissible(
                key: Key(model.products[index].title),
                background: Container(
                  color: Colors.red,
                ),
                onDismissed: (DismissDirection direction) {
                  if (direction == DismissDirection.endToStart) {
                    model.selectedProduct;
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
                              AssetImage(model.products[index].image)),
                      title: Text(model.products[index].title),
                      subtitle:
                          Text('\$${model.products[index].price.toString()}'),
                      trailing: ScopedModelDescendant<ProductsModel>(
                        builder: (BuildContext context, Widget child,
                            ProductsModel model) {
                          return IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              model.selectProduct(index);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return ProductEditScreen();
                                  },
                                ),
                              );
                            },
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
