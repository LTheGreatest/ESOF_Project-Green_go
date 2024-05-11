import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:green_go/controller/camera/camera_service.dart';
import 'package:green_go/view//constants.dart';
import 'package:green_go/view/pages/display_pictures_screen.dart';
import 'package:green_go/view/pages/trip_page.dart';
import 'package:green_go/view/widgets/problem_widget.dart';
import 'package:green_go/view/widgets/subtitle_widget.dart';
import 'package:green_go/view/widgets/title_widget.dart';
import 'package:green_go/model/transport_model.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.isStarting,
    required this.distance,
    required this.transport,
  });
  final bool isStarting;
  final double distance;
  final TransportModel transport;
  

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraService cameraService;
  late Future<void> _initializeControllerFuture;
  bool hasWaitedTooLong = false;

  @override
  void initState() {
    super.initState();
    ///initializes the camera services (return future)
    cameraService = CameraService();
    _initializeControllerFuture = cameraService.initializeDefaultCamera();
     Future.delayed(const Duration(seconds: 10),(){
        hasWaitedTooLong = true;
    });
  }
  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    cameraService.disposeController();
    super.dispose();
  }
  Widget buildSubtitle(BuildContext context) {
    //the subtitle may be different depending on the context
    return widget.isStarting? 
          const SubtitleWidget(text: "Take a Picture of your start location") :
          const SubtitleWidget(text:  "Take a Picture of your end location");
  }
  Widget buildCameraFeed(BuildContext context) {
    return Container(
      //the height is defined accordingly to the screen size
        height: MediaQuery.of(context).size.height / 1.5,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.elliptical(10, 5)),
          color: lightGrey,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          //calls the camera preview
          child: CameraPreview(cameraService.cameraController),
        )
    );
  }
  Widget cameraSwitchButton(BuildContext context){
    //button to switch camera lens
    return Container(
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
            size: 40,
          )
      ),
    );
  }
  Widget takePictureButton(BuildContext context) {
    //Button to take the picture
    return Container(
      width: 120,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.elliptical(20, 15)),
        color: lightGrey,
      ),
      //button to take the picture
      child: IconButton(
          onPressed: () async {
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
                    pageBuilder: (context, animation, secondaryAnimation) =>  
                          DisplayPictureScreen(
                            // Pass the automatically generated path to
                            // the DisplayPictureScreen widget.
                            key: null,
                            imagePath: image.path,
                            isStarting: widget.isStarting,
                            distance: widget.distance,
                            transport: widget.transport,
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
              size: 40
          )
      ),
    );
  }
  Widget waitedTooLong(BuildContext context) {
    //Widget that appears if the 
    return Center(
      child: Column(
        children: [
          const ProblemWidget(text: "Cannot initialize your camera. Please verify that you have the right permissions to access the camera."),
          Padding(
            padding: const EdgeInsets.all(50),
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TripPage()));
                },
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Color.fromARGB(248, 82, 83, 85)),
                  minimumSize: MaterialStatePropertyAll(Size(150, 50))
              ),
              child: const Text("Cancel",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ],
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
                const Padding(
                  padding: EdgeInsets.fromLTRB(35, 35, 35, 15),
                  child: TitleWidget(text:"Verification"),
                ),
                buildSubtitle(context),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildCameraFeed(context),
                ),
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
            // Otherwise, display a loading indicator. If the future takes to long to complete a error message appears on the screen
            return hasWaitedTooLong? waitedTooLong(context): const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
