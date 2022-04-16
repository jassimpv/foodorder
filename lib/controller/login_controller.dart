import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var isSigningInLoader = false.obs;
  var phoneButtonClick = false.obs;
  var textEditingController = TextEditingController().obs;
}
