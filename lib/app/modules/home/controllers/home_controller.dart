import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {




  RxString? name;

  final userDb = FirebaseFirestore.instance.collection('users');
  RxBool loading = false.obs;
  RxMap userData = {}.obs;



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
    if(FirebaseAuth.instance.currentUser != null) {
      print("loading user");
      loadData();
      loadEmail();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
