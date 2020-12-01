import 'package:flutter/material.dart';

import './product_control.dart';
import './products.dart';

class ProductManager extends StatefulWidget {

  final String startingProduct;
  ProductManager(this.startingProduct);

  @override
  _ProductManagerState createState() => _ProductManagerState();
}

class _ProductManagerState extends State<ProductManager> {

  List<String> _product = [];

  @override
  void initState() {
    _product.add(widget.startingProduct);
    super.initState();
  }

  void _addProduct(String products){
    setState(() {
      _product.add(products);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10.0),
          child: ProductControl(_addProduct),
        ),
        Products(_product),
      ],
    );
  }
}
