import 'package:get/get.dart';

import '../controllers/local_authentication_controller.dart';

class LocalAuthenticationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocalAuthenticationController>(
      () => LocalAuthenticationController(),
    );
  }
}
