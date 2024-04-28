import 'package:flutter_test/flutter_test.dart';
import 'package:green_go/view/pages/score_edit_page.dart';

void main(){
  group("is numeric", () {

    ScoreEditPageState state = ScoreEditPageState();
    test("the number inserted is numeric", (){
      expect(state.isNumeric("123"), true);
    });

    test("the number inserted is not  numeric", (){
      expect(state.isNumeric("abc"), false);
    });

    test("the number inserted is not numeric but has numbers", (){
      expect(state.isNumeric("12ab"), false);
      expect(state.isNumeric("123AB1"), false);
      expect(state.isNumeric("ABS1"), false);
      expect(state.isNumeric("absd 1"), false);
    });
   });
}