import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SpaceController extends GetxController {
  final index = 0.obs;
  final Rx<bool> testStatus = true.obs;
  final Rx<bool> picture = false.obs;
  TextEditingController ?nameController = TextEditingController();
  late BuildContext context;
  late XFile file;
}
