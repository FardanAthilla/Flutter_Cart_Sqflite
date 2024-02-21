import 'package:flutter_bookmark_sqflite/Model/ProductResponseModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductController extends GetxController {
  RxList<ProductResponseModel> productList = <ProductResponseModel>[].obs;
  RxBool isLoading = true.obs;

  Future<void> loadData() async {
    try {
      final response = await http.get(
        Uri.parse("https://fakestoreapi.com/products"),
      );

      if (response.statusCode == 200) {
        productList.value = productResponseModelFromJson(response.body);
      } else {
        print("Status code: ${response.statusCode}");
      }

      isLoading.value = false;
    } catch (e) {
      print("Error: $e");
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadData();
  }
}
