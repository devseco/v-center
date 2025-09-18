import 'package:get/get.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/models/Bill.dart';
import '../Services/RemoteServices.dart';

class Billing_controller extends GetxController{
  var isLoadingBills= true.obs;
  var billsList = <Bill>[].obs;
  int selectedIndex = -1;
  List<Bill> filteredBillsList = [];
  List<String> filters = ['الكل',  'قيد المراجعة', 'قيد التجهيز' ,'قيد التوصيل' , 'مكتملة', 'راجعة' ];
  var selectedFilter = RxString('');
  void fetchBills() async{
    var user_id = sharedPreferences!.getInt('user_id');
    isLoadingBills(true);
    try {
      var products;
      if(selectedIndex == 0){
         products = await RemoteServices.fetchLatestBills(user_id);
      }else {
         products = await RemoteServices.fetchBills(user_id);
      }

      if(products != null){
        billsList.value = products;
      }else{

      }
    }finally{
      isLoadingBills(false);
    }
    print('looooading');
    update();
  }
  void changeSelected(selected){
    selectedIndex = selected;
    fetchBills();
    update();
  }
  void filterBillsByStatus(statusCode) {
    if (statusCode == 0) {
      filteredBillsList = billsList;
    } else {
      filteredBillsList = billsList.where((bill) => bill.status == statusCode).toList();
    }
    update();
  }
  @override
  void onReady() {
    fetchBills();
    // TODO: implement onReady
    super.onReady();
  }
  @override
  void onInit() {
    fetchBills();
    filteredBillsList = billsList;
    selectedFilter('الكل');
    // TODO: implement onInit
    super.onInit();
  }
}