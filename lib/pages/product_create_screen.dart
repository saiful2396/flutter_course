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
    return ListView(
      padding: const EdgeInsets.all(10.0),
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
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
