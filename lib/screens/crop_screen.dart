import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CropScreen extends StatefulWidget {
  @override
  _CropScreenState createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  File image;

  pickImage() async {
    PickedFile pickedImage = await ImagePicker().getImage(
      source: ImageSource.camera,
    );

    if (pickedImage != null) {
      File cropper = await ImageCropper.cropImage(
        sourcePath: pickedImage.path,
        aspectRatio: CropAspectRatio(
          ratioX: 2,
          ratioY: 2,
        ),
        compressQuality: 100,
        maxHeight: 700,
        maxWidth: 700,
        compressFormat: ImageCompressFormat.png,
      );
      compressImage(cropper, pickedImage.path).then((value) {
        setState(() {
          image = cropper;
        });
      });
    }
  }

  Future<File> compressImage(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 80,
      minHeight: 1920,
      minWidth: 1080,
      rotate: 90,
      // format: CompressFormat.png,
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Image'),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            image == null
                ? Icon(
                    Icons.person,
                    size: 150,
                    color: Colors.grey[300],
                  )
                : Image.file(
                    File(image.path),
                    width: 150,
                    fit: BoxFit.fitWidth,
                  ),
            ElevatedButton(
              child: Text('Tambahkan foto'),
              onPressed: () {
                pickImage();
              },
            ),
          ],
        ),
      ),
    );
  }
}
