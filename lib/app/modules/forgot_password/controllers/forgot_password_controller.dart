import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void sendEmail() async {
    if(emailC.text.isNotEmpty){ 
        isLoading.value = true;
      try {
        await auth.sendPasswordResetEmail(email: emailC.text);
        Get.snackbar("Yeay Berhasil", "Reset Email nya udah dikirim");
        Get.back();
      } catch (e) {
        Get.snackbar("Ada Yang Saalah", "Gabisa Kirim Reset Password");
      } finally {
        isLoading.value = false;
      }
    }
  }
}
