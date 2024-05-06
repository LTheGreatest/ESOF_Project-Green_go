import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:green_go/controller/camera/camera_service.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/profile_display_pictures_screen.dart';

class ProfileTakePictureScreen extends StatefulWidget {
  const ProfileTakePictureScreen({
    super.key,
  });

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<ProfileTakePictureScreen> {
  late CameraService cameraService;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    ///initializes the camera services (return future)
    cameraService = CameraService();
    _initializeControllerFuture = cameraService.initializeDefaultCamera();
  }
  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    cameraService.disposeController();
    super.dispose();
  }
  Widget buildTitle(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(35, 35, 35, 15),
      child: Text(
        "Profile Picture",
        style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w600
        ),
      ),
    );
  }
  Widget buildCameraFeed(BuildContext context) {
    double circleOverlaySize = MediaQuery.of(context).size.width * 0.7;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          // Container containing the camera feed
          child: Container(
            // The height is defined according to the screen size
            height: MediaQuery.of(context).size.height / 1.5,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.elliptical(10, 5)),
              color: lightGrey,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              // Calls the camera preview
              child: CameraPreview(cameraService.cameraController),
            ),
          ),
        ),
        // Circular overlay in the middle
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: circleOverlaySize,
              height: circleOverlaySize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget cameraSwitchButton(BuildContext context) {
    //button to switch camera lens
    return  Container(
      width: 120,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.elliptical(20, 15)),
        color: lightGrey,
      ),
      child: IconButton(
          onPressed: () async {
            //toggles camera lens and redraws the screen
            await cameraService.toggleCameraLens();
            setState(() {});
            },
          //switch camera icon
          icon: const Icon(
            Icons.cameraswitch_outlined,
            size: 30,
          )
      ),
    );
  }
  Widget takePictureButton(BuildContext context) {
    //button to take the picture
    return  Container(
      width: 120,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.elliptical(20, 15)),
        color: lightGrey,
      ),
      //button to take the picture
      child: IconButton(
          onPressed: () async{
            try {
              // Ensure that the camera is initialized.
              await _initializeControllerFuture;
              // Attempt to take a picture and get the file `image`
              // where it was saved.
              final image = await cameraService.cameraController.takePicture();
              if (!context.mounted) return;
              // If the picture was taken, display it on a new screen.
              await Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => ProfileDisplayPictureScreen(
                      // Pass the automatically generated path to
                      // the DisplayPictureScreen widget.
                      key: null,
                      imagePath: image.path,
                    ),
                      
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                )
              );
            } catch (e) {
              // If an error occurs, log the error to the console.
              if (kDebugMode) {
                print(e);
              }
            }
            },
          //camera icon
          icon: const Icon(
              Icons.camera_alt,
              size: 30
          )
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Column(
              children: [
                buildTitle(context),
                buildCameraFeed(context),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: cameraSwitchButton(context),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: takePictureButton(context),
                      ),
                    ]
                )
              ],
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
