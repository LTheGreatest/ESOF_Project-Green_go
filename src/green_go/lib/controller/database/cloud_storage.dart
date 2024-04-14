import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorage{
  final storageRef = FirebaseStorage.instance.ref();

  UploadTask uploadFile(File file, String path) {
    return storageRef.child(path).putFile(file);
  }
  Future<String> downloadFileURL(String path) async {
    return await storageRef.child(path).getDownloadURL();
  }
}
