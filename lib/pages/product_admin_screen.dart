import 'package:flutter/material.dart';

import './product_list_screen.dart';
import './product_edit_screen.dart';
import '../scope-models/main_model.dart';

class ProductAdminScreen extends StatelessWidget {
  final MainModel model;
  ProductAdminScreen(this.model);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(' Manage Product'),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.create),
                child: Text('Create Product'),
              ),
              Tab(
                icon: Icon(Icons.list),
                child: Text('My Product'),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                title: Text('Choose'),
              ),
              ListTile(
                leading: Icon(Icons.shop),
                title: Text('All Product'),
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    '/product',
                  );
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ProductEditScreen(),
            ProductListScreen(model),
          ],
        ),
      ),
    );
  }
}
