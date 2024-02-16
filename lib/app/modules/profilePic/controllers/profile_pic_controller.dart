import 'dart:io';

import 'package:chatify/app/modules/home/views/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicController extends GetxController {
  Rx<File?> pickedImageFile = Rx<File?>(null);
  RxBool loading = false.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  void pickImage() async {
    final picked_image = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);

    if (picked_image == null) {
      return;
    }

    pickedImageFile.value = File(picked_image.path);
  }

  void saveProfile() async {
    loading.value = true;
    final name = nameController.text;
    final bio = bioController.text;
    final id = FirebaseAuth.instance.currentUser!.uid;
    if (name != "" && bio != "" && pickedImageFile != null) {
      print("$name $bio");
      final storageRef =
          FirebaseStorage.instance.ref().child('user_images').child("$id.jpg");
      await storageRef.putFile(pickedImageFile.value!);
      final url = await storageRef.getDownloadURL();
      print(url);
      nameController.text = "";
      bioController.text = "";
      Get.to(()=>const HomeView());
    }
    loading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
