import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ecommerce/controllers/Products_controller.dart';
import 'dart:async';
import '../main.dart';

class Products extends StatefulWidget {
  Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final Products_Controller controller = Get.put(Products_Controller());
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    // إلغاء المؤقت السابق إذا كان موجوداً
    _debounceTimer?.cancel();

    // إنشاء مؤقت جديد للبحث بعد 500 مللي ثانية
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      print('Searching in Products for: $value');
      controller.filterProductList(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.deepPurple,
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.deepPurple.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
        ),
        onPressed: () => Get.back(),
      ),
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
              width: 24,
              height: 24,
            ),
          ),
          SizedBox(width: 12),
          Text(
            'المنتجات',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        // شريط البحث
        _buildSearchBar(),
        SizedBox(height: 16),

        // قائمة الفلاتر
        _buildFilterList(),
        SizedBox(height: 16),

        // قائمة المنتجات
        Expanded(
          child: GetBuilder<Products_Controller>(
            builder: (builder) {
              if (!builder.isLoadingProducts.value) {
                if (builder.productList.isNotEmpty) {
                  return _buildProductsGrid();
                } else {
                  return _buildEmptyState();
                }
              } else {
                return _buildLoadingScreen();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller.searchQueryController,
        decoration: InputDecoration(
          hintText: '9'.tr,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
          prefixIcon: Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search, color: Colors.deepPurple, size: 20),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        onChanged: (value) {
          _onSearchChanged(value);
        },
        onSubmitted: (value) {
          // إلغاء المؤقت وإجراء البحث فوراً
          _debounceTimer?.cancel();
          print('Search submitted in Products for: $value');
          controller.filterProductList(value);
        },
      ),
    );
  }

  Widget _buildFilterList() {
    return Obx(() {
      if (controller.citiesList.isEmpty) {
        return Container(
          height: 50,
          child: Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.deepPurple,
              size: 30,
            ),
          ),
        );
      }

      return Container(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.citiesList.length,
          itemBuilder: (context, index) {
            final filter = controller.citiesList[index];
            return _buildFilterChip(filter.title, filter.id);
          },
        ),
      );
    });
  }

  Widget _buildFilterChip(String title, int id) {
    return Obx(() {
      bool isSelected = controller.selectedFilter.value == title;
      return GestureDetector(
        onTap: () {
          controller.selectedFilter.value = title;
          controller.filterBillsByStatus(id);
        },
        child: Container(
          margin: EdgeInsets.only(right: 12),
          width: 120, // قياس ثابت للعرض
          height: 40, // قياس ثابت للارتفاع
          decoration: BoxDecoration(
            gradient:
                isSelected
                    ? LinearGradient(
                      colors: [
                        Colors.deepPurple,
                        Colors.deepPurple.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                    : null,
            color: isSelected ? null : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildProductsGrid() {
    return Obx(
      () => GridView.builder(
        controller: controller.scrollController,
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: controller.productList.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == controller.productList.length) {
            return controller.isLoadingMore.value
                ? _buildLoadingMoreIndicator()
                : SizedBox.shrink();
          }
          final product = controller.productList[index];
          return _buildProductCard(
            product.image,
            product.title,
            product.price,
            product.id,
          );
        },
      ),
    );
  }

  Widget _buildProductCard(String url, String title, int price, int id) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          'product',
          arguments: [
            {"id": id},
          ],
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المنتج
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  gradient: LinearGradient(
                    colors: [Colors.grey[50]!, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.contain,
                    placeholder:
                        (context, url) => Center(
                          child: LoadingAnimationWidget.staggeredDotsWave(
                            color: Colors.deepPurple,
                            size: 30,
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Center(
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.grey[400],
                            size: 40,
                          ),
                        ),
                  ),
                ),
              ),
            ),

            // تفاصيل المنتج
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // عنوان المنتج
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // السعر
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepPurple,
                            Colors.deepPurple.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${(sharedPreferences?.getInt('active') == 1) ? formatter.format(price) + ' ' + '18'.tr : '...'}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: Colors.deepPurple,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.deepPurple,
            size: 60,
          ),
          SizedBox(height: 20),
          Text(
            'جاري تحميل المنتجات...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 20),
          Text(
            '20'.tr,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
