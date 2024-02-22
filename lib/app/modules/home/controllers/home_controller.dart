import 'package:chatify/app/modules/login/views/login_view.dart';
import 'package:chatify/app/modules/profilePic/views/profile_pic_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxString? name;

  final userDb = FirebaseFirestore.instance.collection('users');
  RxBool loading = false.obs;
  RxMap userData = {}.obs;
  RxBool alert = false.obs;

  void loadData() async {
    final id = FirebaseAuth.instance.currentUser?.uid;
    loading.value = true;
    final docRef = userDb.doc(id);
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        print("DATA RECIEVED $data");
        userData = data.obs;
        loading.value = false;
      },
      onError: (e) {
        print("Error getting document: $e");
      },
    );
    loading.value = false;
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  void toggleAlert() {
    alert.value = !alert.value;
  }

  void loadChats(){

  }

  void deleteUser(context) async {
    final id = FirebaseAuth.instance.currentUser!.uid;
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('user_images/$id.jpg');
      await storageRef.delete();
      print("Storage cleared");
    } catch (err) {
      print(err);
    }
    try {
      final firestoreRef = FirebaseFirestore.instance.collection('users').doc(
          id);
      await firestoreRef.delete();
      print("Firestore cleared");
      await FirebaseAuth.instance.currentUser!.delete();
      print("Auth cleared");
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Account Deleted")));
      Get.to(()=>LoginView());
    }catch(err){
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Could not delete user")));
    }
  }

  void loadEmail() {
    name = FirebaseAuth.instance.currentUser?.email!.obs;
  }

  void closeDrawer(context) {
    navigator?.pop(context);
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    if (FirebaseAuth.instance.currentUser != null) {
      print("loading user");
      loadData();
      loadEmail();
      if (userData["number"] == "") {
        Get.to(() => const ProfilePicView());
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
