import 'package:get/get.dart';
import 'package:ecommerce/models/UserInfo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import '../Services/RemoteServices.dart';
import '../main.dart';
import '../views/Login.dart';
import 'Cart_controller.dart';

class ProfileController extends GetxController {
  final isLoadingUser = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final userList = <UserInfo>[].obs;
  final isLoggedIn = false.obs;

  void checkLoginStatus() {
    var user_id = sharedPreferences?.getInt('user_id');
    isLoggedIn.value = user_id != null;
  }

  void fetchProfile() async {
    userList.clear();
    var user_id = sharedPreferences?.getInt('user_id');

    if (user_id == null) {
      hasError.value = true;
      errorMessage.value = 'User ID not found';
      isLoadingUser.value = false;
      update();
      return;
    }

    isLoadingUser.value = true;
    hasError.value = false;

    try {
      var profile = await RemoteServices.fetchProfile(user_id);
      if (profile != null && profile.isNotEmpty) {
        userList.assignAll(profile);
        hasError.value = false;
        errorMessage.value = '';
      } else {
        hasError.value = true;
        errorMessage.value = 'Failed to load profile data';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'An error occurred: ${e.toString()}';
    } finally {
      isLoadingUser.value = false;
      update();
    }
  }

  // إعادة تحميل البيانات يدوياً
  void refreshProfile() {
    fetchProfile();
  }

  void openWhatsapp() async {
    final link = WhatsAppUnilink(
      phoneNumber: '+9647765403982',
      text: "مرحبا هل يمكنني الاستفسار ؟",
    );

    final String url = link.asUri().toString();
    await launchUrl(Uri.parse(url));
  }

  void logout() {
    sharedPreferences?.clear();
    Get.offNamed('/');
  }

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
    fetchProfile();
  }

  @override
  void onReady() {
    super.onReady();
    // إعادة تحميل البيانات عند فتح الصفحة
    checkLoginStatus();
    fetchProfile();
  }

  @override
  void onClose() {
    // تنظيف البيانات عند إغلاق الصفحة
    userList.clear();
    super.onClose();
  }

  void deleteAccount() async {
    var name = sharedPreferences?.getString('name');
    var user_id = sharedPreferences?.getInt('user_id');

    if (name == null || user_id == null) {
      Get.snackbar('Error', 'User information not found');
      return;
    }

    await RemoteServices.deleteAccount(name, user_id);
    sharedPreferences?.clear();
    BoxCart.clear();
    Get.off(() => Login());
  }
}
