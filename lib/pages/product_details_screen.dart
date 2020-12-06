import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/ui_element/title_default.dart';
import '../scope-models/products_model.dart';

class ProductDetailsScreen extends StatelessWidget {
  final int prodIndex;

  ProductDetailsScreen({this.prodIndex});

  /*_showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('This action cann\'t be undone'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('DISCARD'),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true);
            },
            child: Text('CONTINUE'),
          ),
        ],
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print('BackButton Pressed');
        Navigator.pop(context, false);
        return Future.value(true);
      },
      child: ScopedModelDescendant<ProductsModel>(
        builder: (BuildContext context, Widget child, ProductsModel model) {
          return Scaffold(
            appBar: AppBar(
              title: Text(model.products[prodIndex].title),
            ),
            body: Column(
              children: [
                Image.asset(
                  model.products[prodIndex].image,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TitleDefault(model.products[prodIndex].title),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Simanto Square, Dhaka',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        '|',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Text(
                      model.products[prodIndex].price.toString(),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(model.products[prodIndex].description),
                /*Container(
              padding: EdgeInsets.all(10.0),
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: () => _showDialog(context),
                child: Text('DELETE'),
              ),
            ),*/
              ],
            ),
          );
        },
      ),
    );
  }
}
