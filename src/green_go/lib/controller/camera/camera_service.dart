import 'package:camera/camera.dart';

class CameraService {
  late List<CameraDescription> camerasList;
  CameraDescription? camera;
  late CameraController cameraController;

  void setCameraController(CameraController cameraController){
    //only used to facilitate testing
    this.cameraController = cameraController;
  }

  void setCamerasList(List<CameraDescription> camList){
    //only used to facilitate testing
    camerasList = camList;
  }

  Future<void> initializeDefaultCamera() async {
    //initializes the default device camera
    camerasList = await availableCameras();
    final firstCamera = camerasList.first;
    camera = firstCamera;
    cameraController = CameraController(camera!, ResolutionPreset.high);
    await cameraController.initialize();
  }

  Future<void> disposeController() async {
    //disposes the camera controller
    cameraController.dispose();
  }

  Future<void> toggleCameraLens() async {
    //toggles camera lens (front/rear)
    // get current lens direction (front / rear)
    final lensDirection =  cameraController.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
        newDescription = camerasList.firstWhere((description) => description.lensDirection == CameraLensDirection.back);
    } else {
        newDescription = camerasList.firstWhere((description) => description.lensDirection == CameraLensDirection.front);
    }
    camera = newDescription;
    cameraController = CameraController(camera!, ResolutionPreset.high);
    await cameraController.initialize();
    }
}
