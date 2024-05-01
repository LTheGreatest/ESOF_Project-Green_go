# Problem about unit testing the features camera and location

  We are having trouble making unit tests for the camera and location features. The fact is that the functions of these services use other functions that are basically impossible to mock.
  
  For example, in the [camera_service.dart](src/green_go/lib/controller/camera/camera_service.dart) (line 18), we can't mock the *AvailableCameras* function, because it is a function already built and it's not in a class.
  
  In the location services, the functions are not possible to be called from an object location. It needs to be a class itself.
  
  For this reason, the tests wouldn't be unit, but integration. Therefore, we will try hard on find a way to produce some kind of testing these external services.
