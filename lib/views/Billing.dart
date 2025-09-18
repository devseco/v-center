import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ecommerce/controllers/Billing_controller.dart';
import 'package:ecommerce/main.dart';

class Billing extends StatelessWidget {
  Billing({super.key});
  final Billing_controller controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        spaceH(Get.height * 0.015),
        spaceH(Get.height * 0.01),
        Obx(() {
          if (!controller.isLoadingBills.value) {
            if (controller.filters.isNotEmpty) {
              return Expanded(child: BillList());
            } else {
              return Center(
                child: Text(
                    'لا توجد فواتير حالياً'), // تم تحديث النص ليتناسب مع اللغة المستخدمة
              );
            }
          } else {
            return loading_(); // تم تحديث النص ليتناسب مع اللغة المستخدمة
          }
        }),
        spaceH(Get.height * 0.015),
      ],
    ));
  }

  loading_() {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.black,
        size: 80,
      ),
    );
  }

  Widget filterList() {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      scrollDirection: Axis.horizontal,
      children: controller.filters
          .asMap() // تحويل القائمة إلى خريطة تحتوي على الفهرس
          .entries
          .map(
        (entry) {
          int index = entry.key; // الحصول على الفهرس
          String filter = entry.value; // الحصول على القيمة
          return FilterBox(filter, index); // تمرير الفهرس إلى الدالة
        },
      ).toList(),
    );
  }

  Widget FilterBox(String filter, int index) {
    final controller = Get.find<Billing_controller>();
    return GestureDetector(
      onTap: () {
        controller.filterBillsByStatus(index);
        // تحديث القيمة المحددة
        controller.selectedFilter.value = filter;
      },
      child: Obx(() => Container(
            width: Get.width * 0.25,
            padding: const EdgeInsets.all(5),
            margin: EdgeInsets.only(
                left: Get.width * 0.02, right: Get.width * 0.02),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
              // تغيير لون الخلفية بناءً على العنصر المحدد
              color: controller.selectedFilter.value == filter
                  ? Colors.deepPurple
                  : Colors.transparent,
            ),
            child: Center(
              child: Text(
                filter,
                style: TextStyle(
                  color: controller.selectedFilter.value == filter
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
          )),
    );
  }

  BillList() {
    return GetBuilder<Billing_controller>(
      builder: (controller) => RefreshIndicator(
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(
                right: Get.height * 0.009,
                left: Get.height * 0.009,
                top: Get.height * 0.01),
            shrinkWrap: true,
            itemCount: controller.filteredBillsList.length,
            itemBuilder: (BuildContext context, int index) {
              final BillOne = controller.filteredBillsList[index];
              print(controller.filteredBillsList[index].date);

              return BillItem(
                  BillOne.price,
                  BillOne.delivery,
                  BillOne.city,
                  BillOne.address,
                  BillOne.date.toString(),
                  BillOne.status,
                  BillOne.phone,
                  BillOne.id);
            },
          ),
          onRefresh: () async {
            controller.fetchBills();
            controller.filteredBillsList = controller.billsList;
            controller.selectedFilter('الكل');
          }),
    );
  }

  BillItem(int price, int delivery, String city, String address, String date,
      int status, String phone, int id) {
    var finalTotal = price + delivery;
    var status_code;
    var itemIcon;
    var itemColor;
    print(status);

    switch (status) {
      case 0:
        status_code = 'قيد المراجعة';
        itemIcon = const FaIcon(
          FontAwesomeIcons.clock,
          size: 15,
          color: Colors.grey,
        );
        itemColor = Colors.grey;
        break;
      case 2:
        status_code = 'قيد التجهيز';
        itemIcon = const FaIcon(
          FontAwesomeIcons.hourglass,
          size: 15,
          color: Colors.grey,
        );
        itemColor = Colors.grey;
        break;
      case 3:
        status_code = 'قيد التوصيل';
        itemIcon = const FaIcon(
          FontAwesomeIcons.car,
          size: 15,
          color: Colors.blue,
        );
        itemColor = Colors.blue;
        break;
      case 4:
        status_code = 'مكتملة';
        itemIcon = const FaIcon(
          FontAwesomeIcons.circleCheck,
          size: 15,
          color: Colors.green,
        );
        itemColor = Colors.green;
        break;
      case 5:
        status_code = 'راجعة';
        itemIcon = const FaIcon(
          FontAwesomeIcons.circleMinus,
          size: 15,
          color: Colors.redAccent,
        );
        itemColor = Colors.redAccent;
        break;
      default:
        break;
    }
    String formattedDate = date.toString();
    print(formattedDate);
    return GestureDetector(
      onTap: () {
        Get.toNamed('/Item_Billing', arguments: [
          {'id': id}
        ]);
      },
      child: Container(
        height: Get.height * 0.2,
        padding: EdgeInsets.all(Get.height * 0.017),
        margin: EdgeInsets.only(top: Get.height * 0.01),
        width: Get.height * 0.2,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black12),
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: Stack(
          children: [
            PositionedDirectional(
              bottom: Get.height * 0.01,
              end: Get.height * 0.005,
              child: SizedBox(
                child: Text(
                  '${formattedDate}',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              bottom: Get.height * 0.04,
              end: Get.height * 0.005,
              child: SizedBox(
                child: Text(
                  ' #${id} ${'71'.tr}',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              bottom: Get.height * 0.01,
              start: Get.height * 0.005,
              child: SizedBox(
                child: Row(
                  children: [
                    Text(
                      '${'72'.tr}',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple),
                    ),
                    spaceW(Get.height * 0.01),
                    const Icon(
                      Icons.remove_red_eye_outlined,
                      color: Colors.deepPurple,
                    )
                  ],
                ),
              ),
            ),
            PositionedDirectional(
              bottom: Get.height * 0.04,
              start: Get.height * 0.005,
              child: Row(
                children: [
                  Text(
                    '${status_code}',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: itemColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  spaceW(10),
                  itemIcon,
                ],
              ),
            ),
            PositionedDirectional(
              top: Get.height * 0.01,
              start: Get.height * 0.005,
              child: SizedBox(
                width: Get.height * 0.25,
                child: Text(
                  '${'47'.tr} : ${formatter.format(price)} ${'18'.tr}',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              top: Get.height * 0.04,
              start: Get.height * 0.005,
              child: SizedBox(
                width: Get.height * 0.25,
                child: Text(
                  '${'48'.tr} : ${formatter.format(delivery)} ${'18'.tr}',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              top: Get.height * 0.07,
              start: Get.height * 0.005,
              child: SizedBox(
                width: Get.height * 0.25,
                child: Text(
                  '${'88'.tr} : ${formatter.format(finalTotal)} ${'18'.tr}',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showDialog() {
    return Get.dialog(
        barrierDismissible: false,
        Dialog(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Center(
                    child: Text("76".tr),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GetBuilder<Billing_controller>(
                    builder: (c) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              c.changeSelected(0);
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5.0),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.blueAccent, width: 0.5),
                                  color: (c.selectedIndex == 0)
                                      ? Colors.deepPurple
                                      : Colors.white),
                              child: Text(
                                '77'.tr,
                                style: TextStyle(
                                    color: (c.selectedIndex == 0)
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                          spaceW(5),
                          GestureDetector(
                            onTap: () {
                              c.changeSelected(1);
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5.0),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  color: (c.selectedIndex == 1)
                                      ? Colors.deepPurple
                                      : Colors.white,
                                  border: Border.all(
                                      color: Colors.blueAccent, width: 0.5)),
                              child: Text(
                                '78'.tr,
                                style: TextStyle(
                                    color: (c.selectedIndex == 1)
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const Divider(
                  color: Colors.green,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: Get.back,
                        child: Container(
                          child: Text('53'.tr),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Padding filtersIcon() {
    return Padding(
      padding: EdgeInsetsDirectional.only(
          start: Get.height * 0.009, end: Get.height * 0.009),
      child: GestureDetector(
        onTap: showDialog,
        child: const Icon(Icons.tune),
      ),
    );
  }

  Padding searchTextInput() {
    return Padding(
      padding: EdgeInsetsDirectional.only(
          start: Get.height * 0.02, end: Get.height * 0.002),
      child: SizedBox(
          width: Get.width * 0.83,
          child: TextField(
            decoration: InputDecoration(
              fillColor: const Color(0xfff1ebf1),
              filled: true,
              prefixIcon: const Icon(Icons.search),
              hintText: '70'.tr,
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: BorderSide(
                  color: Color(0xfff1ebf1),
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: BorderSide(
                  color: Color(0xfff1ebf1),
                ),
              ),
            ),
          )),
    );
  }

  Padding logo() {
    return Padding(
      padding: EdgeInsetsDirectional.only(
          start: Get.height * 0.02, top: Get.height * 0.01),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back_ios),
          ),
          Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.fill,
            width: Get.height * 0.06,
            height: Get.height * 0.03,
          ),
          Text(
            '0'.tr,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: Get.height * 0.018),
          )
        ],
      ),
    );
  }

  Padding actions() {
    return Padding(
      padding: EdgeInsetsDirectional.only(
          start: Get.height * 0.02,
          top: Get.height * 0.01,
          end: Get.height * 0.02),
      child: Row(
        children: [
          spaceW(Get.height * 0.01),
          const Icon(Icons.favorite_border_outlined),
          spaceW(Get.height * 0.01),
          const Icon(Icons.shopping_cart_outlined),
          spaceW(Get.height * 0.01),
        ],
      ),
    );
  }

  SizedBox spaceH(double size) {
    return SizedBox(
      height: size,
    );
  }

  SizedBox spaceW(double size) {
    return SizedBox(
      width: size,
    );
  }
}
