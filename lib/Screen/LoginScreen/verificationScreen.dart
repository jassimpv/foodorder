import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodorder/Screen/Widgets/Button.dart';
import 'package:foodorder/Screen/Widgets/loader.dart';

import 'package:foodorder/controller/auth.dart';
import 'package:foodorder/utility/appColors.dart';

import 'package:foodorder/utility/utility.dart';
import 'package:get/get.dart';

import '../dashboard/dashboard.dart';

class VerificationScreen extends StatefulWidget {
  final String mobile;
  VerificationScreen({
    required this.mobile,
  });
  @override
  _VerificationScreenPageState createState() => _VerificationScreenPageState();
}

class _VerificationScreenPageState extends State<VerificationScreen> {
  TextEditingController controller1 = TextEditingController();

  Authentication controller = Get.find();

  @override
  void initState() {
    super.initState();

    controller.verifyPhoneNumber();
  }

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.blackColor,
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: AppColors.whiteColor,
      ),
      body: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    "An SMS with the verification code has been sent to your registered  mobile number",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.greyText,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Visibility(
                  visible: widget.mobile == null ? false : true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.mobile,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.greyText,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.edit),
                        color: AppColors.greyText,
                        iconSize: 20,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Center(
                  child: Text(
                    "Enter 6 digits code",
                    style: TextStyle(
                      color: AppColors.greyText,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 100.0, right: 100.0),
                child: TextFormField(
                  style: TextStyle(fontSize: 16, color: AppColors.greyText),
                  controller: controller1,
                  maxLength: 10,
                  decoration: InputDecoration(
                    label: const Text("OTP"),
                    counterText: "",
                    hintStyle: TextStyle(color: AppColors.greyText),
                  ),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Button.loginButton(
                  size: size,
                  color: const [
                    Color.fromARGB(255, 0, 5, 14),
                    Color.fromARGB(255, 17, 18, 19)
                  ],
                  tap: () {
                    controller.signInWithPhoneNumber(controller1.text);
                  },
                  title: "Continue"),
              // InkWell(
              //   onTap: () {
              //     Get.back();
              //   },
              //   child: Container(
              //     alignment: Alignment.center,
              //     padding: const EdgeInsets.only(top: 6),
              //     child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: <Widget>[
              //         const Spacer(),
              //         Text(
              //           "Didn't receive SMS? ",
              //           style: TextStyle(
              //             color: AppColors.greyText,
              //             fontSize: 16,
              //           ),
              //         ),
              //         Text(
              //           "Resend",
              //           style: TextStyle(
              //             color: AppColors.greyText,
              //             fontSize: 16,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         const Spacer(),
              //       ],
              //     ),
              //   ),
              // ),
              Obx(() {
                return controller.isVerifyLoading.value
                    ? Loader.cricle()
                    : Container();
              })
            ],
          ),
        ),
      ),
    );
  }
}
