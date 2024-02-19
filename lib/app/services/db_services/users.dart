import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserDatabase extends GetxController{

  final userDb = FirebaseFirestore.instance.collection('users');
  final id = FirebaseAuth.instance.currentUser!.uid;

  void loadData() async{
    final docRef = userDb.doc(id);
    docRef.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        print("DATA RECIEVED $data");
        return data;
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

}