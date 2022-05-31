import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagepicker/utils/button.dart';
import 'package:permission_handler/permission_handler.dart';
import '../video/videoPlayer.dart';

class PickImageVideo extends StatefulWidget {
  const PickImageVideo({Key? key}) : super(key: key);
  @override
  State<PickImageVideo> createState() => _PickImageVideoState();
}

class _PickImageVideoState extends State<PickImageVideo> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  // ignore: prefer_typing_uninitialized_variables
  XFile? _image;
  // ignore: prefer_typing_uninitialized_variables, unused_field
  var _video;
  // ignore: prefer_typing_uninitialized_variables
  var imagePicker;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

//Selecting multiple images from Gallery
  List<XFile>? imageFileList = [];
  void selectImages() async {
    var storageStatus = await Permission.storage.status;
    if (storageStatus.isDenied) {
      await Permission.camera.request();
      if (storageStatus.isGranted) {
        select();
      }
    } else if (storageStatus.isPermanentlyDenied) {
      CupertinoDialogAction(
        child: const Text('Open Settings to give Permission'),
        onPressed: () => openAppSettings(),
      );
    } else if (storageStatus.isGranted) {
      select();
    }
  }

  void select() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  }

  void pickImageFromGallery() async {
    //pickFromGallery();
    var storageStatus = await Permission.storage.status;
    if (kDebugMode) {
      print(storageStatus);
    }
    if (storageStatus.isGranted) {
      pickFromGallery();
    } else if (storageStatus.isDenied) {
      await Permission.storage.request();
      if (storageStatus.isGranted) {
        pickFromGallery();
      }
    } else if (storageStatus.isPermanentlyDenied) {
      CupertinoDialogAction(
        child: const Text('Open Settings to give Storage Permission'),
        onPressed: () => openAppSettings(),
      );
    }
  }

  void pickImageFromCamera() async {
    var camerastatus = await Permission.camera.status;
    if (camerastatus.isDenied) {
      await Permission.camera.request();
      if (camerastatus.isGranted) {
        captureImageWithCamera();
      }
    } else if (camerastatus.isPermanentlyDenied) {
      CupertinoDialogAction(
        child: const Text('Open Settings to give Permission'),
        onPressed: () => openAppSettings(),
      );
    } else if (camerastatus.isGranted) {
      captureImageWithCamera();
    }
  }

  void pickVideoFromGallery() async {
    var storageStatus = await Permission.storage.status;
    if (storageStatus.isDenied) {
      await Permission.storage.request();
      if (storageStatus.isGranted) {
        pickVideoGallery();
      }
    } else if (storageStatus.isPermanentlyDenied) {
      CupertinoDialogAction(
        child: const Text('Open Settings to give Permission'),
        onPressed: () => openAppSettings(),
      );
    } else if (storageStatus.isGranted) {
      pickVideoGallery();
    }
  }

  void pickVideoGallery() async {
    XFile _video = await imagePicker.pickVideo(
      source: ImageSource.gallery,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => VideoPlayerFromFile(
          videopath: _video.path,
        ),
      ),
    );
  }

  //Gallery

  pickFromGallery() async {
    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
    );
    setState(() {
      // ignore: unnecessary_statements
      imageXFile;
    });
  }

  captureImageWithCamera() async {
    imageXFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );
    setState(() {
      // ignore: unnecessary_statements
      imageXFile;
    });
  }

  void clearTakenImage() {
    imageXFile = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Image Picker",
          style: TextStyle(
            fontFamily: "VarelaRound",
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 74, 199, 93),
        // flexibleSpace: Container(
        //   decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [
        //         Color.fromARGB(255, 42, 187, 37),
        //         Color.fromARGB(255, 42, 187, 37),
        //       ],
        //     ),
        //   ),
        //   child: const Center(
        //     child: Text("Image Picker"),
        //   ),
        // ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Button(text: "FROM GALLERY", onPressed: pickImageFromGallery),
            Button(text: "FROM CAMERA", onPressed: pickImageFromCamera),
            Button(
                text: "Select video from Gallery",
                onPressed: pickVideoFromGallery),
            Button(text: "Select Multiple Images", onPressed: selectImages),
            const SizedBox(
              height: 20.0,
            ),
            // MaterialButton(
            //   color: Colors.blue,
            //   onPressed: () {
            //     pickImageFromCamera();
            //   },
            //   child: const Text('FROM CAMERA'),
            // ),
            // MaterialButton(
            //   color: Colors.blue,
            //   onPressed: () {
            //     pickVideoFromGallery();
            //   },
            //   child: const Text("Select video from Gallery"),
            // ),
            // MaterialButton(
            //   color: Colors.blue,
            //   onPressed: () {
            //      selectImages();
            //   },
            //   child: const Text('Select Multiple Images'),
            // ),
            Padding(
              padding: const EdgeInsets.only(
                right: 8.0,
                left: 8.0,
              ),
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(color: Colors.grey[200]),
                child: imageXFile != null
                    ? Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(
                              File(imageXFile!.path),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : const Center(
                        child: Text(
                          "Pick an image from gallery",
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: imageFileList!.length,
                  // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return Image.file(
                      File(imageFileList![index].path),
                      width: double.infinity,
                      height: 200,
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Padding customButton(String title, Function pressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 60.0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.orange,
          ),
          onPressed: () => pressed,
          child: Text(title),
        ),
      ),
    );
  }
}
