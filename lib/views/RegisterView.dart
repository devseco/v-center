import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ecommerce/controllers/RegisterController.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});
  final RegisterController controller = Get.put(RegisterController());

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
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.deepPurple.withOpacity(0.8)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                _space(Get.height * 0.05),
                _logo(),
                _space(Get.height * 0.03),
                _text(
                  "إنشاء حساب جديد",
                  Get.height * 0.03,
                  Colors.white,
                  FontWeight.w600,
                ),
                _space(Get.height * 0.01),
                _text(
                  "أدخل بياناتك لإنشاء حساب جديد",
                  Get.height * 0.015,
                  Colors.white.withOpacity(0.9),
                  FontWeight.w400,
                ),
                _space(Get.height * 0.02),
                _buildRegisterForm(),
                _space(Get.height * 0.02),
                GetBuilder<RegisterController>(
                  builder: (builder) {
                    if (builder.loading) {
                      return _buildLoadingButton();
                    } else {
                      return _buttonRegister();
                    }
                  },
                ),
                GetBuilder<RegisterController>(
                  builder: (builder) {
                    if (builder.errorRegister) {
                      return _buildError(builder.errormsg);
                    } else {
                      return SizedBox();
                    }
                  },
                ),
                _space(Get.height * 0.02),
                _buildLoginLink(),
                _space(Get.height * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _textme('الاسم الكامل', controller.name_, false),
          _space(Get.height * 0.02),
          _textme('رقم الهاتف', controller.phone_, false),
          _space(Get.height * 0.02),
          _textme('كلمة المرور', controller.password_, true),
          _space(Get.height * 0.02),
          _select(),
          _space(Get.height * 0.02),
          _textme("العنوان", controller.address_, false),
          _space(Get.height * 0.02),
          GetBuilder<RegisterController>(
            builder: (builder) {
              return Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      builder.isLocationLoading
                          ? Colors.grey.withOpacity(0.1)
                          : builder.locationPermissionGranted
                          ? Colors.deepPurple.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        builder.isLocationLoading
                            ? Colors.grey.withOpacity(0.3)
                            : builder.locationPermissionGranted
                            ? Colors.deepPurple.withOpacity(0.3)
                            : Colors.orange.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    if (builder.isLocationLoading)
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.grey,
                          ),
                        ),
                      )
                    else
                      Icon(
                        builder.locationPermissionGranted
                            ? Icons.location_on
                            : Icons.location_off,
                        color:
                            builder.locationPermissionGranted
                                ? Colors.deepPurple
                                : Colors.orange,
                        size: 20,
                      ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            builder.isLocationLoading
                                ? 'جاري تحديد الموقع...'
                                : builder.locationPermissionGranted
                                ? 'أقرب فرع لك هو ${builder.closestPoint}'
                                : builder.closestPoint,
                            style: TextStyle(
                              color:
                                  builder.isLocationLoading
                                      ? Colors.grey
                                      : builder.locationPermissionGranted
                                      ? Colors.deepPurple
                                      : Colors.orange,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (!builder.locationPermissionGranted &&
                              !builder.isLocationLoading)
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      builder.retryLocationPermission();
                                    },
                                    child: Text(
                                      'إعادة المحاولة',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  if (builder.closestPoint.contains(
                                    'خدمات الموقع',
                                  )) ...[
                                    Text(
                                      ' • ',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.find<RegisterController>()
                                            .showLocationServiceDialog();
                                      },
                                      child: Text(
                                        'فتح الإعدادات',
                                        style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildError(error) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.error_outline, color: Colors.red[700], size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'خطأ في إنشاء الحساب',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${error}',
                  style: TextStyle(
                    color: Colors.red[600],
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      height: Get.height * 0.055,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return GestureDetector(
      onTap: () {
        Get.offNamed('/');
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24),
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Center(
          child: Text(
            'لديك حساب بالفعل؟',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Image.asset("assets/images/logo.png", height: Get.height / 8),
      ),
    );
  }

  Widget _text(String title, double size, Color color, FontWeight fontWeight) {
    return Center(
      child: Text(
        title,
        style: TextStyle(fontSize: size, fontWeight: fontWeight, color: color),
      ),
    );
  }

  SizedBox _space(double size) {
    return SizedBox(height: size);
  }

  Widget _select() {
    return GetBuilder<RegisterController>(
      builder: (builder) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
              ),
              isExpanded: true,
              hint: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'اختر المحافظة',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              items:
                  builder.gonvernorates
                      .map(
                        (String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
              value: builder.selectedGovernorate,
              onChanged: (value) {
                builder.changeSelect(value);
              },
              buttonStyleData: ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              menuItemStyleData: MenuItemStyleData(height: 50),
            ),
          ),
        );
      },
    );
  }

  Widget _textme(
    String title,
    TextEditingController textEditingController,
    bool ispassword,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        obscureText: ispassword,
        controller: textEditingController,
        decoration: InputDecoration(
          hintText: title,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          prefixIcon: Icon(
            _getIconForField(title),
            color: Colors.grey[500],
            size: 20,
          ),
        ),
      ),
    );
  }

  IconData _getIconForField(String fieldType) {
    switch (fieldType) {
      case 'الاسم الكامل':
        return Icons.person_outline;
      case 'رقم الهاتف':
        return Icons.phone_outlined;
      case 'كلمة المرور':
        return Icons.lock_outline;
      case 'العنوان':
        return Icons.location_on_outlined;
      default:
        return Icons.edit_outlined;
    }
  }

  Widget _buttonRegister() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () {
          controller.register();
        },
        child: Container(
          height: Get.height * 0.055,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.deepPurple.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.3),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              "إنشاء الحساب",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
