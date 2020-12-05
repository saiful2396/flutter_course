import 'package:flutter/material.dart';

class ProductCreateScreen extends StatefulWidget {
  final Function addProduct;

  ProductCreateScreen(this.addProduct);

  @override
  _ProductCreateScreenState createState() => _ProductCreateScreenState();
}

class _ProductCreateScreenState extends State<ProductCreateScreen> {
  String _titleValue;
  String _descriptionValue;
  double _priceValue;

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth*0.95;
    final double devicePadding = deviceWidth -targetWidth;
    return Container(
      padding: const EdgeInsets.only(top:15.0),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: devicePadding / 2),
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Title',
            ),
            onChanged: (String val) {
              setState(() {
                _titleValue = val;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Description',
            ),
            maxLines: 4,
            onChanged: (String val) {
              setState(() {
                _descriptionValue = val;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Price',
            ),
            keyboardType: TextInputType.number,
            onChanged: (String val) {
              setState(() {
                _priceValue = double.parse(val);
              });
            },
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            alignment: Alignment.bottomRight,
            child: RaisedButton(
              onPressed: () {
                final Map<String, dynamic> product = {
                  'title': _titleValue,
                  'description': _descriptionValue,
                  'price': _priceValue,
                  'image':'assets/sweet.jpg',
                };
                widget.addProduct(product);
                Navigator.pushReplacementNamed(context, '/product');
              },
              child: Text('Save', textScaleFactor: 1.5,),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
