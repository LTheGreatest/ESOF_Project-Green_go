import 'package:flutter_test/flutter_test.dart';
import 'package:green_go/view/pages/profile_page.dart';

void main(){
  group("calculate age", () {
      test("calculate age", (){
        ProfilePageState state = ProfilePageState();

        int age = state.calculateAge(DateTime(2020, 10, 1));
        expect(age >= 3, true);
      });

      test("calculate age but is in the future", (){
        ProfilePageState state = ProfilePageState();

        int age = state.calculateAge(DateTime(10000, 10, 1));
        expect(age, 18);
      });

      test("calculate age but the month is more than the now time", (){
        ProfilePageState state = ProfilePageState();

        int age = state.calculateAge(DateTime(DateTime.now().year - 2,DateTime.now().month + 1, 1));
        expect(age, DateTime.now().year + 1 - DateTime.now().year);
      });

      test("calculate age but the day is more than the now time", (){
        ProfilePageState state = ProfilePageState();

        int age = state.calculateAge(DateTime(DateTime.now().year - 2,DateTime.now().month, DateTime.now().day + 1));
        expect(age, DateTime.now().year + 1 - DateTime.now().year);
      });
   });
}