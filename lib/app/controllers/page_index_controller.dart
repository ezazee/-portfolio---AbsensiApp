import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence/app/routes/app_pages.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void gantiPage(int i) async {
    switch (i) {
      case 1: 
        Map<String, dynamic> dataResponse =  await determinePosition();
        if(dataResponse["error"] != true){
          Position position = dataResponse["position"];

          List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
          String address = "${placemarks[0].street}" "${placemarks[0].locality}" "${placemarks[0].administrativeArea}";
          await updatePosition(position, address);

          double distance = Geolocator.distanceBetween(-6.2633822, 106.841907, position.latitude, position.longitude);

          await presensi(position, address, distance); 
          
          // 
        } else{
          Get.snackbar("Ada yang salah", dataResponse["message"]);
        }
        break;
      case 2:
        pageIndex.value = i;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default: Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> presensi(Position position, String address, double distance ) async {
    String uid = await auth.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> colAbsen = await firestore.collection("pegawai").doc(uid).collection("absensi");

    QuerySnapshot<Map<String, dynamic>> snapAbsen = await colAbsen.get();

    // snapAbsen.docs
    DateTime now = DateTime.now();
    String todayDocID = DateFormat.yMd().format(now).replaceAll("/", "-");

    String status = "Di Luar Area";

    if(distance <= 200){
      status = "Di Dalam Area";
    } 

if(snapAbsen.docs.length == 0){
    await Get.defaultDialog(
      title: "Validasi Absen",
      middleText: "Apakah Kamu Yakin Untuk Absen ( Masuk ) Sekarang ?",
      actions: [
        OutlinedButton(onPressed: () => Get.back(), child: Text("Cancel")),
        ElevatedButton(
          onPressed: () async {
              await colAbsen.doc(todayDocID).set({
                "date": now.toIso8601String(),
                "masuk": {
                "date": now.toIso8601String(),
                "lat": position.latitude,
                "long": position.longitude,
                "address": address,
                "status": status,
                "distance": distance,
              }
            });
            Get.back();
            Get.snackbar("Yay Berhasil", "Kamu udah absen ( Masuk )");
          }, 
          child: Text("Iya"))
      ],
    );
    } else{
      DocumentSnapshot<Map<String, dynamic>> todayDoc = await colAbsen.doc(todayDocID).get();

      if(todayDoc.exists == true){
        Map<String, dynamic>? dataAbsenToday = todayDoc.data();
        if(dataAbsenToday?["keluar"] != null){
          Get.snackbar("Yeay Sukses", "Kamu Telah absen masuk dan keluar");
        } else {
          await Get.defaultDialog(
          title: "Validasi Absen",
          middleText: "Apakah Kamu Yakin Untuk Absen ( Keluar ) Sekarang ?",
          actions: [
        OutlinedButton(onPressed: () => Get.back(), child: Text("Cancel")),
        ElevatedButton(
          onPressed: () async {
              await colAbsen.doc(todayDocID).update({
                "keluar": {
                "date": now.toIso8601String(),
                "lat": position.latitude,
                "long": position.longitude,
                "address": address,
                "status": status,
                "distance": distance,
              }
            });
            Get.back();
            Get.snackbar("Yay Berhasil", "Kamu udah absen ( Keluar )");
          }, 
          child: Text("Iya"))
      ],
    );
         
        }
      } else{

      }
    }
  }

  Future<void> updatePosition(Position position, String address ) async {
    String uid = await auth.currentUser!.uid;

    firestore.collection("pegawai").doc(uid).update({
      "position": {
        "lat": position.latitude,
        "long": position.longitude,
      },
      "address": address,
    });
  }

  Future<Map<String, dynamic>> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return {
      "message": "Tidak dapat mengambil GPS dari device ini",
      "error": true,
    };
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      // return Future.error('Location permissions are denied');
      return {
      "message": "Izin Menggunakan GPS ditolak, aktifkan GPS kembali",
      "error": true,
    };
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return {
      "message": "Device Tidak Memperbolehkan mengakses GPS",
      "error": true,
    };
    // return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high
  );
  return {
    "position": position,
    "message": "Berhasil Mendapatkan Posisi Device",
    "error": false,
  };
}
}
