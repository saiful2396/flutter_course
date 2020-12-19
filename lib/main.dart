import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:lee_map_view/map_view.dart';

import './pages/product_screen.dart';
import './pages/product_admin_screen.dart';
import './pages/product_details_screen.dart';
import './pages/auth_screen.dart';
import './scope-models/main_model.dart';
import './models/product.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MapView.setApiKey('AIzaSyDnIZj5SxU8Zo87f54s0gLS7bSLt9me3X4');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.autoLogin();
    _model.userSubject.listen((  isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('build Main page');
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
              !_isAuthenticated ? AuthScreen() : ProductScreen(_model),
          '/admin': (BuildContext context) =>
              !_isAuthenticated ? AuthScreen() : ProductAdminScreen(_model),
        },
        onGenerateRoute: (RouteSettings settings) {
          if (!_isAuthenticated) {
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => AuthScreen(),
            );
          }
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
              builder: (BuildContext context) => !_isAuthenticated
                  ? AuthScreen()
                  : ProductDetailsScreen(product),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) =>
                !_isAuthenticated ? AuthScreen() : ProductScreen(_model),
          );
        },
      ),
    );
  }
}
