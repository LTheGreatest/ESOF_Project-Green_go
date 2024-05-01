import 'package:green_go/controller/database/cloud_storage.dart';
import 'package:green_go/controller/fetchers/transports_icons_fetcher.dart';
import 'package:green_go/model/transport_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'transport_icons_fetcher_test.mocks.dart';

@GenerateNiceMocks([MockSpec<CloudStorage>()])

void main(){
  group("get icons from db",(){
    test("get icons",() async{
    //given
    CloudStorage storage = MockCloudStorage();
    TransportsIconsFetcher fetcher = TransportsIconsFetcher();
    when(storage.downloadFileURL("icons/Bus.png")).thenAnswer((realInvocation) => Future.value("https://firebasestorage.googleapis.com/v0/b/green-go-ba24b.appspot.com/o/icons%2FBus.png?alt=media&token=80f2025b-51b7-4b28-9534-237c248f869a"));
    TransportModel model = TransportModel("Bus", 1);
    fetcher.setStorage(storage);

    //when
    List<List<dynamic>> list = await fetcher.getTransportsIcons([model]);

    //then
    expectLater(list.length, 1);
    expectLater(list[0][0].height != 0, true);


  });

  test("get icons but icon for that trasport doen't exists",() async{
    //given
    CloudStorage storage = MockCloudStorage();
    TransportsIconsFetcher fetcher = TransportsIconsFetcher();
    when(storage.downloadFileURL("icons/Train.png")).thenAnswer((realInvocation) => Future.value("https://firebasestorage.googleapis.com/v0/b/green-go-ba24b.appspot.com/o/icons%2FBus.png?alt=media&token=80f2025b-51b7-4b28-9534-237c248f869a"));
    TransportModel model = TransportModel("Bus", 1);
    fetcher.setStorage(storage);

    //when
    List<List<dynamic>> list = await fetcher.getTransportsIcons([model]);

    //image has null height, widht, etc.. basicly doesn't exists
    expectLater(list[0][0].height, null);


  });

  test("get icons but url is wrong",() async{
    //given
    CloudStorage storage = MockCloudStorage();
    TransportsIconsFetcher fetcher = TransportsIconsFetcher();
    when(storage.downloadFileURL("icons/Train.png")).thenAnswer((realInvocation) => Future.value("ewrg"));
    TransportModel model = TransportModel("Bus", 1);
    fetcher.setStorage(storage);

    //when
    List<List<dynamic>> list = await fetcher.getTransportsIcons([model]);

    //then
    expectLater(list[0][0].height, null);


  });

  });
  
}