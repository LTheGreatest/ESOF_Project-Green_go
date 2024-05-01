import 'package:flutter_test/flutter_test.dart';
import 'package:green_go/view/pages/search_page.dart';


void main(){
  group("title contains search String", (){
    test("title contains the search string", (){
      //given
      String search = "bus";
      String title = "bus stop";
      SearchPageState searchPageState = SearchPageState();
      searchPageState.setSearchString(search);

      //then
      expect(searchPageState.containsString(title), true);

    });

    test("title contians the search string but the search string has letters with different cases", (){
      //given
      String search = "bUS";
      String title = "bus stop";
      SearchPageState searchPageState = SearchPageState();
      searchPageState.setSearchString(search);

      //then
      expect(searchPageState.containsString(title), true);
    });

    test("title doesn't contain the search string", (){
      //given
      String search = "train";
      String title = "bus stop";
      SearchPageState searchPageState = SearchPageState();
      searchPageState.setSearchString(search);

      //then
      expect(searchPageState.containsString(title), false);
    });

    test("title doesn't contain the search string and search string has letters with different cases", (){
      //given
      String search = "trAIn";
      String title = "bus stop";
      SearchPageState searchPageState = SearchPageState();
      searchPageState.setSearchString(search);

      //then
      expect(searchPageState.containsString(title), false);
    });
  });
}