import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController curC = TextEditingController();
  TextEditingController newC = TextEditingController();
  TextEditingController confirC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void updatePass() async {
    if(curC.text.isNotEmpty && newC.text.isNotEmpty && confirC.text.isNotEmpty){
      if(newC.text == confirC.text){
        isLoading.value = true;
        try {
          String emailUser = auth.currentUser!.email!;

          await auth.signInWithEmailAndPassword(email: emailUser, password: curC.text);

          await auth.currentUser!.updatePassword(newC.text);

          Get.back();
          
          Get.snackbar("Yeay Berhasil", "Passwordnya udah di update");
        } on FirebaseAuthException catch (e) {
          if(e.code == "wrong-password"){
            Get.snackbar("Ada Yang Salah", "Password lama yang dimasukan Salah!");
          } else {
            Get.snackbar("Ada Yang Salah", "${e.code.toLowerCase()}");
          }
        } catch (e) {
          Get.snackbar("Ada Yang Salah", "Gabisa Update Password euy");
        } finally{
          isLoading.value = false;
        }
      } else {
      Get.snackbar("Ada Yang Salah", "Konfirmasi Password Harus sama");
    }
    } else {
      Get.snackbar("Ada Yang Salah", "Semua Input kudu diisi");
    }
  }
}
