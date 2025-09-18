import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ecommerce/controllers/Checkout_controller.dart';
import 'package:ecommerce/controllers/Delivery_controller.dart';

class Delivery extends StatelessWidget {
  Delivery({super.key});
  final Delivery_controller controller = Get.put(Delivery_controller());
  final Checkout_controller checkout_controller = Get.put(
    Checkout_controller(),
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        message(),
        _space(Get.height * 0.012),
        //-----name------//
        _text("82", Get.height * 0.015, Colors.black, FontWeight.w600),
        _space(Get.height * 0.012),
        _textme("82", controller.name, false, false),
        _space(Get.height * 0.02),
        //-----phone------//
        _text("83", Get.height * 0.015, Colors.black, FontWeight.w600),
        _space(Get.height * 0.012),
        _textme("83", controller.phone, false, false),
        _space(Get.height * 0.02),
        //------city------//
        //-----note------//
      ],
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
                  Icons.person_add,
                  color: Colors.deepPurple,
                  size: Get.width * 0.06,
                ),
              ),
              SizedBox(width: Get.width * 0.03),
              Expanded(
                child: Text(
                  'تفاصيل الزبون',
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
            'الرجاء ادخال تفاصيل الزبون',
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

  line() {
    return const Divider(color: Colors.black12);
  }

  SizedBox spaceH(double size) {
    return SizedBox(height: size);
  }

  SizedBox spaceW(double size) {
    return SizedBox(width: size);
  }

  _select() {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: Get.width * 0.015,
        end: Get.width * 0.015,
      ),
      child: GetBuilder<Delivery_controller>(
        builder: (builder) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.black, width: 0.3),
            ),
            width: Get.width * 0.9,
            height: Get.width * 0.12,
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                dropdownStyleData: const DropdownStyleData(maxHeight: 200),
                isExpanded: true,
                hint: Text(
                  '59'.tr,
                  style: TextStyle(
                    fontSize: Get.height * 0.014,
                    color: Colors.grey,
                  ),
                ),
                items:
                    builder.gonvernorates
                        .map(
                          (String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: Get.height * 0.014,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                value: builder.selectedGovernorate,
                onChanged: (value) {
                  builder.changeSelect(value);
                },
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 40,
                  width: 140,
                ),
                menuItemStyleData: const MenuItemStyleData(height: 40),
              ),
            ),
          );
        },
      ),
    );
  }

  _text(String title, double size, Color color, FontWeight fontWeight) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: Get.width * 0.04,
        bottom: Get.height * 0.01,
      ),
      child: Text(
        title.tr,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: Get.width * 0.038,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  SizedBox _space(double size) {
    return SizedBox(height: size);
  }

  Padding _textme(
    String title,
    TextEditingController textEditingController,
    bool ispassword,
    bool format,
  ) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: Get.width * 0.04,
        end: Get.width * 0.04,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: TextField(
          onChanged: (value) {},
          style: TextStyle(
            fontSize: Get.width * 0.035,
            fontWeight: FontWeight.w500,
          ),
          obscureText: ispassword,
          keyboardType: (format) ? TextInputType.number : TextInputType.text,
          controller: textEditingController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.deepPurple, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.3),
                width: 1,
              ),
            ),
            hintText: title.tr,
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: Get.width * 0.035,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.04,
              vertical: Get.height * 0.015,
            ),
          ),
          inputFormatters: [
            (format)
                ? FilteringTextInputFormatter.digitsOnly
                : FilteringTextInputFormatter.singleLineFormatter,
          ],
        ),
      ),
    );
  }
}
