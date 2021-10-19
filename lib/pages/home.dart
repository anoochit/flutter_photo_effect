import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_photo_effect/controllers/app_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool visible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Photo Effect"),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.only(bottom: 16.0),
        bottom: true,
        child: LayoutBuilder(builder: (context, constraints) {
          return GetBuilder<AppController>(
              init: AppController(),
              builder: (controller) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(),

                    // photo
                    (controller.imagePath.isNotEmpty)
                        ? Stack(
                            children: [
                              // photos from picsum
                              SizedBox(
                                width: constraints.maxWidth,
                                height: constraints.maxWidth,
                                child: Image.file(
                                  File(controller.imagePath.value),
                                  fit: BoxFit.cover,
                                ),
                              ),

                              // preview photo
                              GestureDetector(
                                onTapDown: (details) {
                                  log("tab down");
                                  controller.visible = RxBool(false);
                                  controller.update();
                                  log(controller.visible.toString());
                                },
                                onTapUp: (details) {
                                  log("tab up");
                                  controller.visible = RxBool(true);
                                  controller.update();
                                },
                                child: (controller.visible.value == true)
                                    ? SizedBox(
                                        width: constraints.maxWidth,
                                        height: constraints.maxWidth,
                                        child: FutureBuilder<Uint8List?>(
                                          future: controller.setFilter(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              Uint8List? bytes = snapshot.data;
                                              return Image.memory(
                                                bytes!,
                                                fit: BoxFit.cover,
                                              );
                                            }

                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return const Center(
                                                child: Text("Processing"),
                                              );
                                            }

                                            return const Center(
                                              child: Text("Processing"),
                                            );
                                          },
                                        ),
                                      )
                                    : Container(),
                              ),
                            ],
                          )
                        : Container(),

                    // pickup photo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // pickup image button
                        TextButton.icon(
                          icon: const Icon(Icons.image),
                          label: const Text("Pick image"),
                          onPressed: () async {
                            // open image picker and save image to app controller
                            ImagePicker imagePicker = ImagePicker();
                            XFile? xImage = await imagePicker.pickImage(source: ImageSource.gallery, maxHeight: 640, maxWidth: 640);
                            // user has pick an image
                            if (xImage != null) {
                              // save to app controller
                              log('path => ' + xImage.path);
                              // update app controller
                              controller.setImagePath(path: xImage.path);
                            }
                          },
                        ),
                        // save image
                        (controller.imagePath.isNotEmpty)
                            ? TextButton.icon(
                                icon: const Icon(Icons.save_alt),
                                label: const Text("Save"),
                                onPressed: () {
                                  // save image to file

                                  // snackbar
                                },
                              )
                            : Container()
                      ],
                    ),

                    // effect list, show effect list
                    const Spacer(),
                    (controller.imagePath.isNotEmpty)
                        ? Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Flex(
                                direction: Axis.horizontal,
                                children: controller.listEffectMenu
                                    .map(
                                      (item) => GestureDetector(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Center(child: Text(item)),
                                          ),
                                        ),
                                        onTap: () {
                                          log("tap effect");
                                          if (item.toLowerCase() != "reset") {
                                            controller.addFilterList(filter: item);
                                          } else {
                                            controller.resetFilterList();
                                          }
                                          log("total filter => " + controller.listFilter.length.toString());
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          )
                        : Container()
                  ],
                );
              });
        }),
      ),
    );
  }
}
