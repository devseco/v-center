import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/Services/RemoteServices.dart';
import 'package:ecommerce/models/Category.dart';
import 'package:ecommerce/models/TestItem.dart';
import '../models/Product.dart';
import '../models/Slider.dart';

class Home_controller extends GetxController {
  int index = 0;
  var isLoadingProductes = true.obs;
  var isLoadingSliders = true.obs;
  var isLoadingCategories = true.obs;
  var productsList = <Product>[].obs;
  var slidersList = <SliderBar>[].obs;
  var categoriesList = <CategoryModel>[].obs;
  TextEditingController? myController;
  bool _isDisposed = false;
  bool _isInitialized = false;

  //fetch Productes
  void fetchProducts(page, limit) async {
    if (_isDisposed) return;
    isLoadingProductes(true);
    try {
      print('Fetching products: page=$page, limit=$limit');
      var products = await RemoteServices.fetchProductsRecently(page, limit);
      print('Fetched products: ${products?.length ?? 0} products');
      if (products != null && products.isNotEmpty && !_isDisposed) {
        productsList.value = products;
        print('Products loaded successfully: ${productsList.length} products');
      } else {
        productsList.clear();
        print('No products found or empty response');
      }
    } catch (e) {
      print('Error fetching products: $e');
      if (!_isDisposed) {
        productsList.clear();
      }
    } finally {
      if (!_isDisposed) {
        isLoadingProductes(false);
      }
    }
    if (!_isDisposed) {
      update();
    }
  }

  //fetch Sliders
  void fetchSliders() async {
    if (_isDisposed) return;
    isLoadingSliders(true);
    try {
      var sliders = await RemoteServices.fetchSliders();
      print('sliders: ' + sliders.toString()); // طباعة النتائج
      if (sliders != null && !_isDisposed) {
        slidersList.value = sliders;
      }
    } finally {
      if (!_isDisposed) {
        isLoadingSliders(false);
      }
    }
  }

  //fetch Categories
  void fetchCategories() async {
    if (_isDisposed) return;
    isLoadingCategories(true);
    try {
      var categories = await RemoteServices.fetchCategories();
      print('categories: ' + categories.toString()); // طباعة النتائج
      if (categories != null && !_isDisposed) {
        categoriesList.value = categories;
      }
    } finally {
      if (!_isDisposed) {
        isLoadingCategories(false);
      }
    }
  }

  Future<List<TestItem>> fetchData() async {
    if (_isDisposed) return [];
    await Future.delayed(Duration(milliseconds: 2000));
    List<TestItem> _list = [];
    String _inputText = myController?.text ?? '';
    var filters = await RemoteServices.filterProducts(_inputText);
    if (filters != null) {
      for (var product in filters) {
        // تحويل Product إلى TestItem إذا لزم الأمر
        _list.add(TestItem.fromJson(product.toJson()));
      }
    }
    return _list;
  }

  Future<List<TestItem>> filterData() async {
    if (_isDisposed) return [];

    String _inputText = myController?.text ?? '';
    print('filterData called with text: "$_inputText"');

    if (_inputText.trim().isEmpty) {
      print('Empty search text, loading all products');
      fetchProducts(1, 10);
      return [];
    }

    isLoadingProductes(true);
    productsList.clear();

    try {
      print('Calling RemoteServices.filterItems for: $_inputText');
      var filters = await RemoteServices.filterItems(_inputText);

      if (filters != null && filters.isNotEmpty) {
        print('Found ${filters.length} products from filterItems');
        for (var product in filters) {
          productsList.add(product);
        }
        print('Added ${productsList.length} products to productsList');
      } else {
        print('No products found from filterItems');
        productsList.clear();
      }
    } catch (e) {
      print('Error in filterData: $e');
      productsList.clear();
    } finally {
      if (!_isDisposed) {
        isLoadingProductes(false);
        update();
      }
    }

    return [];
  }

  @override
  void onInit() {
    super.onInit();
    _isDisposed = false;
    _isInitialized = true;
    // إنشاء TextEditingController في onInit
    _createController();
    fetchProducts(1, 10);
    fetchCategories();
    fetchSliders();
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

  @override
  void onReady() {
    super.onReady();
  }

  void changeindex(int i) {
    if (!_isDisposed) {
      index = i;
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
        myController!.removeListener(() {});
        myController!.dispose();
      } catch (e) {
        print('Error disposing TextEditingController: $e');
      }
      myController = null;
    }
    super.onClose();
  }

  void searchProducts(String query) async {
    if (_isDisposed) return;

    // إذا كان النص فارغاً، اعرض جميع المنتجات
    if (query.trim().isEmpty) {
      fetchProducts(1, 10);
      return;
    }

    // تجنب البحث إذا كان نفس النص
    if (myController?.text == query && productsList.isNotEmpty) {
      return;
    }

    isLoadingProductes(true);
    try {
      print('Searching for: $query');
      var products = await RemoteServices.filterProducts(query);
      if (products != null && products.isNotEmpty && !_isDisposed) {
        productsList.value = products;
        print('Search results: ${products.length} products found');
      } else {
        productsList.clear();
        print('No search results found for: $query');
      }
    } catch (e) {
      print('Search error: $e');
      if (!_isDisposed) {
        productsList.clear();
      }
    } finally {
      if (!_isDisposed) {
        isLoadingProductes(false);
      }
    }
    if (!_isDisposed) {
      update();
    }
  }

  // دالة مساعدة لمسح النص في البحث
  void clearSearch() {
    if (!_isDisposed && myController != null) {
      try {
        myController!.clear();
        // إعادة تحميل جميع المنتجات عند مسح البحث
        fetchProducts(1, 10);
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
}
