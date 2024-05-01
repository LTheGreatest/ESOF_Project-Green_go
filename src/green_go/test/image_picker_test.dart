import 'package:green_go/controller/image_picker/app_image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'image_picker_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ImagePicker>()])

void main(){
  test("Image picker behaviour", (){
    //given
      ImagePicker pickerMock = MockImagePicker();
      AppImagePicker appPicker = AppImagePicker(source: ImageSource.gallery);
      appPicker.setPicker(pickerMock);

      //when
      appPicker.pick();

      //then
      verify(pickerMock.pickImage(source: ImageSource.gallery)).called(1);
  });
}