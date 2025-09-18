import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/controllers/Checkout_controller.dart';

class ConfirmationPage extends StatelessWidget {
  ConfirmationPage({super.key});
  final Checkout_controller checkout_controller = Get.put(
    Checkout_controller(),
  );
  @override
  Widget build(BuildContext contex) {
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple.withOpacity(0.05),
            Colors.blue.withOpacity(0.05),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: GetBuilder<Checkout_controller>(
        builder: (builder) {
          return Center(
            child: Container(
              margin: EdgeInsets.all(Get.width * 0.04),
              padding: EdgeInsets.all(Get.width * 0.06),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // أيقونة الحالة
                  Container(
                    padding: EdgeInsets.all(Get.width * 0.04),
                    decoration: BoxDecoration(
                      color:
                          (builder.isPay.value)
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      (builder.isPay.value)
                          ? Icons.check_circle
                          : Icons.error_outlined,
                      color: (builder.isPay.value) ? Colors.green : Colors.red,
                      size: Get.width * 0.15,
                    ),
                  ),

                  SizedBox(height: Get.height * 0.03),

                  // رسالة الحالة
                  Text(
                    (builder.isPay.value) ? '55'.tr : '68'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Get.width * 0.05,
                      fontWeight: FontWeight.w700,
                      color:
                          (builder.isPay.value)
                              ? Colors.green[700]
                              : Colors.red[700],
                    ),
                  ),

                  SizedBox(height: Get.height * 0.02),

                  // رسالة إضافية
                  Text(
                    (builder.isPay.value)
                        ? 'تم إرسال طلبك بنجاح! سنتواصل معك قريباً'
                        : 'حدث خطأ أثناء إرسال الطلب، يرجى المحاولة مرة أخرى',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Get.width * 0.035,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),

                  SizedBox(height: Get.height * 0.04),

                  // زر العودة للرئيسية
                  GestureDetector(
                    onTap: () {
                      Get.offNamed('/');
                    },
                    child: Container(
                      height: Get.height * 0.055,
                      width: Get.width * 0.6,
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
                        child: Text(
                          '52'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Get.width * 0.04,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
