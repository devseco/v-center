import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ecommerce/controllers/ItemBilling_controller.dart';
import 'package:ecommerce/main.dart';

class Item_Billing extends StatelessWidget {
  Item_Billing({super.key});
  final ItemBilling_controller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        scrolledUnderElevation: 0.0,
        surfaceTintColor: Colors.white,
        elevation: 0.0,
        leadingWidth: Get.height * 0.09,
        leading: Padding(
          padding: EdgeInsetsDirectional.only(
            start: Get.height * 0.03,
            top: Get.height * 0.02,
          ),
          child: GestureDetector(
            child: Text(
              '53'.tr,
              style: TextStyle(
                fontSize: Get.height * 0.017,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () => Get.back(),
          ),
        ),
        centerTitle: true,
        title: Text(
          '79'.tr,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: Get.width * 0.045,
          ),
        ),
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Column(
          children: [
            GetBuilder<ItemBilling_controller>(
              builder: (builder) {
                if (!builder.LoadingItem.value) {
                  if (builder.SalesList.isNotEmpty) {
                    int totalPrice =
                        builder.SalesList[0].price +
                        builder.SalesList[0].delivery;
                    String formattedDate = DateFormat(
                      'yyyy-MM-dd hh:mm a',
                    ).format(builder.SalesList[0].date);
                    //total , id , status , date,price,delivery , customer_nearpoint ,city , address , phone
                    return card(
                      totalPrice,
                      builder.SalesList[0].id,
                      builder.SalesList[0].status,
                      formattedDate,
                      builder.SalesList[0].price,
                      builder.SalesList[0].delivery,
                      builder.SalesList[0].nearpoint,
                      builder.SalesList[0].city,
                      builder.SalesList[0].address,
                      builder.SalesList[0].phone,
                      builder.SalesList[0].image,
                    );
                  } else {
                    return Center(child: Text('20'.tr));
                  }
                } else {
                  return loading_();
                }
              },
            ),
            Expanded(child: Cartslist()),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  loading_() {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.black,
        size: Get.width * 0.15,
      ),
    );
  }

  card(
    total,
    id,
    status,
    date,
    price,
    delivery,
    customer_nearpoint,
    city,
    address,
    phone,
    image,
  ) {
    var status_code;
    var itemIcon;
    var itemColor;
    var nearPoint;
    if (customer_nearpoint == null) {
      nearPoint = '';
    } else {
      nearPoint = customer_nearpoint;
    }
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
    return Card(
      // Set the shape of the card using a rounded rectangle border with a 8 pixel radius
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      // Set the clip behavior of the card
      clipBehavior: Clip.antiAliasWithSaveLayer,
      // Define the child widgets of the card
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Display an image at the top of the card that fills the width of the card and has a height of 160 pixels
          Container(
            height: Get.height * 0.25,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: Image.asset(
                'assets/images/relaxed-male.jpg',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.fromLTRB(
              Get.width * 0.04,
              Get.height * 0.02,
              Get.width * 0.04,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${formatter.format(price + delivery)} ${'18'.tr}',
                  style: TextStyle(
                    fontSize: Get.width * 0.06,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Add a space between the title and the text
                SizedBox(height: 10),

                // Display the card's text using a font size of 15 and a light grey color
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${'47'.tr} : ${formatter.format(price)} ${'18'.tr}',
                        style: TextStyle(
                          fontSize: Get.width * 0.032,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: Get.width * 0.02),
                    Expanded(
                      child: Text(
                        '${'44'.tr} : ${formatter.format(delivery)} ${'18'.tr}',
                        style: TextStyle(
                          fontSize: Get.width * 0.032,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  '${'58'.tr} : ${city} - ${address} - ${nearPoint}',
                  style: TextStyle(
                    fontSize: Get.width * 0.032,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '${'83'.tr} : ${phone}',
                  style: TextStyle(
                    fontSize: Get.width * 0.032,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 10),
                // Add a row with two buttons spaced apart and aligned to the right side of the card
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            status_code,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: itemColor,
                              fontWeight: FontWeight.bold,
                              fontSize: Get.width * 0.035,
                            ),
                          ),
                          SizedBox(width: Get.width * 0.02),
                          itemIcon,
                          SizedBox(width: Get.width * 0.03),
                          Text(
                            '#${'71'.tr} ${id}',
                            style: TextStyle(
                              fontSize: Get.width * 0.035,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Add a text button labeled "SHARE" with transparent foreground color and an accent color for the text
                    Text(
                      '${date}',
                      style: TextStyle(
                        fontSize: Get.width * 0.035,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Add a small space between the card and the next widget
          Container(height: 10),
        ],
      ),
    );
  }

  Cartslist() {
    return GetBuilder<ItemBilling_controller>(
      builder:
          (builder) => ListView.builder(
            padding: EdgeInsets.only(
              right: Get.width * 0.02,
              left: Get.width * 0.02,
              top: Get.height * 0.01,
            ),
            // to disable GridView's scrolling
            shrinkWrap: true, // You won't see infinite size error
            itemCount: builder.SalesList.length,
            itemBuilder: (BuildContext context, int index) {
              final item = builder.SalesList[index];
              return BestProductItem(
                item.title,
                item.priceItem,
                item.image,
                item.count,
              );
            },
          ),
    );
  }

  BestProductItem(String title, int price, String url, int count) {
    return Container(
      height: Get.height * 0.12,
      padding: EdgeInsets.all(Get.width * 0.03),
      margin: EdgeInsets.only(
        top: Get.height * 0.01,
        left: Get.width * 0.02,
        right: Get.width * 0.02,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // صورة المنتج
          Container(
            height: Get.height * 0.08,
            width: Get.width * 0.2,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.deepPurple,
                          ),
                        ),
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.grey[400],
                        size: Get.width * 0.05,
                      ),
                    ),
              ),
            ),
          ),

          SizedBox(width: Get.width * 0.03),

          // تفاصيل المنتج
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // عنوان المنتج
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Get.width * 0.035,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: Get.height * 0.005),

                // سعر المنتج
                Text(
                  '${formatter.format(price)} ${'18'.tr}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.deepPurple,
                    fontSize: Get.width * 0.032,
                  ),
                ),
              ],
            ),
          ),

          // عدد القطع
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.02,
              vertical: Get.height * 0.005,
            ),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${count}',
              style: TextStyle(
                fontSize: Get.width * 0.03,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
