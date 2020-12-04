import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  final List<Map<String, String>> product;
  final Function deleteProduct;

  Products(this.product, {this.deleteProduct});

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: [
          Image.asset(
            product[index]['image'],
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Text(product[index]['title']),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text('Product Details'),
                onPressed: () {
                  Navigator.pushNamed<bool>(
                    context,
                    '/products/' + index.toString(),
                  ).then((bool value) {
                    if (value) {
                      deleteProduct(index);
                    }
                  });
                },
              ),
            ],
          )
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
