import 'package:chatify/app/constants/color_constants.dart';
import 'package:chatify/app/constants/text_constants.dart';
import 'package:chatify/app/modules/contacts/views/contacts_view.dart';
import 'package:chatify/app/modules/home/views/home_view.dart';
import 'package:chatify/app/modules/login/views/login_view.dart';
import 'package:chatify/app/modules/music/views/music_view.dart';
import 'package:chatify/app/modules/profilePic/views/profile_pic_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      backgroundColor: ColorConstants.darkSecond,
        appBar: AppBar(
          key: scaffoldKey,
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
        body: Obx(()=>Column(
          children: [
            Obx(() => Row(
              children: [
                _styledTab(context, "chats", () {}),
                _styledTab(context, "songs", () {})
              ],
            ),),
             Expanded(child: Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: controller.screen.value == "chats" ? const HomeView() : const MusicView() ,
            ))
          ],
        )));
  }

  Widget _styledTab(context, String text, Function onTap) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return ElevatedButton(
      onPressed: () => controller.toggleScreen(),
      style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.dark,
          shape: const BeveledRectangleBorder(),
          fixedSize: Size(width * 50 / 100, height * 6 / 100)),
      child: Text(
        text,
        style: TextStyle(color: text == controller.screen.value ? ColorConstants.light : ColorConstants.lightOpacity ),
      ),
    );
  }

  Widget _drawer(context, controller) {
    return Drawer(child: _sliderContent(context, controller));
  }

  Widget _sliderContent(context, MainController controller) {
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
                      _styledListTile(context, "Logout", Icons.logout,
                          controller, LoginView(), () {
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
      context, title, icon, MainController controller, page, Function onClick) {
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
}
