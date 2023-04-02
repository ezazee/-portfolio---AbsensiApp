import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  const UpdateProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    controller.nipC.text = controller.user['nip'];
    controller.nameC.text = controller.user['name'];
    controller.emailC.text = controller.user['email'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Text("Foto Profil", 
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GetBuilder<UpdateProfileController>(
                  builder: (c){
                    if(c.image != null){
                      return Column(
                        children: [
                          ClipOval(
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Image.file(File(c.image!.path), fit: BoxFit.cover,),
                            ),
                          ),
                            TextButton(
                              onPressed: () {
                                controller.deleteProfile(controller.user["uid"]);
                              }, 
                              child: Text("Delete",
                            ),
                          ),
                        ],
                      );
                    } else {
                      if(controller.user["profile"] != null ){
                        return ClipOval(
                        child: Container(
                          height: 100,
                          width: 100,
                          child: Image.network(controller.user["profile"], fit: BoxFit.cover,),
                        ),
                      );
                      
                      } else{
                        return Text("Tidak Ada Data");
                      }
                    }
                  },
                ),
              TextButton(
                  onPressed: () {
                    controller.pickImage();
                  }, 
                  child: Text("Pilih File",
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          TextField(
            autocorrect: false,            
            controller: controller.nameC,
            decoration: InputDecoration(
              labelText: 'Nama',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            readOnly: true,
            autocorrect: false,            
            controller: controller.nipC,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[300],
              labelText: 'NIP',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            readOnly: true,
            autocorrect: false,            
            controller: controller.emailC,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[300],
              labelText: 'Email',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          SizedBox(height: 20),
          Obx(
            () => ElevatedButton(onPressed: () async {
              if(controller.isLoading.isFalse){
                await controller.updateProfile(controller.user['uid']);
              }
            }, child: controller.isLoading.isFalse ? Text('Update Profile') : Text('Loading....')),
          )
        ],
      ),
    );
  }
}
