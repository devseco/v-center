import 'package:ecommerce/models/SubCategory.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../Services/RemoteServices.dart';
import '../models/Product.dart';

class Products_Controller extends GetxController {
  dynamic argumentData = Get.arguments;
  var isLoadingItem = false.obs;
  var isLoadingProducts = false.obs;
  var isLoadingMore = false.obs; // حالة تحميل المزيد
  var id_cat = 0.obs;

  TextEditingController searchQueryController = TextEditingController();
  var productList = <Product>[].obs;
  var selectedFilter = RxString('');
  var citiesList = <SubCategory>[].obs;
  int city_id = -1;

  var currentPage = 1.obs; // تتبع الصفحة الحالية

  ScrollController scrollController =
      ScrollController(); // ScrollController للتحكم في التمرير

  @override
  void onInit() {
    id_cat.value = argumentData[0]['id'];
    fetchCities(id_cat);
    scrollController.addListener(_scrollListener); // إضافة مستمع للتمرير
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.removeListener(
      _scrollListener,
    ); // إزالة المستمع عند غلق الـ Controller
    super.onClose();
  }

  void filterBillsByStatus(statusCode) {
    print(statusCode);
    city_id = statusCode;
    // If there's a search query, filter by both subcategory and search
    if (searchQueryController.text.isNotEmpty) {
      filterProductList(searchQueryController.text);
    } else {
      // Otherwise just filter by subcategory
      fetchProduct(statusCode);
    }
    isLoadingProducts(true);
    update();
  }

  void filterProductList(String query) {
    print('Products_Controller filterProductList called with: "$query"');
    print('Category ID: ${id_cat.value}, SubCategory ID: $city_id');

    if (query.isEmpty) {
      // If search is empty, filter only by subcategory
      print('Query is empty, fetching products for subcategory: $city_id');
      fetchProduct(city_id);
    } else {
      // Filter by both subcategory and search text
      print('Filtering products with query: "$query"');
      isLoadingProducts(true);
      RemoteServices.filterProductsByCategoryAndQuery(
            id_cat.value,
            city_id,
            query,
          )
          .then((filteredProducts) {
            if (filteredProducts != null && filteredProducts.isNotEmpty) {
              productList.value = filteredProducts;
            } else {
              productList.clear(); // Clear the list if no results found
            }
            isLoadingProducts(false);
            update();
          })
          .catchError((error) {
            print('Error filtering products: $error');
            productList.clear();
            isLoadingProducts(false);
            update();
          });
    }
  }

  void fetchProduct(int id) async {
    isLoadingProducts(true);
    productList.clear();
    currentPage.value = 1; // Reset current page when fetching new products
    try {
      var products = await RemoteServices.fetchProductByCate(
        id,
        id_cat.value,
        currentPage.value,
        12,
      );
      if (products != null && products.isNotEmpty) {
        productList.value = products;
      } else {
        productList.clear(); // Clear the list if no results found
      }
    } catch (e) {
      print("Error fetching products: $e");
      productList.clear(); // Clear the list on error
    } finally {
      isLoadingProducts(false);
    }
    update();
  }

  void fetchCities(id) async {
    isLoadingItem(true);
    try {
      var cities = await RemoteServices.fetchSubCategories(id);
      if (cities != null) {
        citiesList.value = cities;
        selectedFilter(cities[0].title);
        filterBillsByStatus(cities[0].id);
        fetchProduct(cities[0].id);
      }
    } catch (e) {
      print("Error fetching cities: $e");
    } finally {
      isLoadingItem(false);
    }
    update();
  }

  void loadMoreProducts(id) async {
    if (!isLoadingMore.value) {
      isLoadingMore(true);
      try {
        int nextPage =
            currentPage.value + 1; // الصفحة التالية بناءً على المتغير الحالي
        var products = await RemoteServices.fetchProductByCate(
          id,
          id_cat.value,
          nextPage,
          12,
        );

        if (products != null && products.isNotEmpty) {
          // التحقق من التكرار قبل إضافة المنتجات الجديدة
          var newProducts =
              products.where((product) {
                return !productList.any(
                  (existingProduct) => existingProduct.id == product.id,
                );
              }).toList();

          if (newProducts.isNotEmpty) {
            productList.addAll(newProducts); // إضافة المنتجات الجديدة
            currentPage.value = nextPage; // تحديث الصفحة الحالية
          }
        }
      } catch (e) {
        print("Error loading more products: $e");
      } finally {
        isLoadingMore(false);
      }
    }
    update();
  }

  void _scrollListener() {
    double maxScroll = scrollController.position.maxScrollExtent;
    double currentScroll = scrollController.position.pixels;

    if (currentScroll >= maxScroll - 50) {
      print("Reached the bottom of the list, loading more products...");
      loadMoreProducts(city_id);
    }
  }
}
