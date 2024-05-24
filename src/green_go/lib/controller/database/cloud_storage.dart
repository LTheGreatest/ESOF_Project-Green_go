import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorage {
  final storageRef = FirebaseStorage.instance.ref();

  Future<String> downloadFileURL(String path) async {
    //gets the download url of a file from the firebase storage
    return await storageRef.child(path).getDownloadURL();
  }

  Future<String> uploadImageToFirebaseStorage(String imagePath) async {
    //uploads a file with specific image to the firebase storage
    File imageFile = File(imagePath);
    String newImagePath = 'profile_pictures/${DateTime.now()}.jpg';

    UploadTask uploadTask = storageRef.child(newImagePath).putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
