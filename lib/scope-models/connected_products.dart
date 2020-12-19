import 'dart:async';
import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';

import '../models/product.dart';
import '../models/user.dart';
import '../models/auth.dart';
import '../models/location_data.dart';

class ConnectedProductsModel extends Model {
  List<Product> _products = [];
  User _authUser;
  String _selProdId;
  bool _isLoading = false;
}

class ProductsModel extends ConnectedProductsModel {
  bool _showFav = false;

  List<Product> get allProducts => List.from(_products);

  List<Product> get displayedProducts {
    if (_showFav) {
      return _products.where((Product product) => product.isFav).toList();
    }
    return List.from(_products);
  }

  String get selectedProdId => _selProdId;

  int get selectedProdIndex {
    return _products.indexWhere((Product product) {
      return product.id == _selProdId;
    });
  }

  Product get selectedProduct {
    if (selectedProdId == null) {
      return null;
    }
    return _products.firstWhere((Product product) {
      return product.id == _selProdId;
    });
  }

  bool get displayFavOnly => _showFav;

  Future<Null> fetchData({onlyForUser = false}) async {
    _isLoading = true;
    try {
      final http.Response response = await http.get(
          'https://flutter-course-c2450-default-rtdb.firebaseio.com/products.json?auth=${_authUser.token}');
      //print(json.decode(response.body));
      final List<Product> fetchProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      productListData.forEach((String prodId, dynamic prodData) {
        final Product product = Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            image: prodData['image'],
            price: prodData['price'],
            location: LocationData(
              address: prodData['loc-address'],
              latitude: prodData['loc-lat'],
              longitude: prodData['loc-lng'],
            ),
            userEmail: prodData['userEmail'],
            userId: prodData['userId'],
            isFav: prodData['wishListUser'] == null
                ? false
                : (prodData['wishListUser'] as Map<String, dynamic>)
                    .containsKey(_authUser.id));
        fetchProductList.add(product);
      });
      _products = onlyForUser
          ? fetchProductList.where((Product product) {
              return product.userId == _authUser.id;
            }).toList()
          : fetchProductList;
      _isLoading = false;
      notifyListeners();
      _selProdId = null;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return;
    }
  }

  Future<bool> addProduct(String title, String description, String image,
      double price, LocationData locData) async {
    _isLoading = true;
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          'https://cdn.pixabay.com/photo/2017/01/04/19/41/caramel-1952997_960_720.jpg',
      'price': price,
      'userEmail': _authUser.email,
      'userId': _authUser.id,
      'loc-lat': locData.latitude,
      'loc-lng': locData.longitude,
      'loc-address': locData.address,
    };
    try {
      final http.Response response = await http.post(
        'https://flutter-course-c2450-default-rtdb.firebaseio.com/products.json?auth=${_authUser.token}',
        body: json.encode(productData),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      //print(responseData);
      final Product newProduct = Product(
        id: responseData['name'],
        title: title,
        description: description,
        image: image,
        price: price,
        location: locData,
        userEmail: _authUser.email,
        userId: _authUser.id,
      );
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(
      String title, String description, String image, double price, LocationData locData) async {
    _isLoading = true;
    try {
      final Map<String, dynamic> updateData = {
        'title': title,
        'description': description,
        'image':
            'https://cdn.pixabay.com/photo/2017/01/04/19/41/caramel-1952997_960_720.jpg',
        'price': price,
        'userEmail': selectedProduct.userEmail,
        'userId': selectedProduct.userId,
        'loc-lat': locData.latitude,
        'loc-lng': locData.longitude,
        'loc-address': locData.address,
      };
      await http.put(
          'https://flutter-course-c2450-default-rtdb.firebaseio.com/products/${selectedProduct.id}.json?auth=${_authUser.token}',
          body: json.encode(updateData));
      final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: title,
        description: description,
        image: image,
        price: price,
        location: locData,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
      );
      _products[selectedProdIndex] = updatedProduct;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct() async {
    _isLoading = true;
    final deletedProdId = selectedProduct.id;
    _products.removeAt(selectedProdIndex);
    _selProdId = null;
    try {
      await http.delete(
          'https://flutter-course-c2450-default-rtdb.firebaseio.com/products/${deletedProdId}.json?auth=${_authUser.token}');

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void toggleFav() async {
    final bool isCurrentlyFav = selectedProduct.isFav;
    final bool isFavorite = !isCurrentlyFav;
    final Product updateProduct = Product(
      id: selectedProduct.id,
      title: selectedProduct.title,
      description: selectedProduct.description,
      image: selectedProduct.image,
      price: selectedProduct.price,
      location: selectedProduct.location,
      userEmail: selectedProduct.userEmail,
      userId: selectedProduct.userId,
      isFav: isFavorite,
    );
    _products[selectedProdIndex] = updateProduct;
    notifyListeners();
    http.Response response;
    if (isFavorite) {
      response = await http.put(
        'https://flutter-course-c2450-default-rtdb.firebaseio.com/products/${selectedProduct.id}/wishListUser/${_authUser.id}.json?auth=${_authUser.token}',
        body: json.encode(true),
      );
    } else {
      response = await http.delete(
          'https://flutter-course-c2450-default-rtdb.firebaseio.com/products/${selectedProduct.id}/wishListUser/${_authUser.id}.json?auth=${_authUser.token}');
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      final Product updateProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        image: selectedProduct.image,
        price: selectedProduct.price,
        location: selectedProduct.location,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFav: !isFavorite,
      );
      _products[selectedProdIndex] = updateProduct;
      notifyListeners();
    }
  }

  void selectProduct(String productId) {
    _selProdId = productId;
    if (productId != null) {
      notifyListeners();
    }
  }

  void toggleDisplayMode() {
    _showFav = !_showFav;
    notifyListeners();
  }
}

class UserModel extends ConnectedProductsModel {
  PublishSubject<bool> _userSubject = PublishSubject();
  Timer _authTimer;

  User get user => _authUser;

  PublishSubject<bool> get userSubject => _userSubject;

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };
    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBUixWzGrcAjQbsNFr5LHBWxMjHjmkDB4k',
        body: json.encode(authData),
        headers: {'Content-type': 'application/json'},
      );
    } else {
      response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBUixWzGrcAjQbsNFr5LHBWxMjHjmkDB4k',
        body: json.encode(authData),
        headers: {'Content-type': 'application/json'},
      );
    }
    //print(json.decode(response.body));
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong.';
    //print(responseData);
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded!';
      _authUser = User(
        id: responseData['localId'],
        email: email,
        token: responseData['idToken'],
      );
      setAuthTimeout(int.parse(responseData['expiresIn']));
      _userSubject.add(true);
      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
      prefs.setString('userEmail', email);
      prefs.setString('userId', responseData['localId']);
      prefs.setString('expiryTime', expiryTime.toIso8601String());
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exist.';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email was not found.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid.';
    }
    _isLoading = false;
    notifyListeners();
    return {
      'success': !hasError,
      'message': message,
    };
  }

  void autoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String expiryTimeString = prefs.getString('expiryTime');
    if (token != null) {
      final DateTime now = DateTime.now();
      final parsedExpiryTime = DateTime.parse(expiryTimeString);
      if (parsedExpiryTime.isBefore(now)) {
        _authUser = null;
        notifyListeners();
        return;
      }
      final String userEmail = prefs.getString('userEmail');
      final String userId = prefs.getString('userId');
      final tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
      _authUser = User(id: userId, email: userEmail, token: token);
      _userSubject.add(true);
      setAuthTimeout(tokenLifespan);
      notifyListeners();
    }
  }

  void logout() async {
    //print('logout');
    _authUser = null;
    _authTimer.cancel();
    _userSubject.add(false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }
}

class UtilityModel extends ConnectedProductsModel {
  bool get isLoading => _isLoading;
}
