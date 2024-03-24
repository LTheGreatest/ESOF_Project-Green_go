import 'package:camera/camera.dart';

class CameraService {

  late List<CameraDescription> camerasList;
  CameraDescription? camera;
  late CameraController cameraController;

  Future<void> initializeDefaultCamera() async{
    camerasList = await availableCameras();
    final firstCamera = camerasList.first;
    camera = firstCamera;
    cameraController = CameraController(camera!, ResolutionPreset.high);
    await cameraController.initialize();
  }

  Future<void> disposeController() async{
    cameraController.dispose();
  }

  Future<void> toggleCameraLens() async {
  // get current lens direction (front / rear)
  final lensDirection =  cameraController.description.lensDirection;
  CameraDescription newDescription;
  if(lensDirection == CameraLensDirection.front){
      newDescription = camerasList.firstWhere((description) => description.lensDirection == CameraLensDirection.back);
  }
  else{
      newDescription = camerasList.firstWhere((description) => description.lensDirection == CameraLensDirection.front);
  }

    if(newDescription != null){
      camera = newDescription;
      cameraController = CameraController(camera!, ResolutionPreset.high);
      await cameraController.initialize();
    }
    else{
      print('Asked camera not available');
    }
  }
}