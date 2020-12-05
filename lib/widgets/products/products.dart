import 'package:flutter/material.dart';

import './product_tag.dart';

class Products extends StatelessWidget {
  final List<Map<String, dynamic>> product;
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
          Container(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  product[index]['title'],
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato',
                  ),
                ),
                SizedBox(width: 10),
                ProductTag(
                  product[index]['price'].toString(),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6.0,
              vertical: 2.5,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text('Simanto Square, Dhaka'),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.info),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  Navigator.pushNamed<bool>(
                    context,
                    '/products/' + index.toString(),
                  );
                  /*.then((bool value) {
                    if (value) {
                      deleteProduct(index);
                    }
                  });*/
                },
              ),
              IconButton(
                icon: Icon(Icons.favorite_border),
                color: Theme.of(context).accentColor,
                onPressed: () {},
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
