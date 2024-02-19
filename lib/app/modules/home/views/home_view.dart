import 'package:chatify/app/constants/color_constants.dart';
import 'package:chatify/app/constants/text_theme.dart';
import 'package:chatify/app/modules/contacts/views/contacts_view.dart';
import 'package:chatify/app/modules/login/views/login_view.dart';
import 'package:chatify/app/modules/profilePic/views/profile_pic_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

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
       title:Text(
         TITLE,
         style: Theme.of(context)
             .textTheme
             .titleMedium!
             .copyWith(color: ColorConstants.light),
       ),
       leading: IconButton(onPressed: (){scaffoldKey.currentState?.openDrawer();}, icon: Icon(Icons.menu)),
       centerTitle: true,
     ),
        drawer: _drawer(context,controller),
      body: Container(color: ColorConstants.darkSecond,),
    );
  }
}


Widget _drawer(context,controller){
  return Drawer(
    child: _sliderContent(context, controller)
  );
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
                foregroundImage: NetworkImage(controller.userData['url']) ??
                    null,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(controller.name?.value ?? ''),
              const Divider(),
              _styledListTile(
                context,
                "Profile",
                Icons.person,
                controller,
                const ProfilePicView(),
              ),
              _styledListTile(
                context,
                "Settings",
                Icons.settings,
                controller,
                const ProfilePicView(),
              ),
              _styledListTile(
                context,
                "Contacts",
                Icons.contact_phone_sharp,
                controller,
                const ContactsView(),
              ),
              _styledListTile(
                context,
                "Logout",
                Icons.logout,
                controller,
                LoginView(),
              ),
            ],
          ),
        ),
      ),
    )
        : LinearProgressIndicator(),
  );
}


Widget _styledListTile(context, title, icon, HomeController controller, page) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ListTile(
      leading: Icon(
        icon,
        color: ColorConstants.light,
      ),
      onTap: () {
        title == "Logout" ? controller.logout() : (){};
        controller.closeDrawer(context);
        Get.to(page);
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


