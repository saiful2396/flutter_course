import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';

class ProductsModel extends Model {
  List<Product> _product = [];
  int _selectedProdIndex;

  List<Product> get products => List.from(_product);

  int get selectedProdIndex => _selectedProdIndex;

  Product get selectedProduct {
    if (_selectedProdIndex == null) {
      return null;
    }
    return _product[_selectedProdIndex];
  }

  void addProduct(Product products) {
    _product.add(products);
    _selectedProdIndex = null;
  }

  void updateProduct(Product product) {
    _product[_selectedProdIndex] = product;
    _selectedProdIndex = null;
  }

  void deleteProduct() {
    _product.removeAt(_selectedProdIndex);
    _selectedProdIndex = null;
  }

  void selectProduct(int index) {
    _selectedProdIndex = index;
  }
}
