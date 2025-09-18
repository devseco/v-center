import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ecommerce/controllers/Login_controller.dart';

import '../Bindings/Landing_bindings.dart';
import 'Landing.dart';

class Login extends StatelessWidget {
  Login({super.key});
  final Login_controller controller = Get.put(Login_controller());

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
                  "تسجيل الدخول",
                  Get.height * 0.03,
                  Colors.white,
                  FontWeight.w600,
                ),
                _space(Get.height * 0.01),
                _text(
                  "أدخل بياناتك للدخول إلى حسابك",
                  Get.height * 0.015,
                  Colors.white.withOpacity(0.9),
                  FontWeight.w400,
                ),
                _space(Get.height * 0.035),
                _buildLoginForm(),
                _space(Get.height * 0.02),
                GetBuilder<Login_controller>(
                  builder: (builder) {
                    if (builder.loading) {
                      return _buildLoadingButton();
                    } else {
                      return _buttonLogin();
                    }
                  },
                ),
                GetBuilder<Login_controller>(
                  builder: (builder) {
                    if (builder.errorlogin) {
                      return _buildError(builder.errormsg);
                    } else {
                      return SizedBox();
                    }
                  },
                ),
                _space(Get.height * 0.02),
                _text(
                  'ليس لديك حساب؟',
                  Get.height * 0.013,
                  Colors.white.withOpacity(0.8),
                  FontWeight.w300,
                ),
                _space(Get.height * 0.03),
                _buildRegisterLink(),
                _space(Get.height * 0.03),
                _buildGuestLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
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
          _textme('رقم الهاتف', controller.phone_, false),
          _space(Get.height * 0.02),
          _textme('كلمة المرور', controller.password_, true),
          _space(Get.height * 0.02),
          _remberMeCheckBox(),
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
                  'خطأ في تسجيل الدخول',
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

  Widget _buildRegisterLink() {
    return GestureDetector(
      onTap: () {
        Get.offNamed('register');
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
            'إنشاء حساب جديد',
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

  Widget _buildGuestLink() {
    return GestureDetector(
      onTap: () {
        Get.off(() => Landing(), binding: Landing_bindings());
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24),
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'التصفح بدون حساب',
            style: TextStyle(
              color: Colors.deepPurple,
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
            ispassword ? Icons.lock_outline : Icons.phone_outlined,
            color: Colors.grey[500],
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buttonLogin() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () {
          controller.Login();
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
              "تسجيل الدخول",
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

  Widget _remberMeCheckBox() {
    return GetBuilder<Login_controller>(
      builder: (controller) {
        return Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Checkbox(
                checkColor: Colors.white,
                activeColor: Colors.deepPurple,
                value: controller.isremember,
                onChanged: (value) {
                  controller.is_checking();
                },
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'تذكرني',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
