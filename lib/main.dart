import 'package:flutter/material.dart';

import './pages/product_screen.dart';
import './pages/product_admin_screen.dart';
import './pages/product_details_screen.dart';
import './pages/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Map<String, dynamic>> _product = [];

  void _addProduct(Map<String, dynamic> products) {
    setState(() {
      _product.add(products);
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      _product.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.teal,
        primarySwatch: Colors.indigo,
      ),
      home: AuthScreen(),
      routes: {
        '/product': (BuildContext context) => ProductScreen(_product),
        '/admin': (BuildContext context) => ProductAdminScreen(
              _addProduct,
              _deleteProduct,
            ),
      },
      onGenerateRoute: (RouteSettings settings) {
        final pathElements = settings.name.split('/');
        if (pathElements[0] != '') {
          return null;
        }
        if (pathElements[1] == 'products') {
          final int index = int.parse(pathElements[2]);
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ProductDetailsScreen(
              imageUrl: _product[index]['image'],
              title: _product[index]['title'],
            ),
          );
        }
        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (BuildContext context) => ProductScreen(_product),
        );
      },
    );
  }
}
