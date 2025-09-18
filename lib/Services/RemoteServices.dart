import 'dart:convert';
import 'package:ecommerce/models/SubCategory.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerce/models/Bill.dart';
import 'package:ecommerce/models/Category.dart';
import 'package:ecommerce/models/Product.dart';
import 'package:ecommerce/models/ProductsModel.dart';
import 'package:ecommerce/models/Sale.dart';
import 'package:ecommerce/models/SizeModel.dart';
import 'package:ecommerce/models/UserInfo.dart';
import '../models/Slider.dart';

class RemoteServices {
  static var client = http.Client();
  static var baseUrl = 'http://145.223.33.238:9099/aqs/api/v1/';
  //Login
  static Future login(phone, password) async {
    var endpoint = 'login';
    var body = jsonEncode({'phone': phone, 'password': password});
    try {
      var response = await client.post(
        Uri.parse(baseUrl + endpoint),
        body: body,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        var jsonData = response.body;

        return jsonData;
      } else {
        String rawJson =
            '{"message":"An unexpected error occurred","Status_code":500}';
        return rawJson;
      }
    } catch (e) {
      String rawJson =
          '{"message":"An unexpected error occurred","Status_code":500}';
      return rawJson;
    }
  }

  static Future deleteAccount(name, user_id) async {
    var endpoint = 'deleteAccount';
    var body = jsonEncode({'name': name, 'user_id': user_id.toString()});
    try {
      var response = await client.post(
        Uri.parse(baseUrl + endpoint),
        body: body,
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        var jsonData = response.body;
        return jsonData;
      } else {
        String rawJson =
            '{"message":"An unexpected error occurred","Status_code":500}';
        return rawJson;
      }
    } catch (e) {
      String rawJson =
          '{"message":"An unexpected error occurred","Status_code":500}';
      return rawJson;
    }
  }

  //Register
  static Future register(phone, name, password, city, address, near) async {
    var endpoint = 'register';
    var body = jsonEncode({
      'phone': phone,
      'name': name,
      'password': password,
      'city': city,
      'address': address,
      'near': near,
    });
    try {
      var response = await client.post(
        Uri.parse(baseUrl + endpoint),
        body: body,
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);
      var jsonData = response.body;
      return jsonData;
    } catch (e) {
      String rawJson =
          '{"message":"An unexpected error occurred","Status_code":500}';
      return rawJson;
    }
  }

