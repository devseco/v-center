import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/controllers/Cart_controller.dart';
import 'package:ecommerce/controllers/Checkout_controller.dart';
import 'package:ecommerce/controllers/Delivery_controller.dart';
import 'package:ecommerce/views/Payment.dart';

import 'ConfirmationPage.dart';
import 'Delivery.dart';

class Checkout extends StatelessWidget {
  Checkout({super.key});
  final Checkout_controller controller = Get.find();
  final Cart_controller cart_controller = Get.put(Cart_controller());
  final Delivery_controller delivery_controller = Get.put(
    Delivery_controller(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leadingWidth: Get.width * 0.2,
        leading: Container(
          margin: EdgeInsets.all(Get.width * 0.02),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.deepPurple),
            onPressed: () => Get.back(),
          ),
        ),
        centerTitle: true,
        title: Text(
          '54'.tr,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: Get.width * 0.045,
            color: Colors.deepPurple,
          ),
        ),
      ),
      body: GetBuilder<Checkout_controller>(
        builder: (builder) {
          return Container(
            margin: EdgeInsets.all(Get.width * 0.02),
            child: Stepper(
              elevation: 0,
              type: StepperType.horizontal,
              currentStep: builder.currentStep,
              onStepContinue: builder.ContinueStap,
              onStepCancel: builder.CancelStap,
              steps: [
                Step(
                  title: Text('44'.tr),
                  content: Delivery(), // Define DeliveryForm widget
                  isActive: builder.currentStep >= 0,
                ),
                Step(
                  title: Text('45'.tr),
                  content: Payment(), // Define PaymentForm widget
                  isActive: builder.currentStep >= 1,
                ),
                Step(
                  title: Text('46'.tr),
                  content: ConfirmationPage(), // Define ConfirmationPage widget
                  isActive: builder.currentStep >= 2,
                ),
              ],
              controlsBuilder: (
                BuildContext context,
                ControlsDetails controls,
              ) {
                if (controller.currentStep != 2) {
                  return Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: Get.height * 0.01,
                    ),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () async {
                            if (controller.currentStep == 1) {
                              print(43);
                              await controller.addBill(
                                delivery_controller.phone.text,
                                '',
                                '',
                                controller.price,
                                controller.delivery,
                                BoxCart,
                                '',
                                '',
                                controller.near,
                              );
                              controls.onStepContinue!();
                            } else {
                              if (delivery_controller.name.text.isNotEmpty &&
                                  delivery_controller.phone.text.isNotEmpty) {
                                if (delivery_controller.isValidPhoneNumber(
                                  delivery_controller.phone.text,
                                )) {
                                  controls.onStepContinue!();
                                } else {
                                  Get.snackbar('67'.tr, '91'.tr);
                                }
                              } else {
                                Get.snackbar('67'.tr, '66'.tr);
                              }
                            }
                          },
                          child: Container(
                            height: Get.height * 0.04,
                            width: Get.height * 0.1,
                            margin: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              color: Colors.deepPurple,
                              border: Border.all(
                                color: Colors.deepPurple,
                                width: 0.1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                (controller.currentStep > 0)
                                    ? '65'.tr
                                    : '51'.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Get.height * 0.015,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: Get.height * 0.015),
                        (controller.currentStep == 1)
                            ? GestureDetector(
                              onTap: controls.onStepCancel,
                              child: Container(
                                height: Get.height * 0.04,
                                width: Get.height * 0.1,
                                margin: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  color: Colors.white12,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 0.1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '52'.tr,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: Get.height * 0.015,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            : SizedBox(),
                      ],
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
