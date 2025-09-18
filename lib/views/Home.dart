import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ecommerce/controllers/Home_controller.dart';
import 'package:ecommerce/main.dart';

class Home extends StatelessWidget {
  Home({super.key});

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
        body: RefreshIndicator(
          onRefresh: () async {
            final controller = Get.find<Home_controller>();
            controller.fetchProducts(1, 10);
            controller.fetchCategories();
            controller.fetchSliders();
          },
          child: CustomScrollView(
            slivers: [
              // Slider المحسن
              SliverToBoxAdapter(
                child: GetBuilder<Home_controller>(
                  builder: (controller) {
                    print(
                      'isLoadingSliders:  [32m' +
                          controller.isLoadingSliders.value.toString() +
                          '\u001b[0m',
                    );
                    print(
                      'slidersList.length:  [34m' +
                          controller.slidersList.length.toString() +
                          '\u001b[0m',
                    );
                    if (!controller.isLoadingSliders.value) {
                      return (controller.slidersList.length > 0)
                          ? _buildEnhancedSlider(controller)
                          : _buildPlaceholder404();
                    } else {
                      return _buildSliderPlaceholder();
                    }
                  },
                ),
              ),

              // عنوان المنتجات المميزة
              SliverToBoxAdapter(child: _buildSectionHeader()),

              // قائمة المنتجات المميزة
              SliverToBoxAdapter(
                child: SizedBox(
                  height: Get.width * 1.2,
                  child: GetBuilder<Home_controller>(
                    builder: (controller) {
                      print(
                        'isLoadingProductes:  [32m' +
                            controller.isLoadingProductes.value.toString() +
                            '\u001b[0m',
                      );
                      print(
                        'productsList.length:  [34m' +
                            controller.productsList.length.toString() +
                            '\u001b[0m',
                      );
                      if (!controller.isLoadingProductes.value) {
                        if ((controller.productsList.isNotEmpty)) {
                          return _buildProductsGrid(controller);
                        } else {
                          return _buildEmptyProducts();
                        }
                      } else {
                        return _buildProductsLoading();
                      }
                    },
                  ),
                ),
              ),

              // مساحة إضافية في الأسفل
              SliverToBoxAdapter(child: SizedBox(height: Get.height * 0.05)),
            ],
          ),
        ),
      ),
    );
  }

  // Slider محسن مع تأثيرات بصرية
  Widget _buildEnhancedSlider(Home_controller controller) {
    return Container(
      margin: EdgeInsets.all(Get.width * 0.04),
      child: Column(
        children: [
          Container(
            height: Get.height * 0.25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  spreadRadius: 2,
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                viewportFraction: 0.95,
                height: Get.height * 0.25,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  controller.changeindex(index);
                },
              ),
              items:
                  controller.slidersList.map((item) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.01,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: CachedNetworkImage(
                          imageUrl: item.image,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => Container(
                                color: Colors.grey[200],
                                child: Center(
                                  child:
                                      LoadingAnimationWidget.staggeredDotsWave(
                                        color: Colors.deepPurple,
                                        size: Get.width * 0.08,
                                      ),
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                color: Colors.grey[200],
                                child: Icon(
                                  Icons.error_outline,
                                  color: Colors.grey[400],
                                  size: Get.width * 0.1,
                                ),
                              ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          SizedBox(height: Get.height * 0.02),
          GetBuilder<Home_controller>(
            builder: (c) {
              return c.slidersList.length > 0
                  ? DotsIndicator(
                    dotsCount: c.slidersList.length,
                    position: c.index,
                    decorator: DotsDecorator(
                      color: Colors.grey[300]!,
                      size: Size(Get.width * 0.02, Get.width * 0.02),
                      activeSize: Size(Get.width * 0.04, Get.width * 0.02),
                      activeColor: Colors.deepPurple,
                      activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                  : SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  // عنوان القسم المحسن
  Widget _buildSectionHeader() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Get.width * 0.04,
        vertical: Get.height * 0.02,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(Get.width * 0.02),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.star,
                  color: Colors.deepPurple,
                  size: Get.width * 0.06,
                ),
              ),
              SizedBox(width: Get.width * 0.03),
              Text(
                "12".tr,
                style: TextStyle(
                  fontSize: Get.width * 0.045,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed('bestProducts');
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.04,
                vertical: Get.height * 0.01,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple,
                    Colors.deepPurple.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                "11".tr,
                style: TextStyle(
                  fontSize: Get.width * 0.035,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // شبكة المنتجات المحسنة
  Widget _buildProductsGrid(Home_controller controller) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: Get.width * 0.03,
        mainAxisSpacing: Get.width * 0.03,
        childAspectRatio: 0.75,
      ),
      itemCount:
          (controller.productsList.length > 6)
              ? 6
              : controller.productsList.length,
      itemBuilder: (BuildContext context, int index) {
        final product = controller.productsList[index];
        return _buildEnhancedProductCard(
          controller,
          product.image,
          product.title,
          product.price,
          product.id,
        );
      },
    );
  }

  // بطاقة منتج محسنة
  Widget _buildEnhancedProductCard(
    Home_controller controller,
    String url,
    String title,
    int price,
    int id,
  ) {
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
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 4),
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
                            size: Get.width * 0.06,
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Center(
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.grey[400],
                            size: Get.width * 0.08,
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
                padding: EdgeInsets.all(Get.width * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // عنوان المنتج
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: Get.width * 0.032,
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
                      padding: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.02,
                        vertical: Get.height * 0.005,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepPurple,
                            Colors.deepPurple.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        '${(sharedPreferences?.getInt('active') == 1) ? formatter.format(price) + ' ' + '18'.tr : '...'} ',
                        style: TextStyle(
                          fontSize: Get.width * 0.028,
                          fontWeight: FontWeight.w700,
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

  // حالات التحميل والأخطاء
  Widget _buildSliderPlaceholder() {
    return Container(
      height: Get.height * 0.3,
      margin: EdgeInsets.all(Get.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: Colors.deepPurple,
          size: Get.width * 0.08,
        ),
      ),
    );
  }

  Widget _buildPlaceholder404() {
    return Container(
      height: Get.height * 0.25,
      margin: EdgeInsets.all(Get.width * 0.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Image.asset('assets/images/comingsoon.jpg', fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildProductsLoading() {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.deepPurple,
        size: Get.width * 0.08,
      ),
    );
  }

  Widget _buildEmptyProducts() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(Get.width * 0.08),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: Get.width * 0.15,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: Get.height * 0.02),
          Text(
            '20'.tr,
            style: TextStyle(
              fontSize: Get.width * 0.04,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // دوال مساعدة
  SizedBox spaceH(double size) {
    return SizedBox(height: size);
  }

  SizedBox spaceW(double size) {
    return SizedBox(width: size);
  }
}
