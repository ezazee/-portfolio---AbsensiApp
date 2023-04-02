import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    if(emailC.text.isNotEmpty && passC. text.isNotEmpty) {
      isLoading.value = true;
      try {
        final userCredential = await auth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );

        print(userCredential);

        if(userCredential.user != null){
          if(userCredential.user!.emailVerified == true) {
            isLoading.value = false;
            if(passC.text == "password"){
              Get.offAllNamed(Routes.NEW_PASSWORD);
            }else {
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            Get.defaultDialog(
              title: "Belum Ferivfikasi",
              middleText: "Belum Ferivikasi ya kamuuu yaaaa... feriv dlu sana",
              actions: [
                OutlinedButton(onPressed: () {
                  isLoading.value = false;
                  Get.back();
                }, child: Text("Cancel")),
                ElevatedButton(onPressed: () async { 
                    try {
                      await userCredential.user!.sendEmailVerification(); 
                      Get.back();
                      Get.snackbar("Berhasil Euy", "Email nya udah dikirim ya, cek email nya");
                      isLoading.value = false;
                    } catch (e) {
                    isLoading.value = false;
                    Get.snackbar("Ada Kejadian Yang Salah", "Lagi Gabisa Kirim Email Verif");
                    }
                  }, 
                  child: Text("Kirim Ulang")),
              ]
            );
          }
        }
        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (e.code == 'user-not-found') {
          Get.snackbar("Ada Yang Salah Nih", "Email Belum Terdaftar atuh!");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Ada Yang Salah Nih", "Password nya salah!");
        }
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Ada Yang Salah Nih", "Gabisa Login!");
      }
    } else {
      Get.snackbar("Ada Yang Salah Nih", "Email Password nya wajib diisi!");
    }
  }
}
