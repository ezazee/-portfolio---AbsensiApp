import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPegawaiController extends GetxController {
    RxBool isLoading = false.obs;
    RxBool isLoadingAddPegawai = false.obs;
    TextEditingController nameC = TextEditingController();
    TextEditingController nipC = TextEditingController();
    TextEditingController emailC = TextEditingController();
    TextEditingController jobC = TextEditingController();
    TextEditingController passAdminC = TextEditingController();

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prosesAddPegawai() async {
    if(passAdminC.text.isNotEmpty){
      isLoadingAddPegawai.value = true;
      try{
      String emailAdmin = auth.currentUser!.email!;

      UserCredential userCredentialAdmin = await auth.signInWithEmailAndPassword(email: emailAdmin, password: passAdminC.text);
      
        UserCredential pegawaiCredential = await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password"
        );

        if(pegawaiCredential.user != null){
          String uid = pegawaiCredential.user!.uid;
          bool emailVerified = pegawaiCredential.user!.emailVerified;

          await firestore.collection("pegawai").doc(uid).set({
            "nip": nipC.text,
            "name": nameC.text,
            "email": emailC.text,
            "job": jobC.text,
            "uid": uid,
            "role": "pewagai",
            "createdAt": DateTime.now().toIso8601String(),
            "emailVerified": emailVerified,
          });

          await pegawaiCredential.user!.sendEmailVerification();

          await auth.signOut();

          UserCredential userCredentialAdmin = await auth.signInWithEmailAndPassword(email: emailAdmin, password: passAdminC.text);

          Get.back();
          Get.back();
          Get.snackbar("Yeay Berhasil", "Data pegawai sudah ditambahkan");
        }
          isLoadingAddPegawai.value = false;


      } on FirebaseAuthException catch (e) {
        isLoadingAddPegawai.value = false;
        if(e.code == 'password-lemah') {
          Get.snackbar("Ada Yang Salah Nih!", "Password Yang Digunakan Singkat banget 😠");
        } else if(e.code == 'email-sudah-dipakai') {
          Get.snackbar("Ada Yang Salah Nih!", "Pegawai itu udah ada, gaboleh nambah akun yang sama! 😠");
        } else if(e.code == 'wrong-password') {
          Get.snackbar("Ada Yang Salah Nih!", "Password Admin nya salah ! 😠");
        } else {
          Get.snackbar("Ada Yang Salah Nih!", "${e.code}");
        }
      } catch (e){
        isLoadingAddPegawai.value = false;
        Get.snackbar("Ada Yang Salah Nih!", "Lagi Gabisa Nambah Pegawai😠");
      }
    } else {
      isLoading.value == false;
      Get.snackbar("Ada yang salah!", "Password Wajib Diisi YGY");
    }
  }
    
  Future<void> addPegawai() async {
    if(nameC.text.isNotEmpty && nipC.text.isNotEmpty && emailC.text.isNotEmpty && jobC.text.isNotEmpty){
      isLoading.value = true;
        Get.defaultDialog(
          title: "Validasi Admin",
          content: Column(
            children: [
              Text("Masukan Password Kamu untuk validasi"),
              SizedBox(height: 10),
              TextField(
                controller: passAdminC,
                autocorrect: false,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              )
            ],
          ),
          actions: [
            OutlinedButton(onPressed: () {
              isLoading.value = false;
              Get.back();
            }, child: Text("Cancel")),
            Obx(
              () => ElevatedButton(onPressed: () async {
                if(isLoadingAddPegawai.isFalse){
                  await prosesAddPegawai();
                }
                  isLoading.value == false;
              }, child: Text( isLoadingAddPegawai.isFalse ?  "Tambah Pegawai" : "Loading...")),
            ),
          ]
        );
    } else {
      Get.snackbar("Ada Yang Salah Nih!", "NIP, Nama, Job dan email harus diisi");
    }
  }
}
