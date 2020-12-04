import 'package:flutter/material.dart';

class ProductControl extends StatelessWidget {
  final Function addProduct;
  ProductControl(this.addProduct);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: const Text(
        'Add Product',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      color: Theme.of(context).primaryColor,
      onPressed: () => addProduct({
        'title': 'Sweet Table',
        'image': 'assets/sweet.jpg',
      }),
    );
  }
}
