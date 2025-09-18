import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ecommerce/models/Product.dart';
import 'package:ecommerce/models/ProductsModel.dart';
import 'package:ecommerce/models/SizeModel.dart';
import '../Services/RemoteServices.dart';

class Product_controller extends GetxController {
  var isLoadingItem = false.obs;
  var isLoadingSize = false.obs;
  var productList = <Product>[].obs;
  var sizeInfoList = <SizeModel>[].obs;
  var productItemList = <ProductModel>[].obs;
  int index = 0;
  var rate = 3.0;
  int count = 1;
  int id = 0;
  int lowerPrice = 0;
  int fullLaowerPrice = 0;
  int lowerPriceLabel = 0;
  var colorsList = <ColorItem>[].obs;
  var sizesList = <String>[].obs;
  TextEditingController priceUser = TextEditingController();
  dynamic argumentData = Get.arguments;
  var selectedColor = ''.obs;
  var selectedSize = ''.obs;
  var selectedColorText = ''.obs;
  var selectCountSize = 0.obs;

  void FormatNumber(value) {
    String newText = value.replaceAll(RegExp(r'[^0-9]'), '');

    // Add commas for every three digits from the right
    newText = NumberFormat("#,###").format(int.parse(newText));

    // Set the formatted value back to the TextField
    this.priceUser.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  void changeSelectedColor(String colorId, String name) {
    selectedColor.value = colorId;
    selectedColorText.value = name;
    fetchSizes(colorId); // تأكد من استخدام معرّف اللون هنا
    update();
  }

  void changeSelectedSize(size) {
    // Method to update the selected size
    selectedSize.value = size;

    // Find the size object in sizeInfoList that matches the selected size
    SizeModel selectedSizeModel = sizeInfoList.firstWhere(
      (sizeModel) => sizeModel.size == size,
    );

    // Update selectCountSize based on the selected size's count
    selectCountSize.value = selectedSizeModel.count;
    print(selectCountSize);

    update(); // Trigger update to reflect changes in UI
  }

  //fetchSize
  void fetchSizes(id) async {
    isLoadingSize(true);
    selectedSize.value = '';
    try {
      var sizes = await RemoteServices.fetchSize(id);
      if (sizes != null) {
        sizeInfoList.value = sizes;
        List<String> titles =
            sizeInfoList.map<String>((item) => item.size).toList();
        sizesList.value = titles;
        isLoadingSize(false);
      } else {
        isLoadingSize(false);
      }
    } finally {
      isLoadingSize(false);
    }
    update();
  }

  void fetchProduct() async {
    isLoadingItem(true);
    try {
      var product = await RemoteServices.fetchProductone(id);
      if (product != null) {
        productItemList.value = [product];
        isLoadingItem(false);
      } else {
        isLoadingItem(false);
      }
    } finally {
      isLoadingItem(false);
    }
    update();
  }

  void changeindex(int i) {
    index = i;
    update();
  }

  void inCounter() {
    count++;
    update();
  }

  void outCounter() {
    if (count != 1) {
      count--;
      lowerPriceLabel = lowerPrice * count;
      fullLaowerPrice = lowerPrice * count;
    }

    update();
  }

  void saveNetworkImage(String url) async {
    final imagePath =
        '${Directory.systemTemp.path}/${DateTime.now().millisecondsSinceEpoch}}.jpg';
    await Dio().download('$url', imagePath);
    await Gal.putImage(imagePath);
    Get.snackbar('حفظ الصورة', 'تم حفظ الصورة بنجاح');
  }

  @override
  void onInit() {
    id = argumentData[0]['id'];
    fetchProduct();
    // TODO: implement onInit
    super.onInit();
  }
}

class ColorItem {
  final String id;
  final String name;

  ColorItem({required this.id, required this.name});
}
