import 'package:chatify/app/constants/color_constants.dart';
import 'package:chatify/app/modules/chat/controllers/chat_controller.dart';
import 'package:chatify/app/modules/chat/views/chat_view.dart';
import 'package:chatify/app/modules/contacts/views/contacts_view.dart';
import 'package:chatify/app/modules/login/views/login_view.dart';
import 'package:chatify/app/modules/profilePic/views/profile_pic_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:chatify/app/constants/text_constants.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: ColorConstants.darkSecond,
          foregroundColor: ColorConstants.light,
          title: Text(
            TITLE,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: ColorConstants.light),
          ),
          leading: IconButton(
              onPressed: () {
                scaffoldKey.currentState?.openDrawer();
              },
              icon: Icon(Icons.menu)),
          centerTitle: true,
        ),
        drawer: _drawer(context, controller),
        body: Obx(() => Container(
              color: ColorConstants.darkSecond,
              child: !controller.loading.value
                  ? _userCardList(controller.idList, controller)
                  : CircularProgressIndicator(),
            )));
  }
}

Widget _userCardList(otherUserId, HomeController controller) {
  return StreamBuilder(
    stream: controller.getUserChats(otherUserId),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text("Error: ${snapshot.error}");
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Text("Please wait.....");
      }

      return snapshot.data!.docs.isNotEmpty
          ? ListView(
              children: snapshot.data!.docs
                  .map((e) => _userCard(controller, e.data()))
                  .toList(),
            )
          : const Center(child: Text("No chats Yet"));
    },
  );
}

Widget _userCard(HomeController controller, data) {
  String? idValue = data["id"];
  print(idValue);
  return FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance.collection('users').doc(idValue).get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator(); // or some loading indicator
      }

      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }

      if (!snapshot.hasData || !snapshot.data!.exists) {
        return Container(); // User not found or data doesn't exist
      }

      return _userCardDesign(
        snapshot.data?["name"] ?? "",
        snapshot.data?["url"] ?? "",
        idValue!,
        controller,
      );
    },
  );
}

Widget _userCardDesign(String name, String profileImage, String otherUserId,
    HomeController controller) {
  return InkWell(
    onTap: () {
      Get.to(() => ChatView(id: otherUserId));
    },
    child: Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          CircleAvatar(
            foregroundImage: NetworkImage(profileImage),
            radius: 30,
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                StreamBuilder(
                  stream: controller.getLastMessage(
                    FirebaseAuth.instance.currentUser!.uid,
                    otherUserId,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Please wait...");
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      return Text(
                        "No message yet...",
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorConstants.lightOpacity,
                        ),
                      );
                    }

                    var lastMessageData = snapshot.data!.docs[0].data();
                    return _lastMessage(lastMessageData);
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.circle,
              color: ColorConstants.online,
              size: 14,
            ),
          )
        ],
      ),
    ),
  );
}

Widget _lastMessage(e) {
  return Text(
    e["message"],
    style: TextStyle(fontSize: 12, color: ColorConstants.lightOpacity),
  );
}

Widget _drawer(context, controller) {
  return Drawer(child: _sliderContent(context, controller));
}

Widget _sliderContent(context, HomeController controller) {
  return Obx(
    () => controller.userData.isNotEmpty
        ? Container(
            color: ColorConstants.dark,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 10,
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      foregroundImage: controller.userData["url"] != ""
                          ? NetworkImage(controller.userData['url'])
                          : null,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(controller.name?.value ?? ''),
                    const Divider(),
                    _styledListTile(context, "Profile", Icons.person,
                        controller, const ProfilePicView(), () {}),
                    _styledListTile(context, "Settings", Icons.settings,
                        controller, const ProfilePicView(), () {}),
                    _styledListTile(
                        context,
                        "Contacts",
                        Icons.contact_phone_sharp,
                        controller,
                        const ContactsView(),
                        () {}),
                    _styledListTile(context, "Logout", Icons.logout, controller,
                        LoginView(), () {
                      controller.logout();
                    }),
                    !controller.alert.value
                        ? _styledListTile(
                            context,
                            "Delete Account",
                            Icons.delete,
                            controller,
                            (),
                            () => controller.toggleAlert())
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            ColorConstants.darkSecond),
                                    onPressed: () {
                                      controller.toggleAlert();
                                      controller.deleteUser(context);
                                    },
                                    child: Text(
                                      "Delete",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: Colors.red),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            ColorConstants.darkSecond),
                                    onPressed: () {
                                      controller.toggleAlert();
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: ColorConstants.light),
                                    )),
                              )
                            ],
                          ),
                  ],
                ),
              ),
            ),
          )
        : Center(
            child: Text("Data loading..."),
          ),
  );
}

Widget _styledListTile(
    context, title, icon, HomeController controller, page, Function onClick) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ListTile(
      leading: Icon(
        icon,
        color: ColorConstants.light,
      ),
      onTap: () {
        onClick();
        title != "Delete Account" ? controller.closeDrawer(context) : () {};
        title != "Delete Account" ? Get.to(page) : () {};
      },
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: ColorConstants.light),
      ),
    ),
  );
}
