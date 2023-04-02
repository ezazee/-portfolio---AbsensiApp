import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:presence/app/controllers/page_index_controller.dart';
import 'package:presence/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';
import '../../../controllers/page_index_controller.dart';


class HomeView extends GetView<HomeController> {
  final pageC = Get.find<PageIndexController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if(snapshot.hasData){
            Map<String, dynamic> user = snapshot.data!.data()!;
          
          return ListView(
            padding: EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  ClipOval(
                    child: Container(
                      width: 75,
                      height: 75,
                      color: Colors.grey[200],
                      child: Image.network(user["profile"] != null ? user["profile"] : "https://ui-avatars.com/api/?name=${user['name']}", fit: BoxFit.cover,),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Selamat Datang",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      Container(
                        width: 200,
                        child: Text(
                            user["address"] != null ? "${user['address']}" : "Lokasi Belum Ditemukan",
                            textAlign: TextAlign.left,
                          ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "${user["name"]}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                        "${user["nip"]}",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal
                        ),
                      ),
                        SizedBox(width: 10),
                        Container(
                          height: 10,
                          width: 2,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 10),
                        Text(
                        "${user["job"]}",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal
                        ),
                      ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                ),
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: controller.streamTodayAbsen(),
                  builder: (context, snapToday) {
                    if(snapToday.connectionState == ConnectionState.waiting){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    Map<String, dynamic>? dataToday = snapToday.data?.data();
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text("Masuk"),
                            Text(dataToday?["masuk"] == null ? "-" : "${DateFormat.jms().format(DateTime.parse(dataToday!['masuk']['date']))}"),
                          ],
                        ),
                        Container(
                          height: 40,
                          width: 2,
                          color: Colors.grey,
                        ),
                        Column(
                          children: [
                            Text("Keluar"),
                            Text(dataToday?["keluar"] == null ? "-" : "${DateFormat.jms().format(DateTime.parse(dataToday!['keluar']['date']))}"),
                          ],
                        ),
                      ],
                    );
                  }
                ),
              ),
              SizedBox(height: 20),
              Divider(
                thickness: 2,
                color: Colors.grey[300],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "5 Hari Terakhir",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  TextButton(onPressed: () => Get.toNamed(Routes.ALL_PRESENSI), child: Text("Lihat Semua"))
                ],
              ),
              SizedBox(height: 10),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: controller.streamLastAbsen(),
                builder: (context, snapAbsen) {
                  if(snapAbsen.connectionState == ConnectionState.waiting){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if(snapAbsen.data?.docs.length == 0 || snapAbsen.data == null){
                    return SizedBox(
                      height: 150,
                      child: Center(
                        child: Text("Belum Ada History Asben"),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap:  true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapAbsen.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data = snapAbsen.data!.docs[index].data();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Material(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[200],
                          child: InkWell(
                            onTap: () => Get.toNamed(Routes.DETAIL_PRESENSI, arguments: data),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Masuk",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text(
                                        "${DateFormat.yMMMEd().format(DateTime.parse(data['date']))}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(data['masuk']?['date'] == null ? "-" : "${DateFormat.jms().format(DateTime.parse(data['masuk']!['date']))}"),
                                  SizedBox(height: 10),
                                  Text(
                                    "Keluar",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(data['keluar']?['date'] == null ? "-" : "${DateFormat.jms().format(DateTime.parse(data['keluar']!['date']))}"),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              ),
            ],
          );
          } else{
            return Center(
              child: Text("Tidak Dapat Memuat Data"),
            );
          }
        },
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.fingerprint, title: 'Add'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        initialActiveIndex: pageC.pageIndex.value,
        onTap: (int i) => pageC.gantiPage(i),
      ),
    );
  }
}
