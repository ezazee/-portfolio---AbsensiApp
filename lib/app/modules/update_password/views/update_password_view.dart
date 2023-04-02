import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  const UpdatePasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Password'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: controller.curC,
            autocorrect: false,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password Yang Sekarang",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10,),
          TextField(
            controller: controller.newC,
            autocorrect: false,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password Baru",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10,),
          TextField(
            controller: controller.confirC,
            autocorrect: false,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Konfirmasi Password Baru",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10,),
          Obx(() => ElevatedButton(
            onPressed: (){
              if(controller.isLoading.isFalse){
                controller.updatePass();
              }
            }, 
            child: Text((controller.isLoading.isFalse) ? "Update Password" : "Loading..")
            ),
          ),
        ],
      ),
    );
  }
}
