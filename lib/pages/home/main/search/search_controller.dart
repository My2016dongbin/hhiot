import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SearchedController extends GetxController {
  final index = 0.obs;
  final Rx<bool> testStatus = true.obs;
  late BuildContext context;
  TextEditingController ?searchController = TextEditingController();
}
