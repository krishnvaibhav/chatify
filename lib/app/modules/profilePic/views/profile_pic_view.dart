import 'package:chatify/app/constants/color_constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_pic_controller.dart';

class ProfilePicView extends GetView<ProfilePicController> {
  const ProfilePicView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.darkSecond,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
             ,
        ),
        centerTitle: true,
        backgroundColor: ColorConstants.darkSecond,
        foregroundColor: ColorConstants.light,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Obx(()=> Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                 CircleAvatar(
                      radius: 80,
                      backgroundColor: ColorConstants.lightOpacity,
                      foregroundImage: controller.pickedImageFile.value != null
                          ? FileImage(controller.pickedImageFile.value!)
                          : null,
                    ),
                const SizedBox(
                    height:
                        16), // Add some space between the CircleAvatar and the TextButton
                TextButton.icon(
                  onPressed: () {
                    controller.pickImage();
                  },
                  icon: const Icon(Icons.image),
                  label: Text(
                    "Add Image",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(
                    height:
                        16), // Add some space between the CircleAvatar and the TextButton
                _inputContainer(context, controller, "Name"),
                const SizedBox(
                    height:
                        16), // Add some space between the CircleAvatar and the TextButton
                _inputContainer(context, controller, "Bio"),
                const SizedBox(
                    height:
                        16), // Add some space between the CircleAvatar and the TextButton
                 controller.loading.value ? _loader(context) : _authButton(context, controller)
              ],
            ),
            )
          ),
        ),
      ),
    );
  }
}

Widget _inputContainer(
    BuildContext context, ProfilePicController controller, String hintText) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: TextFormField(
      onSaved: (newValue) {},
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: ColorConstants.light,
            decorationColor: ColorConstants.light,
          ),
      controller: hintText == "Name"
          ? controller.nameController
          : controller.bioController,
      cursorColor: ColorConstants.light,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
        hintStyle: const TextStyle(color: ColorConstants.light),
      ),
    ),
  );
}

Widget _authButton(BuildContext context, ProfilePicController controller) {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2))),
          backgroundColor: ColorConstants.primary),
      onPressed: () => {
        controller.saveProfile()
      },
      icon: const Icon(
        Icons.check,
        color: ColorConstants.light,
      ),
      label: Text(
        "Save",
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: ColorConstants.light,
            ),
      ),
    ),
  );
}


Widget _loader(BuildContext context) {
  return const Padding(
      padding: EdgeInsets.all(20),
      child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            backgroundColor: ColorConstants.light,
            color: ColorConstants.darkSecond,
          )));
}