import 'package:ecommerce/models/SubCategory.dart';
import 'package:get/get.dart';
import 'package:ecommerce/models/Category.dart';
import '../Services/RemoteServices.dart';
class Category_controller extends GetxController{
  var isLoadingCategories = false.obs;
  var categoriesList = <CategoryModel>[].obs;
  var selectedFilter = RxString('');
  var citiesList = <SubCategory>[].obs;
  int city_id = -1;

  void filterBillsByStatus(statusCode) {
    print(statusCode);
    city_id = statusCode;
    if (statusCode > 0) {
     // filterItems(id , statusCode);
    } else {
     // fetchStories(id);
    }
    // update();
  }
  void fetchCategories() async{
    isLoadingCategories(true);
    try {
      var categories = await RemoteServices.fetchCategories();
      if(categories != null){
        categoriesList.value = categories;
        isLoadingCategories(false);
      }else{
        isLoadingCategories(false);
      }
    }finally{
      isLoadingCategories(false);
    }
    isLoadingCategories(false);
    update();
  }
  @override
  void onInit() {
    fetchCategories();
    // TODO: implement onInit
    super.onInit();
  }
}