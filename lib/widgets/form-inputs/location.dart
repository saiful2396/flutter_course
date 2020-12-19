import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:lee_map_view/map_view.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as geoloc;

import '../helpers/ensure_visible.dart';
import '../../models/location_data.dart';
import '../../models/product.dart';

class LocationInput extends StatefulWidget {
  final Function setLocation;
  final Product product;

  LocationInput(this.setLocation, this.product);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  Uri _staticMapUri;
  LocationData _locationData;
  final FocusNode _addressInputFocusNode = FocusNode();
  final TextEditingController _addressInputController = TextEditingController();

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    if (widget.product != null) {
      _getStaticMap(widget.product.location.address, geocode: false);
    }
    super.initState();
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  void _getStaticMap(String address,
      {bool geocode = true, double lat, double lng}) async {
    if (address.isEmpty) {
      setState(() {
        _staticMapUri = null;
      });
      widget.setLocation(null);
      return;
    }
    if (geocode) {
      final Uri uri = Uri.https(
        'maps.googleapis.com',
        '/maps/api/geocode/json',
        {'address': address, 'key': 'AIzaSyDnIZj5SxU8Zo87f54s0gLS7bSLt9me3X4'},
      );
      final http.Response response = await http.get(uri);
      final decodedResponse = json.decode(response.body);
      //print(decodedResponse);
      final formattedAddress =
          decodedResponse['results'][0]['formatted_address'];
      final cords = decodedResponse['results'][0]['geometry']['location'];
      _locationData = LocationData(
        address: formattedAddress,
        latitude: cords['lat'],
        longitude: cords['lng'],
      );
    } else if (lat == null && lng == null) {
      _locationData = widget.product.location;
    } else {
      _locationData =
          LocationData(address: address, latitude: lat, longitude: lng);
    }
    if (mounted) {
      final StaticMapProvider staticMapView =
          StaticMapProvider('AIzaSyDnIZj5SxU8Zo87f54s0gLS7bSLt9me3X4');
      final Uri staticMapUri = staticMapView.getStaticUriWithMarkers(
        [
          Marker('position', 'position', _locationData.latitude,
              _locationData.longitude)
        ],
        center: Location(_locationData.latitude, _locationData.longitude),
        width: 500,
        height: 300,
        maptype: StaticMapViewType.roadmap,
      );
      widget.setLocation(_locationData);
      setState(() {
        _staticMapUri = staticMapUri;
        _addressInputController.text = _locationData.address;
      });
    }
  }

  Future<String> _getAddress(double lat, double lng) async {
    final Uri uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {
        'latlng': '${lat.toString()},${lng.toString()}',
        'key': 'AIzaSyDnIZj5SxU8Zo87f54s0gLS7bSLt9me3X4'
      },
    );
    final http.Response response = await http.get(uri);
    final decodeResponse = json.decode(response.body);
    final formattedAddress = decodeResponse['results'][0]['formatted_address'];
    return formattedAddress;
  }

  Future<LocationData> _getUserLocation() async {
    final location = geoloc.Location();
    final currentLocation = await location.getLocation();
    final address = await _getAddress(
      currentLocation.latitude,
      currentLocation.longitude,
    );
    _getStaticMap(
      address,
      geocode: false,
      lat: currentLocation.latitude,
      lng: currentLocation.longitude,
    );
    return null;
  }

  void _updateLocation() {
    if (!_addressInputFocusNode.hasFocus) {
      _getStaticMap(_addressInputController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EnsureVisibleWhenFocused(
          focusNode: _addressInputFocusNode,
          child: TextFormField(
            focusNode: _addressInputFocusNode,
            controller: _addressInputController,
            validator: (val) {
              if (_locationData == null && val.isEmpty) {
                return 'No valid location found.';
              }
              return null;
            },
            decoration: InputDecoration(labelText: 'Address'),
          ),
        ),
        SizedBox(height: 10),
        FlatButton(
          onPressed: _getUserLocation,
          child: Text('Locate User'),
        ),
        SizedBox(height: 10),
        _staticMapUri == null
            ? Container()
            : Image.network(_staticMapUri.toString()),
      ],
    );
  }
}
