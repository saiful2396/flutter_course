import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './product_tag.dart';
import './address_tag.dart';
import '../ui_element/title_default.dart';
import '../../models/product.dart';
import '../../scope-models/main_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int prodIndex;

  ProductCard(this.product, this.prodIndex);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Card(
          child: Column(
            children: [
              FadeInImage(
                image: NetworkImage(product.image),
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/sweet.jpg'),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TitleDefault(product.title),
                    SizedBox(width: 10),
                    ProductTag(
                      product.price.toString(),
                    ),
                  ],
                ),
              ),
              AddressTag('Simanto Square, Dhaka'),
              Text(product.userEmail),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.info),
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      Navigator.pushNamed<bool>(
                        context,
                        '/products/' + model.allProducts[prodIndex].id,
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(model.allProducts[prodIndex].isFav
                        ? Icons.favorite
                        : Icons.favorite_border),
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      model.selectProduct(model.allProducts[prodIndex].id);
                      model.toggleFav();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
