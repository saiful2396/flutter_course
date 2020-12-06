import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/helpers/ensure_visible.dart';
import '../models/product.dart';
import '../scope-models/products_model.dart';

class ProductEditScreen extends StatefulWidget {
  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'title': null,
    'price': null,
    'description': null,
    'image': 'assets/sweet.jpg',
  };
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  void _saveForm(Function addProduct, Function updateProduct,
      [int selectedProdIndex]) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (selectedProdIndex == null) {
      addProduct(
        Product(
          title: _formData['title'],
          description: _formData['description'],
          image: _formData['image'],
          price: _formData['price'],
        ),
      );
    } else {
      updateProduct(
        Product(
          title: _formData['title'],
          description: _formData['description'],
          image: _formData['image'],
          price: _formData['price'],
        ),
      );
    }
    Navigator.pushReplacementNamed(context, '/product');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double devicePadding = deviceWidth - targetWidth;
    return ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        final Widget pageContent = GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            padding: const EdgeInsets.only(top: 15.0),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: devicePadding / 2),
                children: [
                  EnsureVisibleWhenFocused(
                    focusNode: _titleFocusNode,
                    child: TextFormField(
                      focusNode: _titleFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      initialValue: model.selectedProduct == null
                          ? ''
                          : model.selectedProduct.title,
                      validator: (val) {
                        if (val.isEmpty || val.length < 5) {
                          return 'Title is required & too short';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          _formData['title'] = val;
                        });
                      },
                    ),
                  ),
                  EnsureVisibleWhenFocused(
                    focusNode: _descriptionFocusNode,
                    child: TextFormField(
                      focusNode: _descriptionFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 4,
                      initialValue: model.selectedProduct == null
                          ? ''
                          : model.selectedProduct.description,
                      validator: (val) {
                        if (val.isEmpty || val.length < 12) {
                          return 'Description is required & too short';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          _formData['description'] = val;
                        });
                      },
                    ),
                  ),
                  EnsureVisibleWhenFocused(
                    focusNode: _priceFocusNode,
                    child: TextFormField(
                      focusNode: _priceFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: model.selectedProduct == null
                          ? ''
                          : model.selectedProduct.price.toString(),
                      validator: (val) {
                        if (val.isEmpty ||
                            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$')
                                .hasMatch(val)) {
                          return 'Price is required & should be a number';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          _formData['price'] = double.parse(val);
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                    alignment: Alignment.bottomRight,
                    child: RaisedButton(
                      onPressed: () => _saveForm(
                        model.addProduct,
                        model.updateProduct,
                        model.selectedProdIndex,
                      ),
                      child: Text('Save'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        return model.selectedProdIndex == null
            ? pageContent
            : Scaffold(
                appBar: AppBar(
                  title: Text('Edit Product'),
                ),
                body: pageContent,
              );
      },
    );
  }
}
