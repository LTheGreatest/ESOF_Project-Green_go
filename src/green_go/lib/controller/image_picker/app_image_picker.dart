import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AppImagePicker {
  ImageSource source;

  AppImagePicker({required this.source});

  Future<File?> pick() async {
    //picks an image from a specific source
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    if (image != null) {
      return File(image.path);
    } else {
      return null;
    }
  }
}
