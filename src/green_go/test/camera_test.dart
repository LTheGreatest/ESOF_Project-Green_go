
import 'package:camera/camera.dart';
import 'package:green_go/controller/camera/camera_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

@GenerateNiceMocks([MockSpec<CameraController>(), MockSpec<CameraDescription>()])

import 'camera_test.mocks.dart';

class FakeCameraController extends Fake implements CameraController{
  FakeCameraController(this.description);
  @override
  CameraDescription description;
}

class FakeCamereDescription extends Fake implements CameraDescription{
  FakeCamereDescription(this.lensDirection);
  @override
  final CameraLensDirection lensDirection;
}

void main(){
  late CameraController cameraController;
  late CameraService cameraService;
  

  setUpAll(() {
    cameraController = MockCameraController();
    cameraService = CameraService();
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test("dispose the controller", () async {
    //given
    cameraService.setCameraController(cameraController);

    //when
    cameraService.disposeController();

    //then
    verify(cameraController.dispose()).called(1);
  });

  

}