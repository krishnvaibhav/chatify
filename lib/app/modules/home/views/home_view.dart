import 'package:chatify/app/constants/color_constants.dart';
import 'package:chatify/app/constants/text_theme.dart';
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

    return Scaffold(
      body: SliderDrawer(
        appBar: SliderAppBar(
          appBarHeight: 80,
          appBarColor: ColorConstants.darkSecond,
          drawerIconColor: ColorConstants.light,
          title: Text(
            TITLE,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: ColorConstants.light),
          ),
        ),
        key: controller.key,
        slider: _sliderContent(context, controller),
        sliderOpenSize: MediaQuery.of(context).size.width - 100,
        child: Container(),
      ),
    );
  }
}

Widget _sliderContent(context, HomeController controller) {
  return Container(
    color: ColorConstants.dark,
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
            ),
            const SizedBox(
              height: 15,
            ),
             Obx(() => Text(controller.name?.value ?? '')),
            const Divider(),
            _styledListTile(context, "Profile", Icons.person, controller,
                const ProfilePicView()),
            _styledListTile(context, "Settings", Icons.settings, controller,
                const ProfilePicView()),
            _styledListTile(
                context, "T/C", Icons.book, controller, const ProfilePicView()),
            _styledListTile(
                context, "Logout", Icons.logout, controller, LoginView()),
          ],
        ),
      ),
    ),
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
        controller.close();
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
