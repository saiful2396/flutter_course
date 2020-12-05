import 'package:flutter/material.dart';

import './product_tag.dart';
import './address_tag.dart';
import '../ui_element/title_default.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final int prodIndex;
  ProductCard(this.product, this.prodIndex);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.asset(
            product['image'],
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TitleDefault(product['title']),
                SizedBox(width: 10),
                ProductTag(
                  product['price'].toString(),
                ),
              ],
            ),
          ),
          AddressTag('Simanto Square, Dhaka'),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.info),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  Navigator.pushNamed<bool>(
                    context,
                    '/products/' + prodIndex.toString(),
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
}