  //Fetch Profile From Endpoint (userInfo)
  static Future<List<UserInfo>?> fetchProfile(id) async {
    var endpoint = 'getUser/${id}';
    try {
      var response = await client.get(Uri.parse(baseUrl + endpoint));
      if (response.statusCode == 200) {
        var jsonData = response.body;
        List<UserInfo> userinfo = userInfoFromJson(jsonData);
        print(jsonData);
        return userinfo;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //Fetch Sizes by Color
  static Future<List<SizeModel>?> fetchSize(id) async {
    var endpoint = 'getSizes/${id}';
    try {
      var response = await client.get(Uri.parse(baseUrl + endpoint));
      if (response.statusCode == 200) {
        var jsonData = response.body;
        List<SizeModel> userinfo = sizeModelFromJson(jsonData);
        return userinfo;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //Fetch Products From Endpoint (getProducts)
  static Future<List<Product>?> fetchProducts() async {
    var endpoint = 'getProducts';
    try {
      var response = await client.get(Uri.parse(baseUrl + endpoint));
      if (response.statusCode == 200) {
        var jsonData = response.body;
        List<Product> products = productFromJson(jsonData);
        return products;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<Product>?> filterProducts(String title) async {
    // ترميز النص للتعامل مع المسافات والأحرف الخاصة
    String encodedTitle = Uri.encodeComponent(title);
    var endpoint = 'filterProducts/${encodedTitle}';
    try {
      print('Full URL: ${baseUrl + endpoint}');
      var response = await client.get(Uri.parse(baseUrl + endpoint));
      print(
        'Filter products response: ${response.statusCode} - ${response.body}',
      );

      if (response.statusCode == 200) {
        var jsonData = response.body;
        if (jsonData.isNotEmpty && jsonData != '[]') {
          try {
            List<Product> products = productFromJson(jsonData);
            print('Filtered products count: ${products.length}');
            return products;
          } catch (parseError) {
            print('Error parsing products: $parseError');
            return [];
          }
        } else {
          print('Empty response from filterProducts');
          return [];
        }
      } else {
        print('Error status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error in filterProducts: $e');
      return [];
    }
  }

  static Future<List<Product>?> filterItems(String title) async {
    // ترميز النص للتعامل مع المسافات والأحرف الخاصة
    String encodedTitle = Uri.encodeComponent(title);
    var endpoint = 'FilterItems/${encodedTitle}';
    try {
      print('Calling filterItems endpoint: $endpoint');
      print('Full URL: ${baseUrl + endpoint}');
      var response = await client.get(Uri.parse(baseUrl + endpoint));
      print('FilterItems response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        var jsonData = response.body;
        if (jsonData.isNotEmpty && jsonData != '[]') {
          try {
            List<Product> products = productFromJson(jsonData);
            print('FilterItems found ${products.length} products');
            return products;
          } catch (parseError) {
            print('Error parsing FilterItems response: $parseError');
            return [];
          }
        } else {
          print('Empty response from FilterItems');
          return [];
        }
      } else {
        print('Error status code from FilterItems: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error in filterItems: $e');
      return [];
    }
  }

  //Fetch Items filter From Endpoint (getProduct)
  static Future<List<Product>?> fetchProductsRecently(
    int page,
    int limit,
  ) async {
    var endpoint = 'getProductsRecently/';
    try {
      var response = await client.get(Uri.parse(baseUrl + endpoint));
      print(
        'Fetch products response: ${response.statusCode} - ${response.body}',
      );
      if (response.statusCode == 200) {
        var jsonData = response.body;
        if (jsonData.isNotEmpty && jsonData != '[]') {
          try {
            List<Product> products = productFromJson(jsonData);
            print('Fetched products count: ${products.length}');
            return products;
          } catch (parseError) {
            print('Error parsing products: $parseError');
            return [];
          }
        } else {
          print('Empty response from fetchProductsRecently');
          return [];
        }
      } else {
        print('Error status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error in fetchProductsRecently: $e');
      return [];
    }
  }

  static Future<List<Product>?> fetchProductsLast(int page, int limit) async {
    var endpoint = 'getProductsLast/$page/$limit';
    try {
      var response = await client.get(Uri.parse(baseUrl + endpoint));
      if (response.statusCode == 200) {
        var jsonData = response.body;
        List<Product> products = productFromJson(jsonData);
        return products;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //add new bill To Endpoint (addBill)
  static Future<String> addBill(
    String name,
    String phone,
    String city,
    String address,
    int price,
    int delivery,
    List<Map<String, dynamic>> items,
    user_id,
    nearpoint,
    note,
    near,
  ) async {
    var endpoint = 'addBill';
    var body = jsonEncode({
      'name': name,
      'phone': phone,
      'city': city,
      'address': address,
      'price': price,
      'delivery': delivery,
      'items': items,
      'user_id': user_id,
      'nearPoint': nearpoint,
      'note': note,
      'near': near,
    });
    try {
      var response = await http.post(
        Uri.parse(baseUrl + endpoint),
        body: body,
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        var jsonData = response.body;
        return jsonData;
      } else {
        String rawJson =
            '{"message":"An unexpected error occurred","Status_code":500}';
        return rawJson;
      }
    } catch (e) {
      String rawJson =
          '{"message":"An unexpected error occurred","Status_code":500}';
      return rawJson;
    }
  }

  //Fetch Bills By Id From Endpoint (getBills)
  static Future<List<Bill>?> fetchBills(id) async {
    var endpoint = 'getBills/${id}';
    try {
      var response = await client.get(Uri.parse(baseUrl + endpoint));
      if (response.statusCode == 200) {
        var jsonData = response.body;
        print(baseUrl + endpoint);
        List<Bill> bills = billFromJson(jsonData);
        return bills;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //Fetch Bills By Id From Endpoint (getBills)
  static Future<List<Bill>?> fetchLatestBills(id) async {
    var endpoint = 'getBillsLastest/${id}';
    try {
      var response = await client.get(Uri.parse(baseUrl + endpoint));
      if (response.statusCode == 200) {
        var jsonData = response.body;
        print(jsonData);
        List<Bill> bills = billFromJson(jsonData);
        return bills;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //
  static Future<List<Sale>?> getBill(id) async {
    var endpoint = 'getBill/${id}';
    try {
      var response = await client.get(Uri.parse(baseUrl + endpoint));
      if (response.statusCode == 200) {
        var jsonData = response.body;
        print(response.body);
        List<Sale> Sales = saleFromJson(jsonData);
        return Sales;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Fetch Item By Id From Endpoint (getProduct)
  static Future<ProductModel?> fetchProductone(id) async {
    var endpoint = 'getProduct/${id}';
    try {
      var response = await client.get(Uri.parse(baseUrl + endpoint));
      if (response.statusCode == 200) {
        var jsonData = response.body;
        ProductModel products = productModelFromJson(jsonData);
        return products;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //Fetch Items By Category From Endpoint (getProductByCategory)
  static Future<List<Product>?> fetchProductByCate(
    id,
    idCat,
    page,
    limit,
  ) async {
    print(id);
    var endpoint = 'getProductByCategory/${id}/${idCat}/${page}/${limit}';
    try {
      print(baseUrl + endpoint);
      var response = await client.get(Uri.parse(baseUrl + endpoint));
      if (response.statusCode == 200) {
        var jsonData = response.body;
        print(baseUrl + endpoint);
        List<Product> products = productFromJson(jsonData);
        return products;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //Fetch Sliders From Endpoint (getSliders)
  static Future<List<SliderBar>?> fetchSliders() async {
    var endpoint = 'getSliders';
    try {
      var response = await client.get(Uri.parse(baseUrl + endpoint));
      if (response.statusCode == 200) {
        var jsonData = response.body;
        List<SliderBar> sliders = sliderFromJson(jsonData);
        return sliders;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //Fetch Sliders From Endpoint (getCategories)
  static Future<List<CategoryModel>?> fetchCategories() async {
    var endpoint = 'getCategories';
    try {
      var response = await client.get(Uri.parse(baseUrl + endpoint));
      if (response.statusCode == 200) {
        var jsonData = response.body;
        List<CategoryModel> categories = categoryModelFromJson(jsonData);
        return categories;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<SubCategory>?> fetchSubCategories(id) async {
    var endpoint = 'getSubCategoryByCategory/${id}';

    try {
      var response = await client.get(Uri.parse(baseUrl + endpoint));
      if (response.statusCode == 200) {
        var jsonData = response.body;
        List<SubCategory> categories = subCategoryFromJson(jsonData);
        return categories;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<String> addOrder(
    name,
    phone,
    total,
    payment_type,
    payment_number,
    payment_name,
  ) async {
    var endpoint = 'addOrder';
    var body = jsonEncode({
      'name': name,
      'phone': phone,
      'total': total,
      'payment_type': payment_type,
      'payment_number': payment_number,
      'payment_name': payment_name,
    });
    try {
      var response = await http.post(
        Uri.parse(baseUrl + endpoint),
        body: body,
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        var jsonData = response.body;
        return jsonData;
      } else {
        String rawJson = '{${response.body},"Status_code":500}';
        return rawJson;
      }
    } catch (e) {
      String rawJson =
          '{"message":"An unexpected error occurred","Status_code":500}';
      return rawJson;
    }
  }

  static Future<List<Product>?> filterProductsByCategoryAndQuery(
    int categoryId,
    int subCategoryId,
    String query,
  ) async {
    try {
      // ترميز النص للتعامل مع المسافات والأحرف الخاصة
      String encodedQuery = Uri.encodeComponent(query);
      String fullUrl =
          '${baseUrl}filterProducts/$categoryId/$subCategoryId/$encodedQuery';
      print('Full URL: $fullUrl');
      final response = await http.get(
        Uri.parse(fullUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map((item) => Product.fromJson(item)).toList();
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error filtering products: $e');
      return null;
    }
  }
}
