import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ph_login/widget/snackbar.dart';

Future<File?> pickImage(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(context, e.toString());
  }
  return image;
}

//
Future<File?> pickImageCamera(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(context, e.toString());
  }
  return image;
}

//
Future<File?> pickVideo(BuildContext context) async {
  File? video;
  try {
    final pickedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      video = File(pickedVideo.path);
    }
  } catch (e) {
    showSnackBar(context, e.toString());
  }
  return video;
}

Future<File?> pickFiles(BuildContext context) async {
  // File? docs;
//  FilePickerResult? docs;
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  File? f;
  try {
    if (result != null) {
      //File file = File(result.files.single.path);
      f = File(result.files.single.path.toString());
    } else {
      // User canceled the picker
    }
    // final FilePickerResult? docs = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['pdf', 'doc'],
    // );
  } catch (e) {
    showSnackBar(context, e.toString());
  }
  return f;
}
