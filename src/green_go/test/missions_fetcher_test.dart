import 'package:green_go/controller/database/database_missions.dart';
import 'package:green_go/controller/fetchers/missions_fetcher.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'missions_fetcher_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DataBaseMissions>()])

void main(){

  group("get Missions", () {
     test("get missions", () async{
      //given
        MissionsFetcher fetcher = MissionsFetcher();
        DataBaseMissions db = MockDataBaseMissions();
        final instance =  FakeFirebaseFirestore();

        await instance.collection('missions').add({
            'title' : 'use train',
            'description' : 'use train one time',
            'points': 500,
            'frequency': 'annual',
            'types' : ['train', 'points', 23]
        }
        );

        await instance.collection('missions').add({
            'title' : 'use bus 1km',
            'description' : 'use bus one time for 1km',
            'points': 500,
            'frequency': "daily",
            'types' : ['bus', 'distance', 1000]
        }
        );

        when(db.getAllMissions()).thenAnswer((realInvocation) => instance.collection('missions').get());
        fetcher.setDB(db);

        //when
        final missions = await fetcher.getAllMissions();

        //then
        expectLater(missions[0].title, 'use train');
        expectLater(missions[0].description,'use train one time' );
        expectLater(missions[0].points, 500);
        expectLater(missions[0].frequency, 'annual');
        expectLater(missions[0].types,['train', 'points', 23] );
        expectLater(missions[1].title, 'use bus 1km');
        expectLater(missions[1].description,'use bus one time for 1km');
        expectLater(missions[1].points, 500);
        expectLater(missions[1].frequency, 'daily');
        expectLater(missions[1].types, ['bus', 'distance', 1000]);

    });

    test("Get mission but not every element is filled", () async{
      //given
      MissionsFetcher fetcher = MissionsFetcher();
      DataBaseMissions db = MockDataBaseMissions();
      final instance =  FakeFirebaseFirestore();

      await instance.collection('missions').add({
          'title' : 'use train',
          'description' : 'use train one time',
          'points': 500,
          'types' : ['train', 'points', 23]
      }
      );

      await instance.collection('missions').add({
          'title' : 'use bus 1km',
          'description' : 'use bus one time for 1km',
          'points': 500,
          'types' : ['bus', 'distance', 1000]
      }
      );

      when(db.getAllMissions()).thenAnswer((realInvocation) => instance.collection('missions').get());
      fetcher.setDB(db);

      //when
      final missions = await fetcher.getAllMissions();

      //then
      expectLater(missions.length, 0);
    });

    test("Get mission but there are no missions", () async{
      //given
      MissionsFetcher fetcher = MissionsFetcher();
      DataBaseMissions db = MockDataBaseMissions();
      final instance =  FakeFirebaseFirestore();

      when(db.getAllMissions()).thenAnswer((realInvocation) => instance.collection('missions').get());
      fetcher.setDB(db);

      //when
      final missions = await fetcher.getAllMissions();

      //then
      expectLater(missions.length, 0);
    });
  });
 
  
}