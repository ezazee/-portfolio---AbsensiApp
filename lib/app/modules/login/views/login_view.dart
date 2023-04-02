import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: ListView(
         padding: EdgeInsets.all(20),
        children: [
          TextField(
            autocorrect: false,            
            controller: controller.emailC,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,            
            controller: controller.passC,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          Obx(
            () => ElevatedButton(
            onPressed: () async {
              if(controller.isLoading.isFalse){
                await controller.login();
              }
            }, 
            child: Text( controller.isLoading.isFalse ? "Login" : "LOADING...")
            ),
          ),
          TextButton(onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD), 
          child: Text("Lupa Password ?"))
        ],
      )
    );
  }
}
