import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ecommerce/controllers/Checkout_controller.dart';
import 'package:ecommerce/main.dart';

class Payment extends StatelessWidget {
  Payment({super.key});
  final Checkout_controller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          message(),
          paymentlist(),
          GetBuilder<Checkout_controller>(
            builder: (builder) {
              return order(builder.price, builder.total_user, builder.profit);
            },
          ),
        ],
      ),
    );
  }

  order(price, total_user, profit) {
    return Container(
      margin: EdgeInsets.all(Get.width * 0.04),
      padding: EdgeInsets.all(Get.width * 0.04),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple.withOpacity(0.05),
            Colors.blue.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.receipt_long,
                  color: Colors.deepPurple,
                  size: Get.width * 0.06,
                ),
              ),
              SizedBox(width: Get.width * 0.03),
              Text(
                '${'50'.tr}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Get.width * 0.045,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),

          spaceH(Get.height * 0.03),

          // تفاصيل الأسعار
          _buildPriceRow(
            '${'47'.tr} : ',
            '${formatter.format(price)} ${'18'.tr}',
            false,
          ),

          // خط فاصل
          Padding(
            padding: EdgeInsets.symmetric(vertical: Get.height * 0.015),
            child: Divider(
              color: Colors.deepPurple.withOpacity(0.2),
              thickness: 1,
            ),
          ),

          // المجموع الكلي
          _buildPriceRow(
            '${'49'.tr} : ',
            '${formatter.format(price)} ${'18'.tr}',
            true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, bool isTotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Get.width * 0.035,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
            color: isTotal ? Colors.deepPurple : Colors.black87,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: Get.width * 0.035,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
            color: isTotal ? Colors.deepPurple : Colors.black87,
          ),
        ),
      ],
    );
  }

  paymentlist() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'طريقة الدفع',
            style: TextStyle(
              fontSize: Get.width * 0.04,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          spaceH(Get.height * 0.02),

          // الدفع النقدي فقط
          Container(
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.green.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.04,
                vertical: Get.height * 0.015,
              ),
              title: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.moneyBill,
                      color: Colors.green,
                      size: Get.width * 0.06,
                    ),
                  ),
                  SizedBox(width: Get.width * 0.04),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الدفع النقدي عند الاستلام',
                          style: TextStyle(
                            fontSize: Get.width * 0.04,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[700],
                          ),
                        ),
                        Text(
                          'ادفع عند استلام طلبك بأمان وموثوقية',
                          style: TextStyle(
                            fontSize: Get.width * 0.032,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              trailing: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: Get.width * 0.05,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  message() {
    return Container(
      margin: EdgeInsets.all(Get.width * 0.04),
      padding: EdgeInsets.all(Get.width * 0.04),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple.withOpacity(0.1),
            Colors.blue.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.payment,
                  color: Colors.deepPurple,
                  size: Get.width * 0.06,
                ),
              ),
              SizedBox(width: Get.width * 0.03),
              Expanded(
                child: Text(
                  '36'.tr,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: Get.width * 0.045,
                    fontWeight: FontWeight.w700,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ],
          ),
          spaceH(Get.height * 0.015),
          Text(
            '37'.tr,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: Get.width * 0.035,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  SizedBox spaceH(double size) {
    return SizedBox(height: size);
  }

  SizedBox spaceW(double size) {
    return SizedBox(width: size);
  }
}
