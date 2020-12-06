import 'package:flutter/material.dart';

import 'product_edit_screen.dart';

class ProductListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function updateProduct;
  final Function deleteProduct;

  ProductListScreen(
    this.products,
    this.updateProduct,
    this.deleteProduct,
  );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: Key(products[index]['title']),
        background: Container(
          color: Colors.red,
        ),
        onDismissed:(DismissDirection direction) {
          if(direction == DismissDirection.endToStart){
            deleteProduct(index);
          }else{
            print('Other');
          }
        },
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                  backgroundImage: AssetImage(products[index]['image'])),
              title: Text(products[index]['title']),
              subtitle: Text('\$${products[index]['price'].toString()}'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return ProductEditScreen(
                          product: products[index],
                          updateProduct: updateProduct,
                          prodIndex: index,
                        );
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
  }
}
