import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _image;
  final picker = ImagePicker();

  Future _getImage(BuildContext context, ImageSource source) async {
    final pickedFile = await picker.getImage(
      source: source,
      maxWidth: 400.0,
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        Navigator.pop(context);
      } else {
        print('No image selected.');
      }
    });
  }
  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          final textColor = Theme.of(context).accentColor;
          return Container(
            height: 150.0,
            child: Column(
              children: [
                SizedBox(height: 10.0),
                Text(
                  'Pick an Image',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10.0),
                FlatButton(
                    onPressed: () => _getImage(context, ImageSource.camera),
                    child: Text('Use Camera'),
                    textColor: textColor),
                FlatButton(
                    onPressed: () => _getImage(context, ImageSource.gallery),
                    child: Text('Use Gallery'),
                    textColor: textColor),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final buttonColors = Theme.of(context).accentColor;
    return Column(
      children: [
        OutlineButton(
          onPressed: () => _openImagePicker(context),
          borderSide: BorderSide(color: buttonColors, width: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt, color: buttonColors),
              SizedBox(width: 5),
              Text(
                'Add Image',
                style: TextStyle(color: buttonColors),
              )
            ],
          ),
        ),
        SizedBox(height: 10),
        _image == null
            ? Text('No image selected.')
            : Image.file(
                _image,
                fit: BoxFit.cover,
                height: 300.0,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.topCenter,
              ),
      ],
    );
  }
}
