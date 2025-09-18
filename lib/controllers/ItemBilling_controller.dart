import 'package:get/get.dart';
import 'package:ecommerce/models/Sale.dart';

import '../Services/RemoteServices.dart';

class ItemBilling_controller extends GetxController{
  var LoadingItem= false.obs;
  var SalesList = <Sale>[].obs;
  int id = 0;
  int total = 0;
  dynamic argumentData = Get.arguments;
  void getSales() async {
    LoadingItem(true);
    try {
      var items = await RemoteServices.getBill(id);
      if (items != null) {
        SalesList.value = items;
        // Calculate total price including delivery
        total = SalesList.fold<int>(
            0,
                (previousValue, sale) =>
            previousValue + sale.price + sale.delivery);
      } else {

        print('some error');
      }
    } catch(e){
      print(e);

    }finally {
      LoadingItem(false);
    }
    update();
  }
  @override
  void onInit() {
    id = argumentData[0]['id'];
    getSales();
    // TODO: implement onInit
    super.onInit();
  }
}