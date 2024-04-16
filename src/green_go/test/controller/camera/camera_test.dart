
import 'package:camera/camera.dart';
import 'package:green_go/controller/camera/camera_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

@GenerateNiceMocks([MockSpec<CameraController>()])

import 'camera_test.mocks.dart';


void main(){
  
  CameraController cameraController = MockCameraController();
  CameraService cameraService = CameraService();

  test("dispose the controller", () async {
    //given
    cameraService.setCameraController(cameraController);

    //when
    cameraService.disposeController();

    //then
    verify(cameraController.dispose()).called(1);
  });

}