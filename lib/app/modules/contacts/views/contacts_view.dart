import 'package:chatify/app/constants/color_constants.dart';
import 'package:chatify/app/modules/chat/views/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/contacts_controller.dart';

class ContactsView extends GetView<ContactsController> {
  const ContactsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.darkSecond,
      appBar: AppBar(
        backgroundColor: ColorConstants.darkSecond,
        foregroundColor: ColorConstants.light,
        title: const Text('Contacts'),
        centerTitle: true,
      ),
      body: Obx(
        () => Column(
          children: [
            _searchBar(context, controller),
            Expanded(
              child: ListView.builder(
                  itemCount: controller.contacts.length,
                  itemBuilder: (context, index) {
                    Map<String, String> contact = controller.contacts[index];
                    return Visibility(
                      visible: contact["name"]!.toLowerCase().contains(
                          controller.searchController.text.toLowerCase()),
                      child: InkWell(
                        onTap: () async {
                          // Handle tap on the item if needed
                          final id = await controller.doesUserExist(contact["normalizedNumber"]!);
                          if(id.isEmpty){
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${contact["name"]} does not use Chatify 😢")));
                          }else{
                           controller.handleGotUser(id);
                          }
                          print(id);
                        },
                        child: Ink(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            // Your container content goes here
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  Text(contact["name"]!),
                                  const Spacer(),
                                  Text(contact["normalizedNumber"]!)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.getContacts();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }

  Widget _searchBar(context, ContactsController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: ColorConstants.light),
      // color: ColorConstants.light,
      child: Row(
        children: [
          Expanded(
              child: TextFormField(
            controller: controller.searchController,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(hintText: "Search"),
          )),
          Icon(Icons.search)
        ],
      ),
    );
  }
}
