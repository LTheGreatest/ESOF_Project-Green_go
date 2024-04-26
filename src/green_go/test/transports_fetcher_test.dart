import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'package:green_go/controller/database/database_transports.dart';
import 'package:green_go/controller/fetchers/transports_fetcher.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

@GenerateNiceMocks([MockSpec<DataBaseTransports>()])
import 'transports_fetcher_test.mocks.dart';

void main(){

  group("get transports", () { 
    test("get transports", () async{
    //given
    TransportsFetcher fetcher = TransportsFetcher();
    DataBaseTransports db = MockDataBaseTransports();
    final instance =  FakeFirebaseFirestore();
    await instance.collection('transports').add({
      'name': 'bus',
      'pointsPerDist' : 1.5
    }
    );
    await instance.collection('transports').add({
      'name': 'train',
      'pointsPerDist': 2.0
    }
    );
    when(db.getAllData()).thenAnswer((realInvocation) => instance.collection('transports').get());
    fetcher.setDB(db);

    //when
    final transports = await fetcher.getTransports();

    //then
    expectLater(transports[0].name, 'bus');
    expectLater(transports[0].pointsPerDist, 1.5);
    expectLater(transports[1].name, 'train');
    expectLater(transports[1].pointsPerDist, 2);
    
  });

    test("get transports but some parameters are missing", () async{
    //given
    TransportsFetcher fetcher = TransportsFetcher();
    DataBaseTransports db = MockDataBaseTransports();
    final instance =  FakeFirebaseFirestore();
    await instance.collection('transports').add({
      'pointsPerDist' : 1.5
    }
    );
    await instance.collection('transports').add({
      'name': 'train',
    }
    );
    when(db.getAllData()).thenAnswer((realInvocation) => instance.collection('transports').get());
    fetcher.setDB(db);

    //when
    final transports = await fetcher.getTransports();

    //then
    expectLater(transports.length, 0);
    
  });

  test("get transports but there are no transports", () async{
    //given
    TransportsFetcher fetcher = TransportsFetcher();
    DataBaseTransports db = MockDataBaseTransports();
    final instance =  FakeFirebaseFirestore();
    when(db.getAllData()).thenAnswer((realInvocation) => instance.collection('transports').get());
    fetcher.setDB(db);

    //when
    final transports = await fetcher.getTransports();

    //then
    expectLater(transports.length, 0);
    
  });
  });
  

}