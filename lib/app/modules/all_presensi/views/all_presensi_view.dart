import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence/app/routes/app_pages.dart';

import '../controllers/all_presensi_controller.dart';

class AllPresensiView extends GetView<AllPresensiController> {
  const AllPresensiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Absensi'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7)
              ),
              elevation: 8,
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Cari ...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7)
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: controller.streamAllAbsensi(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if(snapshot.data?.docs.length == 0 || snapshot.data == null){
                    return SizedBox(
                      height: 150,
                      child: Center(
                        child: Text("Belum Ada History Asben"),
                      ),
                    );
                  }
                return ListView.builder(
                  padding: EdgeInsets.all(20),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> data = snapshot.data!.docs[index].data();
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
          ),
        ],
      ),
    );
  }
}
