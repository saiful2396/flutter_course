import 'package:flutter/material.dart';

import '../widgets/ui_element/title_default.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double price;
  final String description;

  ProductDetailsScreen({
    this.title,
    this.imageUrl,
    this.price,
    this.description,
  });

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
          title: Text(title),
        ),
        body: Column(
          children: [
            Image.asset(
              imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: TitleDefault(title),
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
                  price.toString(),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(description),
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
      ),
    );
  }
}
