import 'package:green_go/controller/location/location.dart';
import 'package:green_go/view/pages/points_earned_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  
  group("Test distance calculations", (){

    test("using negative coordinates for start location", (){
        LocationService locationService = LocationService();

        double dist = locationService.calculateDistance(-10, -90, 30, 170);

        expect((dist).round(), 11531262);
    });

    test("using both coordinastes negative", (){
        LocationService locationService = LocationService();

        double dist = locationService.calculateDistance(-10, -90, -30, -170);

        expect((dist).round(), 8506246); 
    });

  test("using negative for end location", (){
     LocationService locationService = LocationService();

        double dist = locationService.calculateDistance(10, 90, -30, -170);

        expect((dist).round(), 11531262); 
    });

  test("using both positive", (){
        LocationService locationService = LocationService();

        double dist = locationService.calculateDistance(10, 90, 30, 70);

        expect((dist).round(), 3044009); 
  });

  test("using too low start latitude", (){
      LocationService locationService = LocationService();

        double dist = locationService.calculateDistance(-91, 90, 30, 70);

        expect((dist).round(), 0); 
  });

  test("using too high start latitude ", (){
      LocationService locationService = LocationService();

        double dist = locationService.calculateDistance(91, 90, 30, 70);

        expect((dist).round(), 0); 
  });

    test("using too low start longitude", (){
      LocationService locationService = LocationService();

        double dist = locationService.calculateDistance(-90, -181 , 30, 70);

        expect((dist).round(), 0); 
  });

  test("using too high start longitude ", (){
      LocationService locationService = LocationService();

        double dist = locationService.calculateDistance(90, 181, 30, 70);

        expect((dist).round(), 0); 
  });

    test("using too low end latitude", (){
      LocationService locationService = LocationService();

        double dist = locationService.calculateDistance(90, 90, -91, 70);

        expect((dist).round(), 0); 
  });

  test("using too high end latitude ", (){
      LocationService locationService = LocationService();

        double dist = locationService.calculateDistance(9, 90, 91, 70);

        expect((dist).round(), 0); 
  });

    test("using too low end longitude", (){
      LocationService locationService = LocationService();

        double dist = locationService.calculateDistance(-90, 90, 30, -181);

        expect((dist).round(), 0); 
  });

  test("using too high end longitude ", (){
      LocationService locationService = LocationService();

        double dist = locationService.calculateDistance(91, 90, 30, 181);

        expect((dist).round(), 0); 
  });
  });

  group("Test point calculations", (){

    test("calculate points distance", (){
      PointsEarnedPage page = const PointsEarnedPage(distance: 20, pointsPerDist: 1.2);
      PointsEarnedPageState state = page.createState();

      expect(state.calculatePoints(20, 1.2), 24);
    });

    test("distance to small (residual distance)", (){
      PointsEarnedPage page = const PointsEarnedPage(distance: 0.002, pointsPerDist: 1.2);
      PointsEarnedPageState state = page.createState();

      expect(state.calculatePoints(0.002, 1.2), 0);
    });

    test("negative distance should return 0 points", (){
      PointsEarnedPage page = const PointsEarnedPage(distance: -10, pointsPerDist: 1.2);
      PointsEarnedPageState state = page.createState();

      expect(state.calculatePoints(-10, 1.2), 0);
    });

    test("negative pointPerDist should return 0 points", (){
      PointsEarnedPage page = const PointsEarnedPage(distance: 10, pointsPerDist: -1.2);
      PointsEarnedPageState state = page.createState();

      expect(state.calculatePoints(10, -1.2), 0);
    });

    test("both negative distance and pointsPerDist should return 0 points", (){
       PointsEarnedPage page = const PointsEarnedPage(distance: -10, pointsPerDist: -1.2);
      PointsEarnedPageState state = page.createState();

      expect(state.calculatePoints(-10, -1.2), 0);
    });
  });
}