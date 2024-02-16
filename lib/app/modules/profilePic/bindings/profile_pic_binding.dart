import 'package:get/get.dart';

import '../controllers/profile_pic_controller.dart';

class ProfilePicBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilePicController>(
      () => ProfilePicController(),
    );
  }
}
