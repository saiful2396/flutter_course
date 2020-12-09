import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/user.dart';

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

  Future<Null> fetchData() async {
    _isLoading = true;
    try {
      final http.Response response = await http.get(
          'https://fir-product-e18ed-default-rtdb.firebaseio.com/products.json');
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
          userEmail: prodData['userEmail'],
          userId: prodData['userId'],
        );
        fetchProductList.add(product);
      });
      _products = fetchProductList;
      _isLoading = false;
      notifyListeners();
      _selProdId = null;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return;
    }
  }

  Future<bool> addProduct(
      String title, String description, String image, double price) async {
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
    try {
      final http.Response response = await http.post(
        'https://fir-product-e18ed-default-rtdb.firebaseio.com/products.json',
        body: json.encode(productData),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
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
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(
      String title, String description, String image, double price) async {
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
      };
      await http.put(
          'https://fir-product-e18ed-default-rtdb.firebaseio.com/products/${selectedProduct.id}.json',
          body: json.encode(updateData));
      final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: title,
        description: description,
        image: image,
        price: price,
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
          'https://fir-product-e18ed-default-rtdb.firebaseio.com/products/${deletedProdId}.json');

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void toggleFav() {
    final bool isCurrentlyFav = selectedProduct.isFav;
    final bool isFavorite = !isCurrentlyFav;
    final Product updateProduct = Product(
      id: selectedProduct.id,
      title: selectedProduct.title,
      description: selectedProduct.description,
      image: selectedProduct.image,
      price: selectedProduct.price,
      userEmail: selectedProduct.userEmail,
      userId: selectedProduct.userId,
      isFav: isFavorite,
    );
    _products[selectedProdIndex] = updateProduct;
    notifyListeners();
  }

  void selectProduct(String productId) {
    _selProdId = productId;

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
