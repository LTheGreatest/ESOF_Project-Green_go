import 'dart:io';

import 'package:green_go/controller/database/cloud_storage.dart';
import 'package:green_go/controller/fetchers/transports_icons_fetcher.dart';
import 'package:green_go/model/transport_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';

@GenerateNiceMocks([MockSpec<File>(), MockSpec<CloudStorage>()])

import 'transports_icons_fetcher_test.mocks.dart';
void main(){

  TestWidgetsFlutterBinding.ensureInitialized();
  test("get Transports Icons", () async{

    CloudStorage storage = MockCloudStorage();
    File image = MockFile();
    File image2 = MockFile();
    final fstorage = MockFirebaseStorage();
    await fstorage.ref().child('Bus.png').putFile(image);
    await fstorage.ref().child('Train.png').putFile(image2);
    TransportModel transportModel = TransportModel('Bus', 1.0);
    TransportModel transportModel2 = TransportModel('Train', 2.0);
    List<TransportModel> transports = [transportModel, transportModel2];
    TransportsIconsFetcher fetcher = TransportsIconsFetcher();

    when(storage.downloadFileURL('Bus.png')).thenAnswer((realInvocation) => fstorage.ref().child('Bus.png').getDownloadURL());
    when(storage.downloadFileURL('Train.png')).thenAnswer((realInvocation) => fstorage.ref().child('Train.png').getDownloadURL());

    fetcher.getTransportsIcons(transports);

    verify(storage.downloadFileURL('Bus.png')).called(1);
    

  });
}