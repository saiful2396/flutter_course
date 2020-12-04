import 'package:flutter/material.dart';

import './pages/product_screen.dart';
import './pages/product_admin_screen.dart';
import './pages/product_details_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Map<String, String>> _product = [];

  void _addProduct(Map<String, String> products) {
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
      //home: AuthScreen(),
      routes: {
        '/': (BuildContext context) => ProductScreen(
              _product,
              _addProduct,
              _deleteProduct,
            ),
        '/admin': (BuildContext context) => ProductAdminScreen()
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
          builder: (BuildContext context) => ProductScreen(
            _product,
            _addProduct,
            _deleteProduct,
          ),
        );
      },
    );
  }
}
