import 'package:flutter/material.dart';
import 'package:flutter_photo_effect/controllers/app_controller.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AppController>(
          init: AppController(),
          builder: (controller) {
            return Column(
              children: const [
                // add photo
                // effect list
              ],
            );
          }),
    );
  }
}