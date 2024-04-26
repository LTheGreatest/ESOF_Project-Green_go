import 'package:flutter_test/flutter_test.dart';
import 'package:green_go/model/missions_model.dart';
import 'package:green_go/view/pages/mission_details.dart';

void main(){

  group("get types", () {

    test("Only string types", (){
      List<dynamic> list = ["train", "bus", "car"];
        MissionsModel model = MissionsModel("test","test", "test", list, 123);
        MissionDetails missionDetails = MissionDetails(model:model );

        expect(missionDetails.getTypes(list), list );
    });

    test("Only map types", (){
      Map map1 = {"distance": 1};
      Map map2 = {"points": 2};
      List<dynamic> list = [map1, map2];
        MissionsModel model = MissionsModel("test","test", "test", list, 123);
        MissionDetails missionDetails = MissionDetails(model:model );

        expect(missionDetails.getTypes(list),["distance", "points"]  );
    });

    test("strings and maps types", (){
      Map map1 = {"distance": 1};
      Map map2 = {"points": 2};
      List<dynamic> list = ["train", "bus", "car", map1, map2];
        MissionsModel model = MissionsModel("test","test", "test", list, 123);
        MissionDetails missionDetails = MissionDetails(model:model );

        expect(missionDetails.getTypes(list), ["train", "bus", "car", "distance", "points"] );
    });
   });
}