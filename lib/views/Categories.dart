import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ecommerce/controllers/Category_controller.dart';
class Categories extends StatelessWidget {
   Categories({super.key});
   final Category_controller controller = Get.put(Category_controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:Obx(() {
        if (!controller.isLoadingCategories.value) {
          if (controller.categoriesList.isNotEmpty) {
            return  categorieslist();
          } else {
            return Center(
              child: Text('لا توجد فئات حالياً'), // تم تحديث النص ليتناسب مع اللغة المستخدمة
            );
          }
        } else {
          return loading_(); // تم تحديث النص ليتناسب مع اللغة المستخدمة
        }
      })

    );
  }
   loading_() {
     return Center(
       child: LoadingAnimationWidget.staggeredDotsWave(
         color: Colors.black,
         size: 80,
       ),
     );
   }
   categorieslist() {
     return RefreshIndicator(
       child: GridView.builder(
       padding: EdgeInsets.only(right: Get.height * 0.009,left: Get.height * 0.009),
       // to disable GridView's scrolling
       shrinkWrap: true, // You won't see infinite size error
       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
         childAspectRatio: 0.95,
         crossAxisCount: 2,
         crossAxisSpacing: 10.0,
         mainAxisSpacing: 15.0,
       ),
       itemCount: controller.categoriesList.length,
       itemBuilder: (BuildContext context, int index) {
         final Category = controller.categoriesList[index];
         return CategoryItem(
             Category.image,
             Category.title,
             Category.id
         );
       },
     ),
         onRefresh: ()async{
       controller.fetchCategories();

         });
   }
   CategoryItem(String url , String title  , int index){
     return GestureDetector(
       onTap: (){
         Get.toNamed('/products' , arguments: [{'id':index}]);
       },
       child: Container(
         padding: EdgeInsets.all(Get.height * 0.017),
         width: Get.height * 0.2,
         decoration: BoxDecoration(
           boxShadow: [
             BoxShadow(
               color: Colors.black.withOpacity(0.1), // لون الظل مع الشفافية
               spreadRadius: 2, // مدى انتشار الظل
               blurRadius: 5, // درجة الضبابية
               offset: Offset(0, 3), // إزاحة الظل (x, y)
             ),
           ],
           color: Colors.white, // لون الحاوية

             border: Border.all(color: Colors.black12),
             borderRadius: BorderRadius.all(Radius.circular(15))
         ),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
             spaceH(Get.height * 0.02),
             Center(
               child:  CachedNetworkImage(
                 height: Get.height * 0.12,
                 width: Get.height * 0.18,
                 imageUrl: url,
                 imageBuilder: (context, imageProvider) => Container(
                   decoration: BoxDecoration(
                     image: DecorationImage(
                       image: imageProvider,
                       fit: BoxFit.scaleDown,
                     ),
                   ),
                 ),
                 placeholder: (context, url) => Center(
                   child: LoadingAnimationWidget.staggeredDotsWave(
                     color: Colors.black,
                     size: 30,
                   ),),
                 errorWidget: (context, url, error) => const Icon(Icons.error),
               ),
             ),
             spaceH(Get.height * 0.01),
             Center(
               child: Text(title , textAlign: TextAlign.start,
                 overflow: TextOverflow.ellipsis,
                 style: TextStyle(
                   fontWeight: FontWeight.bold,

                 ),
               ),
             )
           ],
         ),
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
