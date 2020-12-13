import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './pages/product_screen.dart';
import './pages/product_admin_screen.dart';
import './pages/product_details_screen.dart';
import './pages/auth_screen.dart';
import './scope-models/main_model.dart';
import './models/product.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();

  @override
  void initState() {
    _model.autoLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.teal,
          primarySwatch: Colors.indigo,
          buttonColor: Colors.indigo,
          //fontFamily: 'Oswald',
        ),
        routes: {
          '/': (BuildContext context) =>
              _model.user == null ? AuthScreen() : ProductScreen(_model),
          '/product': (BuildContext context) => ProductScreen(_model),
          '/admin': (BuildContext context) => ProductAdminScreen(_model),
        },
        onGenerateRoute: (RouteSettings settings) {
          final pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'products') {
            final String productId = pathElements[2];
            final Product product =
                _model.allProducts.firstWhere((Product product) {
              return product.id == productId;
            });
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => ProductDetailsScreen(product),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) => ProductScreen(_model),
          );
        },
      ),
    );
  }
}
