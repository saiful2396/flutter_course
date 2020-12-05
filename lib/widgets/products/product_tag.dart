import 'package:flutter/material.dart';

class ProductTag extends StatelessWidget {
  final String price;
  ProductTag(this.price);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6.0,
        vertical: 2.5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Theme.of(context).accentColor,
      ),
      child: Text(
        '\$$price',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
