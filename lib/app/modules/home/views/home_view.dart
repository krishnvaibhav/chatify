import 'package:chatify/app/constants/color_constants.dart';
import 'package:chatify/app/modules/contacts/views/contacts_view.dart';
import 'package:chatify/app/modules/login/views/login_view.dart';
import 'package:chatify/app/modules/profilePic/views/profile_pic_view.dart';
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

Widget _userCardList(RxList idList, controller) {
  return idList.length != 0
      ? ListView.builder(
          itemCount: idList.length,
          itemBuilder: (context, index) {
            return _userCard(idList[index], controller);
          },
        )
      : Center(child: Text("No cards"));
}

Widget _userCard(id, controller) {
  return Text(
    id,
    style: TextStyle(color: Colors.white),
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
                          )
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
