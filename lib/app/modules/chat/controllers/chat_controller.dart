import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {

  final userDb = FirebaseFirestore.instance.collection('users');
  RxBool loading = false.obs;
  final TextEditingController messageController = TextEditingController();
  RxMap userData = {}.obs;

  void loadProfile(id){
    loading.value = true;
    final docRef = userDb.doc(id);
    docRef.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        print(data);
        userData = data.obs;
        print("Data Stored $userData");
        // loading.value = false;
        print(loading.value);
      },
      onError: (e) {
        print("Error getting document: $e");
      },
    );
    // loading.value = false;
  }



  void handleMessageSubmit(id){
    final message = messageController.text ;

    if(message.trim().isEmpty){
      return ;
    }
    
    print(id);

    messageController.clear();
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
