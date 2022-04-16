import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodorder/Screen/LoginScreen/verificationScreen.dart';
import 'package:foodorder/Screen/Widgets/Button.dart';
import 'package:foodorder/Screen/Widgets/loader.dart';
import 'package:foodorder/Screen/Widgets/texform.dart';
import 'package:foodorder/controller/auth.dart';
import 'package:foodorder/Screen/dashboard/dashboard.dart';
import 'package:foodorder/controller/login_controller.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);
  final loginController = Get.put(LoginController());
  final Authentication authController = Get.find();
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Image(
              image: AssetImage("assets/firebase.png"),
            ),
            Obx(() {
              return loginController.phoneButtonClick.value == true
                  ? Inputfield.textForm(
                      loginController.textEditingController.value)
                  : Container();
            }),
            FutureBuilder(
                future: authController.initializeFirebase(context: context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return GetX<LoginController>(builder: (_) {
                      if (loginController.phoneButtonClick.value == false &&
                          loginController.isSigningInLoader.value == false) {
                        return Column(
                          children: [
                            Button.loginButton(
                                tap: () async {
                                  loginController.isSigningInLoader.value =
                                      true;

                                  User? user = await authController
                                      .signInWithGoogle(context: context);

                                  loginController.isSigningInLoader.value =
                                      false;

                                  if (user != null) {
                                    Get.offAll(() => Dashboard(user: user));
                                  }
                                },
                                color: const [
                                  Color(0xff428bfe),
                                  Color(0xff428bfe)
                                ],
                                title: "Google",
                                icon: const CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.white,
                                  child: Image(
                                    height: 15,
                                    image: AssetImage("assets/Glogo.png"),
                                  ),
                                ),
                                size: size),
                            SizedBox(height: size.height * 0.02),
                            if (loginController.phoneButtonClick.isFalse)
                              Button.loginButton(
                                size: size,
                                tap: () {
                                  loginController.phoneButtonClick.value = true;
                                },
                                color: const [
                                  Color(0xff7ad759),
                                  Color(0xff56ba57)
                                ],
                                title: "Phone",
                                icon: const CircleAvatar(
                                    backgroundColor: Color(0xff7ad759),
                                    child: Icon(
                                      Icons.phone,
                                      color: Colors.white,
                                    )),
                              )
                          ],
                        );
                      } else if (loginController.isSigningInLoader.value ==
                          true) {
                        return Loader.cricle();
                      } else {
                        return Column(
                          children: [
                            Button.loginButton(
                              size: size,
                              tap: () {
                                String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                                RegExp regExp = RegExp(patttern);
                                if (loginController
                                    .textEditingController.value.text.isEmpty) {
                                  Get.snackbar(
                                    "Please enter mobile number",
                                    "",
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                } else if (regExp.hasMatch(loginController
                                    .textEditingController.value.text)) {
                                  loginController.isSigningInLoader.value =
                                      false;
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  Get.to(VerificationScreen(
                                    mobile: loginController
                                        .textEditingController.value.text,
                                    // countrycode: "+91",
                                  ));
                                } else {
                                  Get.snackbar(
                                    "Please enter valid mobile number",
                                    "",
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              },
                              color: const [
                                Color.fromARGB(255, 0, 0, 0),
                                Color.fromARGB(255, 0, 0, 0)
                              ],
                              title: "OTP",
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            InkWell(
                                onTap: () {
                                  loginController.phoneButtonClick.value =
                                      false;
                                },
                                child: const Text(
                                  "Back",
                                  style: TextStyle(fontSize: 20),
                                )),
                          ],
                        );
                      }
                    });
                  }
                  return Loader.cricle();
                }),
          ],
        ),
      ),
    );
  }
}
