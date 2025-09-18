import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Services/RemoteServices.dart';
import '../models/Product.dart';

class RecentlyProductsController extends GetxController {
  var isLoadingItem = false.obs; // الحالة العامة لتحميل المنتجات
  var isLoadingMore = false.obs; // الحالة لتحميل المزيد عند نهاية القائمة
  var productList = <Product>[].obs; // قائمة المنتجات
  var page = 1.obs; // الصفحة الحالية
  int selectedFilter = 0; // الفلتر المحدد
  TextEditingController? myController; // حقل الإدخال
  ScrollController scrollController = ScrollController(); // للتحكم في التمرير
  bool _isDisposed = false;
  bool _isInitialized = false;

  @override
  void onInit() {
    super.onInit();
    _isDisposed = false;
    _isInitialized = true;
    _createController();
    myController?.addListener(_printLatestValue);
    fetchProducts(page.value, 10); // تحميل الصفحة الأولى
    scrollController.addListener(_scrollListener); // استماع للتمرير
  }

  void _createController() {
    if (myController != null) {
      try {
        myController!.dispose();
      } catch (e) {
        print('Error disposing existing controller: $e');
      }
    }
    myController = TextEditingController();
  }

  void _printLatestValue() {
    if (!_isDisposed) {
      print("Textfield value: ${myController?.text ?? ''}");
    }
  }

  // تغيير الفلتر وتحميل المنتجات بناءً عليه
  void changeSelected(selected) {
    if (_isDisposed) return;
    selectedFilter = selected;
    page.value = 1; // إعادة التهيئة للصفحة الأولى
    productList.clear();
    fetchFilter(page.value, 10); // تحميل المنتجات بناءً على الفلتر
    update();
  }

  // تحميل المنتجات مع الفلتر
  void fetchFilter(int page, int limit) async {
    if (_isDisposed) return;
    isLoadingItem(true);
    try {
      var products = await RemoteServices.fetchProductsLast(page, limit);
      if (products != null && !_isDisposed) {
        if (page == 1) {
          productList.value = products; // استبدال القائمة
        } else {
          productList.addAll(products); // إضافة المزيد للقائمة
        }
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      if (!_isDisposed) {
        isLoadingItem(false);
      }
    }
    if (!_isDisposed) {
      update();
    }
  }

  // تحميل المنتجات (بلا فلتر)
  void fetchProducts(int page, int limit) async {
    if (_isDisposed) return;
    if (page > 1) {
      isLoadingMore(true); // تعيين حالة تحميل المزيد إلى true
    } else {
      isLoadingItem(true); // تحميل الصفحة الأولى
    }
    try {
      var products = await RemoteServices.fetchProductsLast(page, limit);
      if (products != null && !_isDisposed) {
        if (page == 1) {
          productList.value = products;
        } else {
          productList.addAll(products);
        }
      }
    } catch (e) {
      print(e.toString());
    } finally {
      if (!_isDisposed) {
        if (page > 1) {
          isLoadingMore(false); // إيقاف تحميل المزيد
        } else {
          isLoadingItem(false);
        }
      }
    }
    if (!_isDisposed) {
      update();
    }
  }

  void _scrollListener() {
    if (_isDisposed) return;
    print('Scroll position: ${scrollController.position.pixels}');
    print('Max scroll extent: ${scrollController.position.maxScrollExtent}');
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !isLoadingMore.value) {
      print("Loading more products...");
      loadMoreProducts();
    }
  }

  // تحميل المزيد من المنتجات
  void loadMoreProducts() async {
    if (_isDisposed) return;
    isLoadingMore(true);
    try {
      var newPage = page.value + 1;
      var products = await RemoteServices.fetchProductsLast(newPage, 10);
      if (products != null && products.isNotEmpty && !_isDisposed) {
        productList.addAll(products);
        page.value = newPage;
      }
    } catch (e) {
      print("Error loading more products: $e");
    } finally {
      if (!_isDisposed) {
        isLoadingMore(false);
      }
    }
    if (!_isDisposed) {
      update();
    }
  }

  @override
  void onClose() {
    _isDisposed = true;
    _isInitialized = false;
    // التخلص من TextEditingController في onClose
    if (myController != null) {
      try {
        // إزالة جميع المستمعين أولاً
        myController!.removeListener(_printLatestValue);
        myController!.dispose();
      } catch (e) {
        print('Error disposing TextEditingController: $e');
      }
      myController = null;
    }
    try {
      scrollController.removeListener(_scrollListener);
      scrollController.dispose();
    } catch (e) {
      print('Error disposing ScrollController: $e');
    }
    super.onClose();
  }

  // دالة مساعدة لمسح النص في البحث
  void clearSearch() {
    if (!_isDisposed && myController != null) {
      try {
        myController!.clear();
      } catch (e) {
        print('Error clearing TextEditingController: $e');
      }
    }
  }

  // دالة مساعدة للحصول على الـ controller بشكل آمن
  TextEditingController get searchController {
    if (!_isInitialized || _isDisposed) {
      _isInitialized = true;
      _isDisposed = false;
      _createController();
    }
    if (myController == null) {
      _createController();
    }
    return myController!;
  }

  // دالة للتحقق من حالة الـ controller
  bool get isControllerActive {
    return _isInitialized && !_isDisposed;
  }

  // دالة البحث في المنتجات
  void filterProductList(String query) async {
    if (_isDisposed) return;

    if (query.isEmpty) {
      // إذا كان البحث فارغ، إعادة تحميل المنتجات الأصلية
      page.value = 1;
      fetchProducts(1, 10);
      return;
    }

    isLoadingItem(true);
    try {
      // البحث في جميع المنتجات من السيرفر
      var products = await RemoteServices.filterProducts(query);
      if (products != null && !_isDisposed) {
        productList.value = products;
      } else {
        productList.clear();
      }
    } catch (e) {
      print("Error filtering products: $e");
      productList.clear();
    } finally {
      if (!_isDisposed) {
        isLoadingItem(false);
      }
    }
    if (!_isDisposed) {
      update();
    }
  }

  // دالة البحث البديلة مثل Home_controller
  void searchProducts(String query) async {
    if (_isDisposed) return;
    if (query.isEmpty) {
      fetchProducts(1, 10);
      return;
    }

    isLoadingItem(true);
    try {
      var products = await RemoteServices.filterProducts(query);
      if (products != null && !_isDisposed) {
        productList.value = products;
        print(
          'Search results: ${products.length} products found for query: $query',
        );
      } else {
        productList.clear();
        print('No search results found for query: $query');
      }
    } catch (e) {
      print("Error searching products: $e");
      productList.clear();
    } finally {
      if (!_isDisposed) {
        isLoadingItem(false);
      }
    }
    if (!_isDisposed) {
      update();
    }
  }

  // دالة البحث مثل search_view.dart
  Future<List<dynamic>> filterData() async {
    if (_isDisposed) return [];
    productList.clear();
    await Future.delayed(Duration(milliseconds: 500));
    String _inputText = myController?.text ?? '';
    if (_inputText.isEmpty) {
      fetchProducts(1, 10);
      return [];
    }
    try {
      var filters = await RemoteServices.filterItems(_inputText);
      if (filters != null && filters.isNotEmpty && !_isDisposed) {
        productList.value = filters;
        print(
          'Filter results: ${filters.length} products found for query: $_inputText',
        );
      } else {
        productList.clear();
        print('No filter results found for query: $_inputText');
      }
    } catch (e) {
      print("Error filtering data: $e");
      productList.clear();
    }
    if (!_isDisposed) {
      update();
    }
    return [];
  }
}
