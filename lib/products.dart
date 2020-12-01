import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  final List<String> product;

  Products(this.product);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: product
          .map(
            (element) => Card(
              child: Column(
                children: [
                  Image.asset(
                    'assets/sweet.jpg',
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Text(element),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
