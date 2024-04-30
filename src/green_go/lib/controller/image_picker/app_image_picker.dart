import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AppImagePicker {
  ImageSource source;
  late ImagePicker picker = ImagePicker();

  AppImagePicker({required this.source});

  void setPicker(ImagePicker newPicker){
    picker = newPicker;
  }
  
  Future<File?> pick() async {
    //picks an image from a specific source
    final image = await picker.pickImage(source: source);
    if (image != null) {
      return File(image.path);
    } else {
      return null;
    }
  }
}
