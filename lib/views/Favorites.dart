import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:ecommerce/controllers/Favorite_controller.dart';
import '../main.dart';
class Favorites extends StatelessWidget {
   Favorites({super.key});
   final Favorite_controller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsetsDirectional.only(end: Get.height*0.02),
        child: GetBuilder<Favorite_controller>(builder: (c){
          if(BoxFavorite.length >0){
            return GestureDetector(
              onTap: (){
                c.deleteAll();
              },
              child: Container(
                padding: EdgeInsets.all(Get.height * 0.008),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(45)),
                    border: Border.all(color: Colors.deepPurple,width: 1.0)
                ),
                child: Icon(Icons.delete , color: Colors.white,),
              ),
            );
          }else{
            return SizedBox();
          }
        },),
      ),
      appBar: AppBar(
        forceMaterialTransparency: true,
        scrolledUnderElevation:0.0,
        surfaceTintColor: Colors.transparent,
        leadingWidth: Get.height * 0.3,
        leading: logo(),
      ),
      body: SafeArea(
          child: Column(
            children: [
              spaceH(Get.height * 0.015),
              GetBuilder<Favorite_controller>(builder: (builder){
                  if(BoxFavorite.length > 0){
                    return Expanded(child: ItemsList());
                  }else{
                    return Center(child: Text('20'.tr),);
                  }
              })
            ],
          )),
    );
  }
   ItemsList() {
     return GridView.builder(
       padding: EdgeInsets.only(right: Get.height * 0.009,left: Get.height * 0.009),
       // to disable GridView's scrolling
       shrinkWrap: true, // You won't see infinite size error
       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
         crossAxisCount: 2,
         crossAxisSpacing: 15.0,
         mainAxisSpacing: 15.0,
         childAspectRatio: 0.7,
       ),
       itemCount: BoxFavorite.length,
       itemBuilder: (BuildContext context, int index) {
         final product = BoxFavorite.getAt(index);
         return Item(
             product.image!,
             product.title!,
             product.price!,
             product.id,
             product.lastprice,
             product.rate
         );
       },
     );
   }
   Item(String url , String title , int price , int id , lastprice ,String rate){
     return GestureDetector(
       onTap: (){
         Get.toNamed('/product' , arguments: [{'id':id}]);
       },
       child: Container(
         padding: EdgeInsets.all(Get.height * 0.017),
         width: Get.height * 0.2,
         decoration: BoxDecoration(
             border: Border.all(color: Colors.black12),
             borderRadius: BorderRadius.all(Radius.circular(15))
         ),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
             Icon(Icons.favorite , color: Colors.red,),
             Center(
               child:  CachedNetworkImage(
                 height: Get.height * 0.12,
                 width: Get.height * 0.18,
                 imageUrl: url,
                 imageBuilder: (context, imageProvider) => Container(
                   decoration: BoxDecoration(
                     image: DecorationImage(
                       image: imageProvider,
                       fit: BoxFit.contain,
                     ),
                   ),
                 ),
                 placeholder: (context, url) => CircularProgressIndicator(),
                 errorWidget: (context, url, error) => const Icon(Icons.error),
               ),
             ),
             spaceH(Get.height * 0.01),
             Text(title , textAlign: TextAlign.start,
               overflow: TextOverflow.ellipsis,
               style: TextStyle(
                 fontWeight: FontWeight.bold,

               ),
             ),
             spaceH(Get.height * 0.004),
             Text('${  (sharedPreferences?.getInt('active') == 1) ? formatter.format(price) + '18'.tr  : '...' }' , textAlign: TextAlign.start,
               overflow: TextOverflow.ellipsis,
               style: TextStyle(
                 fontWeight: FontWeight.w800,
               ),
             ),
             spaceH(Get.height * 0.004),
             Text(formatter.format(lastprice) + " د.ع " , textAlign: TextAlign.start,
               overflow: TextOverflow.ellipsis,
               style: TextStyle(
                 decoration: TextDecoration.lineThrough,
                 fontWeight: FontWeight.w800,
               ),
             ),
             Row(
               children: [
                 Text('(${rate})'),
                 spaceW(Get.height * 0.005),
                 SizedBox(
                   child: RatingBar.builder(
                     initialRating: double.parse(rate),
                     minRating: 1,
                     ignoreGestures: true,
                     itemSize: 17,
                     direction: Axis.horizontal,
                     itemCount: 5,
                     allowHalfRating: true,
                     itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                     itemBuilder: (context, _) => const Icon(
                       Icons.star,
                       color: Colors.amber,
                     ),
                     onRatingUpdate: (rating) {
                       //controller.changeRate(rating);
                     },
                   ),
                 )
               ],
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
  Padding logo() {
    return Padding(padding: EdgeInsetsDirectional.only(start: Get.height * 0.02, top: Get.height * 0.01),
      child: Row(
        children: [
          GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios),
          ),
          Image.asset('assets/images/logo.png' , fit: BoxFit.fill,width: Get.height * 0.06,height: Get.height * 0.03,),
          Text('60'.tr , style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Get.height * 0.018
          ),)
        ],
      ),
    );
  }
}
