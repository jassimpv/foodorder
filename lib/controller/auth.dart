// ignore_for_file: unused_local_variable

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodorder/Screen/dashboard/dashboard.dart';
import 'package:foodorder/Screen/LoginScreen/Login.dart';
import 'package:foodorder/controller/login_controller.dart';
import 'package:foodorder/utility/utility.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication extends GetxController {
  var userdata;
  Rx<bool> isVerifyLoading = false.obs;
  Rx<String> verifyId = "".obs;

  late FirebaseAuth _auth;

  Future<FirebaseApp> initializeFirebase(
      {required BuildContext context}) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    _auth = FirebaseAuth.instance;
    var data = await sessionActive(context: context);
    userdata = data.obs;

    if (userdata.value != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Dashboard(
            user: userdata.value,
          ),
        ),
      );
    }
    return firebaseApp;
  }

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   Authentication.customSnackBar(
          //     content:
          //         'The account already exists with a different credential.',
          //   ),
          // );
        } else if (e.code == 'invalid-credential') {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   Authentication.customSnackBar(
          //     content: 'Error occurred while accessing credentials. Try again.',
          //   ),
          // );
        }
      } catch (e) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   Authentication.customSnackBar(
        //     content: 'Error occurred using Google Sign-In. Try again.',
        //   ),
        // );
      }
    }

    return user;
  }

  Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();

      await FirebaseAuth.instance.signOut();

      Get.offAll(() => Login());
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   Authentication.customSnackBar(
      //     content: 'Error signing out. Try again.',
      //   ),
      // );
    }
  }

  Future<User?> sessionActive({required BuildContext context}) async {
    User? user;
    try {
      user = FirebaseAuth.instance.currentUser;

      return user;
    } catch (e) {
      return user;
    }
  }

  Future<void> submitPhoneNumber(
      {required BuildContext context, number}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    log("sdfsf" + number);
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: '+91' + number,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          } else {
            print(e.code);
          }
        },
        codeSent: (String verificationId, int? resendToken) {},
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   Authentication.customSnackBar(
      //     content: 'Error signing out. Try again.',
      //   ),
      // );
    }
  }

  verifyPhoneNumber() async {
    isVerifyLoading.value = true;

    verificationFailed(FirebaseAuthException? authException) {
      Utility.showToast(msg: authException!.message.toString());

      Utility.applog(
          authException.code + " " + authException.message.toString());
    }

    codeSent(String verificationId, [int? forceResendingToken]) async {
      Utility.applog("codeSent");

      Utility.applog(verificationId);
      Utility.showToast(
          msg: "Please check your phone for the verification code.");
      verifyId.value = verificationId;
    }

    codeAutoRetrievalTimeout(String verificationId) {
      Utility.applog("codeAutoRetrievalTimeout");
      verifyId.value = verificationId;
    }

    verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
      Utility.applog("verificationCompleted");
    }

    await _auth
        .verifyPhoneNumber(
            phoneNumber: "+91" +
                Get.find<LoginController>().textEditingController.value.text,
            timeout: const Duration(seconds: 5),
            verificationCompleted: verificationCompleted,
            verificationFailed: verificationFailed,
            codeSent: codeSent,
            codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)
        .then((value) {
      Utility.applog("then");
    }).catchError((onError) {
      Utility.applog(onError);
    });

    isVerifyLoading.value = false;
  }

  signInWithPhoneNumber(String otp) async {
    isVerifyLoading.value = true;

    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verifyId.value,
        smsCode: otp,
      );
      final User? user = (await _auth.signInWithCredential(credential)).user;
      final User? currentUser = _auth.currentUser;
      assert(user!.uid == currentUser!.uid);

      isVerifyLoading.value = false;
      if (user != null) {
        Get.offAll(() => Dashboard(user: user));
      } else {
        Utility.showToast(msg: "Sign in failed");
      }
    } catch (e) {
      Utility.showToast(msg: e.toString());

      isVerifyLoading.value = false;
    }
  }
}
