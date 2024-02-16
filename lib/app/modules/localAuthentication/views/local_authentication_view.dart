import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/local_authentication_controller.dart';

class LocalAuthenticationView extends GetView<LocalAuthenticationController> {
  const LocalAuthenticationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LocalAuthenticationView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'LocalAuthenticationView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
