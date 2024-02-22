import 'package:chatify/app/modules/chat/controllers/chat_controller.dart';
import 'package:chatify/app/modules/chat/views/chat_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactsController extends GetxController {
  RxList<Map<String, String>> contacts = <Map<String, String>>[].obs;
  RxList<Map<String, String>> filteredContacts = <Map<String, String>>[].obs;


  void getContacts() async {
    if (await FlutterContacts.requestPermission()) {
      contacts.clear();

      List<Contact> fetchedContacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
      );

      for (Contact contact in fetchedContacts) {
        String name = contact.displayName ?? '';
        String normalizedNumber = contact.phones.isNotEmpty
            ? contact.phones[0].normalizedNumber ?? ''
            : '';

        Map<String, String> contactData = {
          'name': name,
          'normalizedNumber': normalizedNumber,
        };

        contacts.add(contactData);
      }

      // Initially, set filteredContacts to all contacts
      filteredContacts.assignAll(contacts);
      print(contacts);
    }
  }


  final TextEditingController searchController = TextEditingController();

  Future<String> doesUserExist(String phoneNumber) async {
    // Assuming you have a Firestore collection called "users"
    final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
    try {
      // Get documents where the 'phoneNumber' field matches the provided phone number
      QuerySnapshot querySnapshot = await usersCollection.where('number', isEqualTo: phoneNumber).get();
      // Check if any document matches the query
      if(querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs[0].id;
      }else{
        return "";
      }
    } catch (e) {
      // Handle any errors (e.g., network issues, Firestore exceptions)
      print("Error checking user existence: $e");
      return "Error checking user existence";
    }
  }

  final ChatController chatController = ChatController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getContacts();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void handleGotUser(String id) async{
    Get.to(()=>ChatView(id: id));
  }
}
