import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/controllers/Cart_controller.dart';
import '../main.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});
  final Cart_controller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],

      bottomNavigationBar: GetBuilder<Cart_controller>(
        builder: (builder) {
          return Container(
            height: Get.width * 0.2,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.all(Get.width * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // زر الدفع
                GetBuilder<Cart_controller>(
                  builder: (builder) {
                    return GestureDetector(
                      onTap: () {
                        if (BoxCart.isNotEmpty) {
                          if (sharedPreferences!.getString('phone') != null) {
                            Get.toNamed(
                              'checkout',
                              arguments: [
                                {
                                  'total': builder.total,
                                  'totalUser': builder.total,
                                },
                              ],
                            );
                          } else {
                            Get.snackbar(
                              'عذرا',
                              'يجب عليك تسجيل الدخول',
                              colorText: Colors.white,
                              backgroundColor: Colors.red,
                            );
                          }
                        }
                      },
                      child: Container(
                        height: Get.width * 0.1,
                        width: Get.width * 0.32,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.deepPurple,
                              Colors.deepPurple.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_checkout,
                                color: Colors.white,
                                size: Get.width * 0.04,
                              ),
                              SizedBox(width: Get.width * 0.02),
                              Text(
                                '31'.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Get.width * 0.035,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // عرض السعر
                GetBuilder<Cart_controller>(
                  builder: (builder) {
                    if (BoxCart.isNotEmpty) {
                      return Container(
                        height: Get.width * 0.1,
                        width: Get.width * 0.32,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.deepPurple.withOpacity(0.1),
                              Colors.blue.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.deepPurple.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'المجموع',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: Get.width * 0.025,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: Get.width * 0.003),
                            Text(
                              formatter.format(builder.total) + ' ' + '18'.tr,
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: Get.width * 0.035,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
      body: Container(
        height: Get.height,
        child: GetBuilder<Cart_controller>(
          builder: (builder) {
            if (BoxCart.isNotEmpty) {
              return Cartslist();
            } else {
              return Center(
                child: SingleChildScrollView(
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
                          Icons.shopping_cart_outlined,
                          size: Get.width * 0.15,
                          color: Colors.grey[400],
                        ),
                      ),
                      SizedBox(height: Get.width * 0.03),
                      Text(
                        '20'.tr,
                        style: TextStyle(
                          fontSize: Get.width * 0.045,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: Get.width * 0.01),
                      Text(
                        'أضف منتجات إلى سلة التسوق',
                        style: TextStyle(
                          fontSize: Get.width * 0.035,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  SizedBox spaceH(double size) {
    return SizedBox(height: size);
  }

  SizedBox spaceW(double size) {
    return SizedBox(width: size);
  }

  // تصميم جديد لعنصر المنتج
  Widget BestProductItem(
    String title,
    int price,
    String url,
    int id,
    int count,
    int category,
    int index,
    String color,
    String size,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Get.width * 0.04,
        vertical: Get.width * 0.02,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(Get.width * 0.04),
        child: Row(
          children: [
            // صورة المنتج
            Container(
              height: Get.width * 0.2,
              width: Get.width * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.deepPurple,
                            ),
                          ),
                        ),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.grey[400],
                          size: Get.width * 0.06,
                        ),
                      ),
                ),
              ),
            ),
            SizedBox(width: Get.width * 0.04),
            // تفاصيل المنتج
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // عنوان المنتج
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: Get.width * 0.035,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: Get.width * 0.02),
                  // السعر
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.03,
                      vertical: Get.width * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      formatter.format(price) + ' ' + '18'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.deepPurple,
                        fontSize: Get.width * 0.032,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // العمود الجانبي (حذف + كمية)
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                // زر الحذف
                GetBuilder<Cart_controller>(
                  builder: (builder) {
                    return GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(Get.width * 0.015),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.red,
                          size: Get.width * 0.04,
                        ),
                      ),
                      onTap: () {
                        builder.deleteData(index);
                      },
                    );
                  },
                ),
                SizedBox(height: Get.width * 0.01),
                // عداد الكمية
                GetBuilder<Cart_controller>(
                  builder: (builder) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.02,
                        vertical: Get.width * 0.005,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepPurple,
                            Colors.deepPurple.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.shopping_bag,
                            color: Colors.white,
                            size: Get.width * 0.025,
                          ),
                          SizedBox(width: Get.width * 0.005),
                          Text(
                            '${count}',
                            style: TextStyle(
                              fontSize: Get.width * 0.025,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // قائمة المنتجات
  Widget Cartslist() {
    return GetBuilder<Cart_controller>(
      builder:
          (builder) => ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.02,
              vertical: Get.width * 0.02,
            ),
            shrinkWrap: true,
            itemCount: BoxCart.length,
            itemBuilder: (BuildContext context, int index) {
              final product = BoxCart.getAt(index);
              return BestProductItem(
                product.title,
                product.price,
                product.image,
                product.item,
                product.count,
                product.category,
                index,
                product.color,
                product.size,
              );
            },
          ),
    );
  }
}
