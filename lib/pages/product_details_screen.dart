import 'package:flutter/material.dart';

import 'package:lee_map_view/map_view.dart';

import '../widgets/ui_element/title_default.dart';
import '../models/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  ProductDetailsScreen(this.product);

  /*_showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('This action cann\'t be undone'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('DISCARD'),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true);
            },
            child: Text('CONTINUE'),
          ),
        ],
      ),
    );
  }*/
  void _showMap() {
    final markers = <Marker>[
      Marker(
        'position',
        'Position',
        product.location.latitude,
        product.location.longitude,
      ),
    ];
    final mapView = MapView();
    final cameraPosition = CameraPosition(
        Location(product.location.latitude, product.location.longitude), 14.0);
    mapView.show(
      MapOptions(
          initialCameraPosition: cameraPosition,
          mapViewType: MapViewType.normal,
          title: 'Product Location'),
      toolbarActions: [ToolbarAction('Close', 1)],
    );
    mapView.onToolbarAction.listen((int id) {
      if (id == 1) {
        mapView.dismiss();
      }
    });
    mapView.onMapReady.listen((_) {
      mapView.setMarkers(markers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print('BackButton Pressed');
        Navigator.pop(context, false);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.title),
        ),
        body: Column(
          children: [
            FadeInImage(
              image: NetworkImage(product.image),
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: AssetImage('assets/sweet.jpg'),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: TitleDefault(product.title),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _showMap,
                  child: Text(
                    product.location.address,
                    style: TextStyle(
                      fontFamily: 'Lato',
                      color: Colors.grey,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    '|',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Text(
                  product.price.toString(),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(product.description),
          ],
        ),
      ),
    );
  }
}
