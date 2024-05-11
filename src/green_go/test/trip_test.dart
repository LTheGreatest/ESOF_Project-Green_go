import 'package:green_go/controller/location/location.dart';
import 'package:green_go/model/transport_model.dart';
import 'package:green_go/view/pages/points_earned_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  
  group("Test distance calculations", (){

    test("using negative coordinates for start location", (){
      //given
      LocationService locationService = LocationService();

      //when
      double dist = locationService.calculateDistance(-10, -90, 30, 170);

      //then
      expect((dist).round(), 11531262);
    });

    test("using both coordinastes negative", (){
      //given
        LocationService locationService = LocationService();

      //when
        double dist = locationService.calculateDistance(-10, -90, -30, -170);

      //then
        expect((dist).round(), 8506246); 
    });

  test("using negative for end location", (){
    //given
     LocationService locationService = LocationService();

    //when
    double dist = locationService.calculateDistance(10, 90, -30, -170);

    //then
    expect((dist).round(), 11531262); 
  });

  test("using both positive", (){
    //given
    LocationService locationService = LocationService();

    //when
    double dist = locationService.calculateDistance(10, 90, 30, 70);

    //then
    expect((dist).round(), 3044009); 
  });

  test("using too low start latitude", (){
    //given
    LocationService locationService = LocationService();

    //when
    double dist = locationService.calculateDistance(-91, 90, 30, 70);

    //then
    expect((dist).round(), 0); 
  });

  test("using too high start latitude ", (){
    //given
    LocationService locationService = LocationService();

    //when
    double dist = locationService.calculateDistance(91, 90, 30, 70);

    //then
    expect((dist).round(), 0); 
  });

  test("using too low start longitude", (){
    //given
    LocationService locationService = LocationService();

    //when
    double dist = locationService.calculateDistance(-90, -181 , 30, 70);

    //then
    expect((dist).round(), 0); 
  });

  test("using too high start longitude ", (){
    //given
    LocationService locationService = LocationService();

    //when
    double dist = locationService.calculateDistance(90, 181, 30, 70);

    //then
    expect((dist).round(), 0); 
  });

  test("using too low end latitude", (){
    //given
    LocationService locationService = LocationService();

    //when
    double dist = locationService.calculateDistance(90, 90, -91, 70);
    //then
    expect((dist).round(), 0); 
  });

  test("using too high end latitude ", (){
    //given
    LocationService locationService = LocationService();

    //when
    double dist = locationService.calculateDistance(9, 90, 91, 70);

    //then
    expect((dist).round(), 0); 
  });

  test("using too low end longitude", (){
    //given
    LocationService locationService = LocationService();

    //when
    double dist = locationService.calculateDistance(-90, 90, 30, -181);

    //then
    expect((dist).round(), 0); 
  });

  test("using too high end longitude ", (){
    //given
    LocationService locationService = LocationService();

    //when
    double dist = locationService.calculateDistance(91, 90, 30, 181);

    //then
    expect((dist).round(), 0); 
  });
  });

  group("Test point calculations", (){

    test("calculate points distance", (){
      //given
      final TransportModel transportModel = TransportModel("teste", 1.2);
      PointsEarnedPage page =  PointsEarnedPage(distance: 20, transport: transportModel);
      PointsEarnedPageState state = page.createState();

      //then
      expect(state.calculatePoints(20, 1.2), 24);
    });

    test("distance to small (residual distance)", (){
      //given
      final TransportModel transportModel = TransportModel("teste", 1.2);
      PointsEarnedPage page = PointsEarnedPage(distance: 0.002, transport: transportModel);
      PointsEarnedPageState state = page.createState();

      //then
      expect(state.calculatePoints(0.002, 1.2), 0);
    });

    test("negative distance should return 0 points", (){
      //given
      final TransportModel transportModel = TransportModel("teste", 1.2);
      PointsEarnedPage page = PointsEarnedPage(distance: -10, transport: transportModel);
      PointsEarnedPageState state = page.createState();

      //then
      expect(state.calculatePoints(-10, 1.2), 0);
    });

    test("negative pointPerDist should return 0 points", (){
      //given
      final TransportModel transportModel = TransportModel("teste", -1.2);
      PointsEarnedPage page = PointsEarnedPage(distance: 10, transport: transportModel);
      PointsEarnedPageState state = page.createState();

      //then
      expect(state.calculatePoints(10, -1.2), 0);
    });

    test("both negative distance and pointsPerDist should return 0 points", (){
      //given
      final TransportModel transportModel = TransportModel("teste", -1.2);
      PointsEarnedPage page = PointsEarnedPage(distance: -10, transport: transportModel);
      PointsEarnedPageState state = page.createState();

      //then
      expect(state.calculatePoints(-10, -1.2), 0);
    });
  });
}