import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../widgets/helpers/ensure_visible.dart';
import '../widgets/form-inputs/location.dart';
import '../widgets/form-inputs/image.dart';
import '../scope-models/main_model.dart';
import '../models/location_data.dart';
import '../models/product.dart';

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
    'location': null,
  };
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  void _setLocation(LocationData locData) {
    _formData['location'] = locData;
  }

  void _saveForm(
      Function addProduct, Function updateProduct, Function setSelectedProduct,
      [int selectedProdIndex]) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (selectedProdIndex == -1) {
      addProduct(
              //_formData['title'],
              _titleController.text,
              _descriptionController.text,
              _formData['image'],
              double.parse(_priceController.text),
              _formData['location'])
          .then(
        (bool success) {
          if (success) {
            return Navigator.pushReplacementNamed(context, '/product').then(
              (_) => setSelectedProduct(null),
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Something went wrong'),
                  content: Text('Please try again later'),
                  actions: [
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                );
              },
            );
          }
        },
      );
    } else {
      updateProduct(
        //_formData['title'],
        _titleController.text,
        _descriptionController.text,
        _formData['image'],
        double.parse(_priceController.text),
        _formData['location'],
      ).then(
        (_) => Navigator.pushReplacementNamed(context, '/product').then(
          (_) => setSelectedProduct(null),
        ),
      );
    }
  }

  Widget _buildTitleTextField(BuildContext context, Product product) {
    if (product == null && _titleController.text.trim() == '') {
      _titleController.text = '';
    } else if (product != null && _titleController.text.trim() == '') {
      _titleController.text = product.title;
    } else if (product != null && _titleController.text.trim() != '') {
      _titleController.text = _titleController.text;
    } else if (product == null && _titleController.text.trim() != '') {
      _titleController.text = _titleController.text;
    } else {
      _titleController.text = '';
    }
    return EnsureVisibleWhenFocused(
      focusNode: _titleFocusNode,
      child: TextFormField(
        focusNode: _titleFocusNode,
        decoration: InputDecoration(
          labelText: 'Title',
        ),
        // initialValue: model.selectedProduct == null
        //     ? ''
        //     : model.selectedProduct.title,
        controller: _titleController,
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
    );
  }

  Widget _buildDescriptionTextField(BuildContext context, Product product) {
    if (product == null && _descriptionController.text.trim() == '') {
      _descriptionController.text = '';
    } else if (product != null && _descriptionController.text.trim() == '') {
      _descriptionController.text = product.description;
    }
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
        focusNode: _descriptionFocusNode,
        decoration: InputDecoration(
          labelText: 'Description',
        ),
        maxLines: 4,
        controller: _descriptionController,
        //initialValue: product == null ? '' : product.description,
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
    );
  }

  Widget _buildPriceTextField(BuildContext context, Product product) {
    if (product == null && _priceController.text.trim() == '') {
      _priceController.text = '';
    } else if (product != null && _priceController.text.trim() == '') {
      _priceController.text = product.price.toString();
    }
    return EnsureVisibleWhenFocused(
      focusNode: _priceFocusNode,
      child: TextFormField(
        focusNode: _priceFocusNode,
        decoration: InputDecoration(
          labelText: 'Price',
        ),
        keyboardType: TextInputType.number,
        //initialValue: product == null ? '' : product.price.toString(),
        controller: _priceController,
        validator: (val) {
          if (val.isEmpty ||
              !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(val)) {
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
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return model.isLoading
          ? Center(child: CircularProgressIndicator())
          : RaisedButton(
              onPressed: () => _saveForm(
                model.addProduct,
                model.updateProduct,
                model.selectProduct,
                model.selectedProdIndex,
              ),
              child: Text('Save'),
              textColor: Colors.white,
            );
    });
  }

  Widget _buildPageContent(BuildContext context, Product product) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double devicePadding = deviceWidth - targetWidth;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          margin: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: devicePadding / 2),
              children: [
                _buildTitleTextField(context, product),
                _buildDescriptionTextField(context, product),
                _buildPriceTextField(context, product),
                /*EnsureVisibleWhenFocused(
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
                  ),*/
                SizedBox(height: 10),
                LocationInput(_setLocation, product),
                SizedBox(height: 10),
                ImageInput(),
                SizedBox(height: 10),
                _buildSubmitButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      final Widget pageContent =
          _buildPageContent(context, model.selectedProduct);
      return model.selectedProdIndex == -1
          ? pageContent
          : Scaffold(
              appBar: AppBar(
                title: Text('Edit Product'),
              ),
              body: pageContent,
            );
    });
  }
}
