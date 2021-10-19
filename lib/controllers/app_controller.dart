import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:opencv_4/opencv_4.dart';

class AppController extends GetxController {
  // see more sample effect
  // https://www.realpythonproject.com/opencv-101-and-instagram-filters-44ae54512aba/

  static const platform = MethodChannel('opencv_4');

  var listEffectMenu = [
    "Reset",
    "Blur",
    "Grey",
    "Jet",
    "Embossed",
  ];

  RxString imagePath = "".obs;
  RxBool visible = true.obs;

  RxList listFilter = [].obs;

  late Uint8List resultFilter;

  Future<Uint8List?> gaussianBlur() async {
    var result = await platform.invokeMethod('gaussianBlur', {
      "pathType": 3,
      "pathString": '',
      "data": resultFilter,
      'kernelSize': [15.0, 15.0],
      'sigmaX': 0.0,
    });
    return result;
  }
/* 
  Future<Uint8List?> cvtColor() async {
    var result = await platform.invokeMethod('cvtColor', {
      "pathType": 3,
      "pathString": '',
      "data": resultFilter,
      'outputType': Cv2.COLOR_BGR2GRAY,
    });
    return result;
  }

  Future<Uint8List?> applyColorMap() async {
    var result = await platform.invokeMethod('applyColorMap', {
      "pathType": 3,
      "pathString": '',
      "data": resultFilter,
      'colorMap': Cv2.COLORMAP_JET,
    });
    return result;
  }

  Future<Uint8List?> scharr() async {
    var result = await platform.invokeMethod('scharr', {
      "pathType": 3,
      "pathString": '',
      "data": resultFilter,
      'depth': Cv2.CV_SCHARR,
      'dx': 0,
      'dy': 1,
    });
    return result;
  } */

  Future<void> setImagePath({required String path}) async {
    imagePath = RxString(path);
    update();
  }

  void addFilterList({required String filter}) {
    listFilter.add(filter);
    update();
  }

  Future<Uint8List?> setFilter() async {
    if (listFilter.value.isEmpty) {
      // no filter yet
      var file = File(imagePath.value);
      resultFilter = await file.readAsBytes();
      return resultFilter;
    } else {
      // reset filter
      var file = File(imagePath.value);
      resultFilter = await file.readAsBytes();
      // run filter
      for (var filter in listFilter) {
        log(DateTime.now().toString() + ' : apply filter => ' + filter);
        // do filter
        switch (filter) {
          case "Blur":
            resultFilter = (await gaussianBlur())!;
            break;
          /*
          case "Grey":
            resultFilter = (await cvtColor())!;
            break;
          case "Jet":
            resultFilter = (await applyColorMap())!;
            break;
          case "Embossed":
            resultFilter = (await scharr())!;
            break; 
          */
        }
      }
      return resultFilter;
    }
  }

  void resetFilterList() {
    listFilter.clear();
    update();
  }
}
