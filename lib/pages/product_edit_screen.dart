import 'package:flutter/material.dart';

import '../widgets/helpers/ensure_visible.dart';

class ProductEditScreen extends StatefulWidget {
  final Function addProduct;
  final Function updateProduct;
  final Map<String, dynamic> product;
  final int prodIndex;

  ProductEditScreen({
    this.addProduct,
    this.updateProduct,
    this.product,
    this.prodIndex,
  });

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

  void _saveForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (widget.product == null) {
      widget.addProduct(_formData);
    } else {
      widget.updateProduct(widget.prodIndex, _formData);
    }
    Navigator.pushReplacementNamed(context, '/product');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double devicePadding = deviceWidth - targetWidth;
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
                  initialValue:
                      widget.product == null ? '' : widget.product['title'],
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
                  initialValue: widget.product == null
                      ? ''
                      : widget.product['description'],
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
                  initialValue: widget.product == null
                      ? ''
                      : widget.product['price'].toString(),
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
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                alignment: Alignment.bottomRight,
                child: RaisedButton(
                  onPressed: _saveForm,
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
    return widget.product == null
        ? pageContent
        : Scaffold(
            appBar: AppBar(
              title: Text('Edit Product'),
            ),
            body: pageContent,
          );
  }
}
