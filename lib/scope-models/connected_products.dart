import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/user.dart';

class ConnectedProductsModel extends Model {
  List<Product> _products = [];
  User _authUser;
  int _selProdIndex;
  bool _isLoading = false;

  Future<Null> addProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          'https://cdn.pixabay.com/photo/2017/01/04/19/41/caramel-1952997_960_720.jpg',
      'price': price,
      'userEmail': _authUser.email,
      'userId': _authUser.id,
    };
    return http
        .post(
      'https://fir-product-e18ed-default-rtdb.firebaseio.com/products.json',
      body: json.encode(productData),
    )
        .then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      final Product newProduct = Product(
        id: responseData['name'],
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: _authUser.email,
        userId: _authUser.id,
      );
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
    });
  }
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

  int get selectedProdIndex => _selProdIndex;

  Product get selectedProduct {
    if (_selProdIndex == null) {
      return null;
    }
    return _products[_selProdIndex];
  }

  bool get displayFavOnly => _showFav;

  void fetchData() {
    _isLoading = true;
    http
        .get(
            'https://fir-product-e18ed-default-rtdb.firebaseio.com/products.json')
        .then((http.Response response) {
      //print(json.decode(response.body));
      final List<Product> fetchProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);
      if(productListData == null){
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
          userEmail: prodData['userEmail'],
          userId: prodData['userId'],
        );
        fetchProductList.add(product);
      });
      _products = fetchProductList;
      _isLoading = false;
      notifyListeners();
    });
  }

  void updateProduct(
      String title, String description, String image, double price) {
    final Product updatedProduct = Product(
      title: title,
      description: description,
      image: image,
      price: price,
      userEmail: selectedProduct.userEmail,
      userId: selectedProduct.userId,
    );
    _products[selectedProdIndex] = updatedProduct;
    notifyListeners();
  }

  void deleteProduct() {
    _products.removeAt(_selProdIndex);
    notifyListeners();
  }

  void toggleFav() {
    final bool isCurrentlyFav = selectedProduct.isFav;
    final bool isFavorite = !isCurrentlyFav;
    final Product updateProduct = Product(
      title: selectedProduct.title,
      description: selectedProduct.description,
      image: selectedProduct.image,
      price: selectedProduct.price,
      userEmail: selectedProduct.userEmail,
      userId: selectedProduct.userId,
      isFav: isFavorite,
    );
    _products[_selProdIndex] = updateProduct;
    notifyListeners();
  }

  void selectProduct(int index) {
    _selProdIndex = index;

    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFav = !_showFav;
    notifyListeners();
  }
}

class UserModel extends ConnectedProductsModel {
  void login(String email, String password) {
    _authUser = User(
      id: 'asdassd',
      email: email,
      password: password,
    );
  }
}
class UtilityModel extends ConnectedProductsModel {
  bool get isLoading => _isLoading;
}