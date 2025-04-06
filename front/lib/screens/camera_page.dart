
// ignore_for_file: avoid_print

import 'package:bitakati_app/controllers/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  late List<CameraDescription> cameras;
  late Future<void> _initializeControllerFuture;
  bool _isCameraInitialized = false;
  bool _isRearCameraSelected = true;
  final ChatController chatController = Get.find<ChatController>();
  
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      
      // Select the appropriate camera based on _isRearCameraSelected
      _cameraController = CameraController(
        cameras.firstWhere(
          (camera) => camera.lensDirection == 
            (_isRearCameraSelected 
              ? CameraLensDirection.back 
              : CameraLensDirection.front),
          orElse: () => cameras.first,
        ),
        ResolutionPreset.medium,
      );

      _initializeControllerFuture = _cameraController.initialize();
      await _initializeControllerFuture;
      
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  Future<void> _takePicture() async {
    try {
      // Ensure camera is initialized
      await _initializeControllerFuture;
      
      // Take the picture
      final XFile photo = await _cameraController.takePicture();
      
      // Get the file path
      final String filePath = photo.path;
      
      // Return to previous screen with the image path
      Get.back(result: filePath);
      
      // Optionally, you can also pass the image to your chat controller
      // chatController.handleCapturedImage(filePath);
      
    } catch (e) {
      print("Error taking picture: $e");
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الكاميرا'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            color: const Color.fromARGB(255, 78, 186, 83),
            height: 1.5,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green[300],
              borderRadius: BorderRadius.circular(10),
              shape: BoxShape.rectangle,
            ),
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isCameraInitialized
                ? FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return SizedBox(
                          width: double.infinity,
                          child: CameraPreview(_cameraController),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  )
                : const Center(
                    child: Text(
                      'جاري تحميل الكاميرا...',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Camera capture button
                GestureDetector(
                  onTap: _takePicture,
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(255, 135, 130, 130),
                        width: 2,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                // Camera flip button
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isRearCameraSelected = !_isRearCameraSelected;
                    });
                    _initializeCamera();
                  },
                  icon: const Icon(Icons.flip_camera_ios),
                  color: Colors.white,
                  iconSize: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}