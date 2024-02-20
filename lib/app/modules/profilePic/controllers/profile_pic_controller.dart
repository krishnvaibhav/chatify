import 'dart:io';
import 'package:chatify/app/modules/home/controllers/home_controller.dart';
import 'package:chatify/app/modules/home/views/home_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicController extends GetxController {

  final HomeController homeController = Get.put(HomeController());

  Rx<File?> pickedImageFile = Rx<File?>(null);
  RxBool loading = false.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  final userDb = FirebaseFirestore.instance.collection('users');



  void pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);

    if (pickedImage == null) {
      return;
    }

    pickedImageFile.value = File(pickedImage.path);
  }

    RxMap userData = {}.obs;


  void loadData() async {
    final id = FirebaseAuth.instance.currentUser?.uid;
    print(id);
    loading.value = true;
    final docRef = userDb.doc(id);
    docRef.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        print("DATA RECIEVED $data");
         userData = data.obs;
         nameController.text = userData["name"];
         bioController.text = userData["bio"];
         numberController.text = userData["number"];
        loading.value = false;
      },
      onError: (e) {
        print("Error getting document: $e");
      },
    );
    loading.value = false;
  }



  void saveProfile(context) async {
    final id = FirebaseAuth.instance.currentUser?.uid;
    print("Saving profile");
    try {
      loading.value = true;
      final name = nameController.text;
      final bio = bioController.text;
      final number = numberController.text;
      if(number != ""){
        if(pickedImageFile.value != null) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('user_images')
              .child("$id.jpg");
          await storageRef.putFile(pickedImageFile.value!);
          final url = await storageRef.getDownloadURL();
          await userDb.doc(id).update({'url': url, 'name': name, 'bio': bio,'number': "+91$number"});
          print("DATA WRITTEN");
        }
        else{
          await userDb.doc(id).update({'name': name, 'bio': bio,'number': "+91$number"});
          print("DATA WRITTEN");
        }
        loading.value = false;
        loadData();
        homeController.loadData();
        Get.to(() => const HomeView());
      }
      else{
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter your number")));
      }

    } catch (err) {
      print("ERROR $err");
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
    if(FirebaseAuth.instance.currentUser != null) {
    loadData();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
