import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorage {
  final storageRef = FirebaseStorage.instance.ref();

  UploadTask uploadFile(File file, String path) {
    return storageRef.child(path).putFile(file);
  }

  Future<String> downloadFileURL(String path) async {
    return await storageRef.child(path).getDownloadURL();
  }

  Future<String> uploadImageToFirebaseStorage(String imagePath) async {
    File imageFile = File(imagePath);
    String newImagePath = 'profile_pictures/${DateTime.now()}.jpg';

    UploadTask uploadTask = storageRef.child(newImagePath).putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
