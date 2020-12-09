import 'package:flutter/material.dart';

import '../widgets/ui_element/title_default.dart';
import '../models/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  ProductDetailsScreen(this.product);

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
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.title),
        ),
        body: Column(
          children: [
            FadeInImage(
              image: NetworkImage(product.image),
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: AssetImage('assets/sweet.jpg'),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: TitleDefault(product.title),
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
                  product.price.toString(),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(product.description),
          ],
        ),
      ),
    );
  }
}
